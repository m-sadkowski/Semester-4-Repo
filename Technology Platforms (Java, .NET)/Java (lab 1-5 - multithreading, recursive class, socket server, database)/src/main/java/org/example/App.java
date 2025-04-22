package org.example;

import java.sql.SQLException;
import java.util.*;
import java.util.concurrent.*;
import org.h2.tools.Server;

public class App {
    private static final int DATA_SIZE = 2000;
    private static volatile boolean isRunning = true;
    static ExecutorService executor;

    public static void main(String[] args) throws ClassNotFoundException, SQLException {
//        if (args.length < 3) {
//            System.out.println("Podaj liczbę wątków, adres serwera i port jako argumenty");
//            // parametry do uruchomienia: Server{}, App{4 127.0.0.1 12345}
//            return;
//        }
//
//        int numberOfThreads = Integer.parseInt(args[0]);
//        String serverAddress = args[1];
//        int port = Integer.parseInt(args[2]);
//
//        Thread shutdownThread = new Thread(() -> {
//            Scanner scanner = new Scanner(System.in);
//            System.out.println("Wpisz 'exit' aby zamknąć aplikację...");
//            while (isRunning) {
//                String input = scanner.nextLine();
//                if ("exit".equalsIgnoreCase(input)) {
//                    isRunning = false;
//                    if (executor != null) {
//                        executor.shutdownNow();
//                    }
//                    System.out.println("Zamykanie aplikacji...");
//                    break;
//                }
//            }
//            scanner.close();
//        });
//        shutdownThread.setDaemon(true);
//        shutdownThread.start();
//
//        long startGen = System.currentTimeMillis();
//        List<Person> people = PersonGenerator.generatePeopleList(DATA_SIZE);
//        long endGen = System.currentTimeMillis();
//        System.out.println("Wygenerowano " + DATA_SIZE + " osób w: " + (endGen - startGen) + "ms");
//
//        long startSeq = System.currentTimeMillis();
//        double sdSeq = calculateSDSequential(people);
//        long endSeq = System.currentTimeMillis();
//        System.out.println("\nSekwencyjne odchylenie standardowe: " + sdSeq);
//        System.out.println("Czas sekwencyjnie: " + (endSeq - startSeq) + "ms");
//
//        if (!isRunning) {
//            System.out.println("Aplikacja zatrzymana.");
//            return;
//        }
//
//        long startPar = System.currentTimeMillis();
//        SharedResults sharedResults = calculateSDParallel(people, numberOfThreads);
//        assert sharedResults != null;
//        double sdPar = Math.sqrt(sharedResults.getVariance());
//        long endPar = System.currentTimeMillis();
//        System.out.println("\nOdchylenie standardowe liczone na : " + sdPar);
//        System.out.println("Czas wielowątkowo: " + (endPar - startPar) + "ms");
//
//        try (Socket socket = new Socket(serverAddress, port);
//             ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream())) {
//            oos.writeObject(sharedResults);
//            System.out.println("Wyniki przesłane do serwera.");
//        } catch (IOException e) {
//            System.err.println("Błąd połączenia z serwerem: " + e.getMessage());
//        }

        /*
        add Anna Lewandowska 35 Karolina 6 Anastazja 7
        add Karol Wiśniewski 28 Maja 5
        addchild 2 Antoni 1
        add Jan Żmudzki 40 Karol 17
        deletechild 5
        addchild 3 Karol 18
        add Mateusz Nowacki 19
        add Anastazja Napierajska 18
        add Bartosz Kurek 35 Leon 10
         */

        Server servertcp = Server.createTcpServer().start();
        Server server = Server.createWebServer().start();

        System.out.println("Server started and connection is open.");
        System.out.println("URL: jdbc:h2:" + server.getURL() + "/mem:testdb");

        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.println("\nDostępne komendy: [add] [addchild] [delete] [deletechild] [print] [printfirst] [exit]");
            System.out.println("Dostępne zapytania:");
            System.out.println("- [alphabetically]: wyświetlenie ... wyników alfabetycznie według imion[n]/nazwisk[s] - alphabetically 3 s");
            System.out.println("- [youngest]: wyświetlenie ... najmłodszych osób - youngest 5");
            System.out.println("- [aboveage]: wyświetlenie osób powyżej ... roku życia - aboveage 65");
            System.out.println("- [surname]: wyświetlenie osób z nazwiskiem na literę ... - surnamestart A");
            System.out.println("- [children]: wyświetlenie osób posiadających dzieci - children\n");
            String input = scanner.nextLine();
            if (input.startsWith("add ")) processAddCommand(input);
            else if (input.equals("exit")) break;
            else if (input.equals("print")) DatabaseManager.printAllPeople();
            else if (input.startsWith("printfirst")) processFirstPeopleCommand(input);
            else if (input.startsWith("deletechild")) processDeleteChildCommand(input);
            else if (input.startsWith("delete")) processDeleteCommand(input);
            else if (input.startsWith("addchild")) processAddChildToParent(input);

            else if (input.startsWith("alphabetically")) processAlphabeticallyCommand(input);
            else if (input.startsWith("youngest")) processYoungestCommand(input);
            else if (input.startsWith("aboveage")) processAboveAgeCommand(input);
            else if (input.startsWith("surname")) processSurnameStartCommand(input);
            else if (input.equals("children")) DatabaseManager.printChildren();
        }
        scanner.close();

        server.stop();
    }

    private static void processAddCommand(String input) {
        String[] parts = input.split(" ");
        if (parts.length < 4 || (parts.length - 1) % 2 == 0) {
            System.out.println("Nieprawidłowy format! Przykład: add Jan Kowalski 30 Anna 5");
            return;
        }

        String imie = parts[1];
        String nazwisko = parts[2];
        int wiek = Integer.parseInt(parts[3]);

        Person person = new Person(imie, nazwisko, wiek);

        for (int i = 4; i < parts.length; i +=2) {
            String imieDziecka = parts[i];
            int wiekDziecka = Integer.parseInt(parts[i + 1]);
            Child child = new Child(imieDziecka, wiekDziecka);
            person.addChild(child);
        }

        DatabaseManager.addPersonWithChildren(person);
        System.out.println("Dodano osobę: " + person);
        DatabaseManager.printAllPeople();
    }

    private static void processAddChildToParent(String input) {
        String[] parts = input.split(" ");
        if (parts.length != 4) {
            System.out.println("Nieprawidłowy format! Przykład: addChild 1 Ala 5");
            return;
        }

        Long parentId = Long.parseLong(parts[1]);
        String imie = parts[2];
        int wiek = Integer.parseInt(parts[3]);

        DatabaseManager.addChildToParent(parentId,imie,wiek);
        DatabaseManager.printAllPeople();
    }

    private static void processDeleteChildCommand(String input) {
        String[] parts = input.split(" ");
        try {
            Long childId = Long.parseLong(parts[1]);
            DatabaseManager.deleteChild(childId);
            DatabaseManager.printAllPeople();
        } catch (NumberFormatException e) {
            System.out.println("ID dziecka musi być liczbą!");
        }
    }

    private static void processAlphabeticallyCommand(String input) {
        String[] parts = input.split(" ");
        if (parts.length != 3) {
            System.out.println("Nieprawidłowy format! Przykład: alphabetically 3 s");
            return;
        }

        try {
            int number = Integer.parseInt(parts[1]);
            char mode = parts[2].charAt(0);
            if (mode != 's' && mode != 'n') {
                System.out.println("Trzeci argument musi być znakiem (s/n)! Przykład: alphabetically 3 s");
                return;
            }
            DatabaseManager.printAlphabetically(number, mode);
        } catch (NumberFormatException e) {
            System.out.println("Drugi argument musi być liczbą! Przykład: alphabetically 3 s");
        }
    }

    private static void processYoungestCommand(String input) {
        String[] parts = input.split(" ");
        if (parts.length != 2) {
            System.out.println("Nieprawidłowy format! Przykład: youngest 3");
            return;
        }

        try {
            int number = Integer.parseInt(parts[1]);
            DatabaseManager.printYoungest(number);
        } catch (NumberFormatException e) {
            System.out.println("Argument musi być liczbą! Przykład: youngest 3");
        }
    }

    private static void processAboveAgeCommand(String input) {
        String[] parts = input.split(" ");
        if (parts.length != 2) {
            System.out.println("Nieprawidłowy format! Przykład: aboveage 65");
            return;
        }

        try {
            int number = Integer.parseInt(parts[1]);
            DatabaseManager.printAboveAge(number);
        } catch (NumberFormatException e) {
            System.out.println("Argument musi być liczbą! Przykład: aboveage 65");
        }
    }

    private static void processSurnameStartCommand(String input) {
        String[] parts = input.split(" ");
        if (parts.length != 2) {
            System.out.println("Nieprawidłowy format! Przykład: surname A");
            return;
        }

        String letterStr = parts[1].trim();
        if (letterStr.length() != 1) {
            System.out.println("Argument musi być pojedynczą literą! Przykład: surname A");
            return;
        }

        char letter = letterStr.charAt(0);
        if (!Character.isLetter(letter)) {
            System.out.println("Argument musi być literą! Przykład: surname A");
            return;
        }

        DatabaseManager.printSurnameStart(letter);
    }

    private static void processDeleteCommand(String input) {
        String[] parts = input.split(" ");
        if (parts.length != 2) {
            System.out.println("Nieprawidłowy format! Przykład: delete 5");
            return;
        }

        try {
            Long id = Long.parseLong(parts[1]);
            DatabaseManager.deletePerson(id);
            DatabaseManager.printAllPeople();
        } catch (NumberFormatException e) {
            System.out.println("ID musi być liczbą! Przykład: delete 3");
        }
    }

    private static void processFirstPeopleCommand(String input) {
        String[] parts = input.split(" ");
        if (parts.length != 2) {
            System.out.println("Nieprawidłowy format! Przykład: printfirst 5");
            return;
        }

        try {
            int number = Integer.parseInt(parts[1]);
            DatabaseManager.printPeople(number);
        } catch (NumberFormatException e) {
            System.out.println("Argument musi być liczbą! Przykład: printfirst 3");
        }
    }

    private static double calculateSDSequential(List<Person> people) {
        double sum = 0;
        for (Person p : people) {
            sum += p.getWiek();
        }
        double mean = sum / people.size();

        double sumSqDiff = 0;
        for (Person p : people) {
            sumSqDiff += Math.pow(p.getWiek() - mean, 2);
        }

        return Math.sqrt(sumSqDiff / people.size());
    }

    private static SharedResults calculateSDParallel(List<Person> people, int threads) {
        executor = Executors.newFixedThreadPool(threads);
        SharedResults sharedResults = new SharedResults();

        try {
            int totalPeople = people.size();
            int chunkSize = (totalPeople + threads - 1) / threads;
            List<Callable<Void>> tasks = new ArrayList<>();

            for (int i = 0; i < threads; i++) {
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

                    sharedResults.addPartialResult(localSum, localSumSquares, localCount);
                    return null;
                });
            }

            executor.invokeAll(tasks);
            return sharedResults;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return null;
        } finally {
            executor.shutdown();
        }
    }
}
    /*
    public static void lab1(String[] args) {
        Set<Person> kids1 = new HashSet<>();
        Set<Person> kids2 = new HashSet<>();

        Person person1 = new Person("Jan", "Kowalski", 30, kids1);
        Person person2 = new Person("Anna", "Kowalska", 25, kids1);
        Person person3 = new Person("Adam", "Nowak", 35, kids2);

        Person person4 = new Person("Katarzyna", "Nowak", 9);
        Person person5 = new Person("Oliwia", "Kowalska", 5);

        kids1.add(person5);
        kids2.add(person4);

        List<Person> people = new ArrayList<>();
        people.add(person1);
        people.add(person2);
        people.add(person3);
        people.add(person4);
        people.add(person5);


        if(args.length > 0) {
            if(args[0].equals("-brak")) {
                System.out.println("Bez sortowania:");
                for (Person osoba : people) {
                    System.out.println(osoba);
                }
            }
            else if(args[0].equals("-sort")) {
                Collections.sort(people);

                System.out.println("\nZwykle sortowanie:");
                for (Person osoba : people) {
                    System.out.println(osoba);
                }
            }
            else if(args[0].equals("-altsort")) {
                people.sort(new PersonAgeComparator());

                System.out.println("\nPo alternatywnym sortowaniu:");
                for (Person person : people) {
                    System.out.println(person);
                }
            }
        }
        else {
            System.out.println("Brak argumentow");
        }

        Map<Person, Integer> stats = generateHierarchyStatistics(people, args);
        System.out.println("\nStatystyki liczby podrzędnych elementów:");
        stats.forEach((person, count) -> System.out.println(person + " -> " + count));
    }

    public static Map<Person, Integer> generateHierarchyStatistics(List<Person> people, String[] args) {
        Map<Person, Integer> stats;
        if (args.length > 0 && args[0].equals("-sort")) {
            stats = new TreeMap<>();
        } else {
            stats = new HashMap<>();
        }

        for (Person person : people) {
            stats.put(person, countAllChildren(person));
        }
        return stats;
    }

    private static int countAllChildren(Person person) {
        int count = person.getDzieci().size();
        for (Person child : person.getDzieci()) {
            count += countAllChildren(child);
        }
        return count;
    }
    */