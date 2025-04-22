package org.example;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

public class DatabaseManager {
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");

    public static void addPersonWithChildren(Person person) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(person);
            for (Child child : person.getDzieci()) {
                em.persist(child);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public static void deletePerson(Long id) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Person person = em.find(Person.class, id);
            if (person != null) {
                em.remove(person);
            }

            transaction.commit();
            System.out.println("Usunięto osobę o ID: " + id);
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            System.out.println("Błąd usuwania: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    public static void addChildToParent(Long parentId, String childName, int childAge) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Person parent = em.find(Person.class, parentId);
            if (parent == null) {
                System.out.println("Nie znaleziono rodzica o ID: " + parentId);
                return;
            }

            Child newChild = new Child(childName, childAge);
            newChild.setRodzic(parent);
            parent.getDzieci().add(newChild);

            em.persist(newChild);
            transaction.commit();
            System.out.println("Dodano dziecko: " + childName + " (ID: " + newChild.getId() + ") do rodzica ID: " + parentId);
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            System.out.println("Błąd: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    public static void deleteChild(Long childId) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Child child = em.find(Child.class, childId);
            if (child == null) {
                System.out.println("Nie znaleziono dziecka o ID: " + childId);
                return;
            }

            Person rodzic = child.getRodzic();
            if (rodzic != null) {
                rodzic.getDzieci().remove(child);
            }

            em.remove(child);
            transaction.commit();
            System.out.println("Usunięto dziecko o ID: " + childId);
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            System.out.println("Błąd: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    public static void printAllPeople() {
        EntityManager em = emf.createEntityManager();
        try {
            List<Person> people = em.createQuery("SELECT p FROM Person p", Person.class).getResultList();
            System.out.println("\nWszystkie osoby w bazie:");
            for (Person p : people) {
                System.out.println(p);
                for (Child child : p.getDzieci()) {
                    System.out.println("  ↳ Id: "+child.getId()+" Dziecko: " + child.getImie() + " (wiek: " + child.getWiek() + ")");
                }
            }
        } finally {
            em.close();
        }
    }

    public static void printPeople(int number) {
        EntityManager em = emf.createEntityManager();
        try {
            List<Person> people = em.createQuery("SELECT p FROM Person p", Person.class)
                    .setMaxResults(number)
                    .getResultList();
            System.out.println("\nPierwsze " + number + " osoby w bazie:");
            for (Person p : people) {
                System.out.println(p);
                for (Child child : p.getDzieci()) {
                    System.out.println("  ↳ Id: " + child.getId() + " Dziecko: " + child.getImie() + " (wiek: " + child.getWiek() + ")");
                }
            }
        } finally {
            em.close();
        }
    }

    public static void printAlphabetically(int number, char mode) {
        EntityManager em = emf.createEntityManager();
        try {
            String orderByField = (mode == 's') ? "p.nazwisko" : "p.imie";  // 's' → sortuj po nazwisku, 'n' → po imieniu
            String jpql = "SELECT p FROM Person p ORDER BY " + orderByField + " ASC";

            List<Person> people = em.createQuery(jpql, Person.class)
                    .setMaxResults(number)
                    .getResultList();

            System.out.println("\nPierwsze " + number + " osoby w kolejności alfabetycznej (" +
                    ((mode == 's') ? "nazwisko" : "imię") + "):");

            for (Person p : people) {
                System.out.println(p);
                for (Child child : p.getDzieci()) {
                    System.out.println("  ↳ Id: " + child.getId() + " Dziecko: " + child.getImie() +
                            " (wiek: " + child.getWiek() + ")");
                }
            }
        } finally {
            em.close();
        }
    }

    public static void printYoungest(int number) {
        EntityManager em = emf.createEntityManager();
        try {
            List<Person> adults = em.createQuery("SELECT p FROM Person p ORDER BY p.wiek ASC", Person.class)
                    .getResultList();

            List<Child> children = em.createQuery("SELECT c FROM Child c ORDER BY c.wiek ASC", Child.class)
                    .getResultList();

            List<Object> allPeople = new ArrayList<>();
            allPeople.addAll(adults);
            allPeople.addAll(children);

            allPeople.sort((o1, o2) -> {
                int age1 = (o1 instanceof Person) ? ((Person) o1).getWiek() : ((Child) o1).getWiek();
                int age2 = (o2 instanceof Person) ? ((Person) o2).getWiek() : ((Child) o2).getWiek();
                return Integer.compare(age1, age2);
            });

            int limit = Math.min(number, allPeople.size());
            System.out.println("\n" + limit + " najmłodszych osób (łącznie z dziećmi):");

            for (int i = 0; i < limit; i++) {
                Object personOrChild = allPeople.get(i);
                if (personOrChild instanceof Person p) {
                    System.out.println( p.getImie() + " " + " (wiek: " + p.getWiek() + ")");
                } else {
                    Child c = (Child) personOrChild;
                    System.out.println(c.getImie() + " (wiek: " + c.getWiek() + ")");
                }
            }
        } finally {
            em.close();
        }
    }

    public static void printAboveAge(int number) {
        EntityManager em = emf.createEntityManager();
        try {
            List<Person> adults = em.createQuery("SELECT p FROM Person p WHERE p.wiek > :age ORDER BY p.wiek ASC", Person.class)
                    .setParameter("age", number)
                    .getResultList();

            List<Child> children = em.createQuery("SELECT c FROM Child c WHERE c.wiek > :age ORDER BY c.wiek ASC", Child.class)
                    .setParameter("age", number)
                    .getResultList();

            System.out.println("\nOsoby powyżej " + number + " roku życia:");

            for (Person p : adults) {
                System.out.println(p.getImie() + " " + p.getNazwisko() + " (wiek: " + p.getWiek() + ")");
            }

            for (Child c : children) {
                System.out.println(c.getImie() + " (wiek: " + c.getWiek() + ")");
            }

            if (adults.isEmpty() && children.isEmpty()) {
                System.out.println("Brak osób powyżej " + number + " roku życia.");
            }
        } finally {
            em.close();
        }
    }

    public static void printSurnameStart(char letter) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT p FROM Person p WHERE p.nazwisko LIKE :letter ORDER BY p.nazwisko ASC";
            List<Person> people = em.createQuery(jpql, Person.class)
                    .setParameter("letter", letter + "%")
                    .getResultList();

            System.out.println("\nOsoby z nazwiskiem zaczynającym się na literę '" + letter + "':");
            if (people.isEmpty()) {
                System.out.println("Brak osób spełniających kryteria.");
            } else {
                for (Person p : people) {
                    System.out.println(p);
                    for (Child child : p.getDzieci()) {
                        System.out.println("  ↳ Id: " + child.getId() + " Dziecko: " + child.getImie() +
                                " (wiek: " + child.getWiek() + ")");
                    }
                }
            }
        } finally {
            em.close();
        }
    }

    public static void printChildren() {
        EntityManager em = emf.createEntityManager();
        try {
            List<Person> peopleWithChildren = em.createQuery(
                    "SELECT p FROM Person p WHERE SIZE(p.dzieci) > 0", Person.class
            ).getResultList();

            System.out.println("\nOsoby posiadające dzieci:");
            if (peopleWithChildren.isEmpty()) {
                System.out.println("Brak osób posiadających dzieci.");
            } else {
                for (Person p : peopleWithChildren) {
                    System.out.println(p);
                    for (Child child : p.getDzieci()) {
                        System.out.println("  ↳ Id: " + child.getId() + " Dziecko: " + child.getImie() +
                                " (wiek: " + child.getWiek() + ")");
                    }
                }
            }
        } finally {
            em.close();
        }
    }

}
