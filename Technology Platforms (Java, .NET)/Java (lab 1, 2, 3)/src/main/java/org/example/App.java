package org.example;

import org.example.data.PersonGenerator;
import java.util.*;
import java.util.concurrent.*;

public class App {
    private static final int DATA_SIZE = 20000000;
    private static volatile boolean isRunning = true;
    private static ExecutorService executor;

    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Podaj liczbę wątków jako argument");
            return;
        }

        int numberOfThreads = Integer.parseInt(args[0]);

        // Wątek zamykający aplikację
        Thread shutdownThread = new Thread(() -> {
            Scanner scanner = new Scanner(System.in);
            System.out.println("Wpisz 'exit' aby zamknąć aplikację...");
            while (isRunning) {
                String input = scanner.nextLine();
                if ("exit".equalsIgnoreCase(input)) {
                    isRunning = false;
                    if (executor != null) {
                        executor.shutdownNow();
                    }
                    System.out.println("Zamykanie aplikacji...");
                    break;
                }
            }
            scanner.close();
        });
        shutdownThread.setDaemon(true);
        shutdownThread.start();

        long startGen = System.currentTimeMillis();
        List<Person> people = PersonGenerator.generatePeopleList(DATA_SIZE);
        long endGen = System.currentTimeMillis();
        System.out.println("Wygenerowano " + DATA_SIZE + " osób w: " + (endGen - startGen) + "ms");

        long startSeq = System.currentTimeMillis();
        double sdSeq = calculateSDSequential(people);
        long endSeq = System.currentTimeMillis();
        System.out.println("\nSekwencyjne odchylenie standardowe: " + sdSeq);
        System.out.println("Czas sekwencyjnie: " + (endSeq - startSeq) + "ms");

        if (!isRunning) {
            System.out.println("Aplikacja zatrzymana.");
            return;
        }

        long startPar = System.currentTimeMillis();
        double sdPar = calculateSDParallel(people, numberOfThreads);
        long endPar = System.currentTimeMillis();
        System.out.println("\nOdchylenie standardowe liczone na " + numberOfThreads + " wątkach: " + sdPar);
        System.out.println("Czas wielowątkowo: " + (endPar - startPar) + "ms");
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

    private static double calculateSDParallel(List<Person> people, int threads) {
        executor = Executors.newFixedThreadPool(threads);
        SharedResults sharedResults = new SharedResults();

        try {
            int chunkSize = people.size() / threads;
            List<Callable<Void>> tasks = new ArrayList<>();

            for (int i = 0; i < threads; i++) {
                final int start = i * chunkSize;
                final int end = (i == threads-1) ? people.size() : (i+1)*chunkSize;

                tasks.add(() -> {
                    double localSum = 0;
                    double localSumSquares = 0;
                    int localCount = 0;

                    for (int j = start; j < end; j++) {
                        if (Thread.currentThread().isInterrupted()) {
                            System.out.println("Przerwano obliczenia równoległe.");
                            break;
                        }
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
            sharedResults.printStatistics();
            return Math.sqrt(sharedResults.getVariance());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return 0;
        } finally {
            executor.shutdown();
        }
    }

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

}