package org.example.data;

import org.example.Child;
import org.example.Person;

import java.util.*;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

public class PersonGenerator {

    private static final String[] IMIONA = {"Jan", "Anna", "Piotr", "Maria", "Krzysztof", "Agnieszka", "Czesław", "Miłosz",
            "Mirosław", "Wacław", "Zbigniew", "Mariusz", "Michał", "Dawid", "Antoni", "Robert"};
    private static final String[] NAZWISKA = {"Kowalski", "Nowak", "Wiśniewski", "Dąbrowski", "Lewandowski", "Pazdan", "Milik", "Glik", "Krychowiak", "Szczęsny"};
    private static final Random RANDOM = new Random();

    public synchronized static Person generateRandomPerson() {
        String imie = IMIONA[RANDOM.nextInt(IMIONA.length)];
        String nazwisko = NAZWISKA[RANDOM.nextInt(NAZWISKA.length)];
        int wiek = RANDOM.nextInt(80) + 1;
        HashSet<Child> dzieci = new HashSet<>();
        if(wiek > 20) {
            int ilosc_dzieci = RANDOM.nextInt(2);
            for(int i = 0; i < ilosc_dzieci; i++) {
                String imie_dziecka = IMIONA[RANDOM.nextInt(IMIONA.length)];
                int wiek_dziecka = wiek-20;
                dzieci.add(new Child(imie_dziecka, wiek_dziecka));
            }
        }
        Person czlowiek = new Person(imie, nazwisko, wiek);
        czlowiek.setDzieci(dzieci);
        return czlowiek;
    }

    public synchronized static List<Person> generatePeopleList(int count) {
        List<Person> peopleList = new ArrayList<>(count);
        for (int i = 0; i < count; i++) {
            peopleList.add(generateRandomPerson());
        }
        return peopleList;
    }

}
