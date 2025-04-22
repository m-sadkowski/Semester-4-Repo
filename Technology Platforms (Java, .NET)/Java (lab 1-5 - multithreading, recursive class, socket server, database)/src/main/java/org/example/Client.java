package org.example;

import java.io.*;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.*;

public class Client {
    private static int NUMBER_OF_THREADS = 4;
    private static final ExecutorService executor = Executors.newFixedThreadPool(NUMBER_OF_THREADS);

    public static void main(String[] args) {
        if (args.length < 3) {
            System.out.println("Podaj adres serwera i port jako argumenty");
            return;
        }

        NUMBER_OF_THREADS = Integer.parseInt(args[2]);

        String serverAddress = args[0];
        int port = Integer.parseInt(args[1]);

        try (Socket socket = new Socket(serverAddress, port);
             ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
             ObjectInputStream ois = new ObjectInputStream(socket.getInputStream())) {

            System.out.println("Połączono z serwerem: " + serverAddress + ":" + port);

            oos.writeObject(NUMBER_OF_THREADS);
            System.out.println("Wysłano ilość wątków do serwera.");

            while (true) {
                Object serverMessage = ois.readObject();
                System.out.println("Otrzymano wiadomość od serwera: " + serverMessage);

                if (serverMessage instanceof String) {
                    String message = (String) serverMessage;
                    if ("END".equals(message)) {
                        System.out.println("Otrzymano END. Zamykanie...");
                        break;
                    } else if ("OK".equals(message)) {
                        oos.writeObject("OK");
                        oos.flush();
                        System.out.println("Wysłano OK do serwera");

                        Object data = ois.readObject();
                        if (data instanceof List) {
                            List<Person> people = (List<Person>) data;
                            System.out.println("Otrzymano partię danych: " + people.size() + " osób");

                            double[] results = processBatchParallel(people);
                            oos.writeObject(results);
                            oos.flush();
                            System.out.println("Wysłano wyniki do serwera");
                        }
                    }
                }
            }
        } catch (IOException | ClassNotFoundException | InterruptedException | ExecutionException e) {
            System.err.println("Błąd klienta: " + e.getMessage());
        } finally {
            executor.shutdown();
        }
    }

    private static double[] processBatchParallel(List<Person> people) throws InterruptedException, ExecutionException {
        int totalPeople = people.size();
        int chunkSize = (totalPeople + NUMBER_OF_THREADS - 1) / NUMBER_OF_THREADS;
        List<Callable<double[]>> tasks = new ArrayList<>();

        for (int i = 0; i < NUMBER_OF_THREADS; i++) {
            final int start = i * chunkSize;
            final int end = Math.min(start + chunkSize, totalPeople);
            tasks.add(() -> {
                double localSum = 0;
                double localSumSquares = 0;
                int localCount = 0;

                for (int j = start; j < end; j++) {
                    int age = people.get(j).getWiek();
                    localSum += age;
                    localSumSquares += age * age;
                    localCount++;
                }

                return new double[]{localSum, localSumSquares, localCount};
            });
        }

        List<Future<double[]>> futures = executor.invokeAll(tasks);
        double totalSum = 0;
        double totalSumSquares = 0;
        int totalCount = 0;

        for (Future<double[]> future : futures) {
            double[] result = future.get();
            totalSum += result[0];
            totalSumSquares += result[1];
            totalCount += (int) result[2];
        }

        return new double[]{totalSum, totalSumSquares, totalCount};
    }
}