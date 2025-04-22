package org.example;

import org.example.data.PersonGenerator;

import java.io.*;
import java.net.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicBoolean;

public class Server {
    private static final int PORT = 12345;
    private static final int BATCH_SIZE = 10000;
    private static final int DATA_SIZE = 2000000;
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    private static final ExecutorService executor = Executors.newFixedThreadPool(10);
    private static final AtomicBoolean isRunning = new AtomicBoolean(true);
    private static final BlockingQueue<Person> dataQueue = new LinkedBlockingQueue<>();
    private static final SharedResults sharedResults = new SharedResults();

    public static void main(String[] args) {
        List<Person> people = PersonGenerator.generatePeopleList(DATA_SIZE);
        dataQueue.addAll(people);
        log("Wygenerowano " + DATA_SIZE + " osób");

        Thread consoleThread = new Thread(() -> {
            Scanner scanner = new Scanner(System.in);
            while (isRunning.get()) {
                try {
                    if (System.in.available() > 0) {
                        String input = scanner.nextLine();
                        if ("exit".equalsIgnoreCase(input.trim())) {
                            isRunning.set(false);
                            log("Zamykanie serwera...");
                            Thread.sleep(1000);
                            executor.shutdownNow();
                            new Socket("localhost", PORT).close();
                            sharedResults.printStatistics();
                            break;
                        }
                    } else {
                        Thread.sleep(100);
                    }
                } catch (Exception e) {
                    log("Błąd w watku konsoli: " + e.getMessage());
                }
            }
            scanner.close();
        });
        consoleThread.setDaemon(true);
        consoleThread.start();

        try (ServerSocket serverSocket = new ServerSocket(PORT)) {
            serverSocket.setSoTimeout(1000);
            log("Serwer uruchomiony na porcie " + PORT);

            while (isRunning.get()) {
                try {
                    Socket clientSocket = serverSocket.accept();
                    executor.execute(new ClientHandler(clientSocket));
                } catch (SocketTimeoutException ignored) {
                }
            }
        } catch (IOException e) {
            log("Błąd serwera: " + e.getMessage());
        } finally {
            executor.shutdown();
            log("Odchylenie standardowe: " + Math.sqrt(sharedResults.getVariance()));
        }
    }

    private static class ClientHandler implements Runnable {
        private final Socket socket;

        ClientHandler(Socket socket) {
            this.socket = socket;
        }

        @Override
        public void run() {
            try (ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
                 ObjectInputStream ois = new ObjectInputStream(socket.getInputStream())) {

                log("Klient " + socket.getInetAddress() + " połączony.");

                Object threadsNumber = ois.readObject();
                System.out.println("Otrzymana ilość wątków: " + threadsNumber);

                while (!dataQueue.isEmpty() && isRunning.get()) {
                    oos.writeObject("OK");
                    oos.flush();
                    log("Wysłano OK do klienta: " + socket.getInetAddress());

                    String clientResponse = (String) ois.readObject();
                    log("Otrzymano odpowiedź od klienta: " + clientResponse);

                    if (!"OK".equals(clientResponse)) {
                        log("Nieprawidłowa odpowiedź klienta: " + clientResponse);
                        break;
                    }

                    List<Person> batch = new ArrayList<>(BATCH_SIZE);
                    for (int i = 0; i < BATCH_SIZE*(int)threadsNumber && !dataQueue.isEmpty(); i++) {
                        Person person = dataQueue.poll();
                        if (person != null) {
                            batch.add(person);
                        }
                    }

                    if (batch.isEmpty()) {
                        log("Brak danych do wysłania. Kończę komunikację.");
                        break;
                    }

                    oos.writeObject(batch);
                    oos.flush();
                    log("Wysłano partię (" + batch.size() + " osób) do klienta: " + socket.getInetAddress());

                    double[] results = (double[]) ois.readObject();
                    sharedResults.addPartialResult(results[0], results[1], (int) results[2]);
                    log("Otrzymano wyniki od klienta: suma=" + results[0] + ", sumaKwadratów=" + results[1] + ", liczba=" + results[2]);

                    sharedResults.printStatistics();
                }

                oos.writeObject("END");
                oos.flush();
                log("Zakończono komunikację z klientem: " + socket.getInetAddress());

            } catch (IOException | ClassNotFoundException e) {
                log("Błąd obsługi klienta: " + e.getMessage());
            } finally {
                try {
                    socket.close();
                } catch (IOException e) {
                    log("Błąd zamykania gniazda: " + e.getMessage());
                }
            }
        }
    }

    private static void log(String message) {
        System.out.println("[" + sdf.format(new Date()) + "] " + message);
    }
}