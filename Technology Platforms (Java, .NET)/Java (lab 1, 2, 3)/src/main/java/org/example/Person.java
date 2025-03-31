package org.example;

import java.util.Comparator;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

public class Person implements Comparable<Person> {
    private String imie;
    private String nazwisko;
    private int wiek;

    private Set<Person> dzieci;

    public Person(String imie, String nazwisko, int wiek, Set<Person> dzieci) {
        this.imie = imie;
        this.nazwisko = nazwisko;
        this.wiek = wiek;
        this.dzieci = dzieci;
    }

    public Person(String imie, String nazwisko, int wiek) {
        this.imie = imie;
        this.nazwisko = nazwisko;
        this.wiek = wiek;
        this.dzieci = new HashSet<>();
    }

    public String getImie() {
        return imie;
    }

    public void setImie(String imie) {
        this.imie = imie;
    }

    public String getNazwisko() {
        return nazwisko;
    }

    public void setNazwisko(String nazwisko) {
        this.nazwisko = nazwisko;
    }

    public int getWiek() {
        return wiek;
    }

    public void setWiek(int wiek) {
        this.wiek = wiek;
    }

    public Set<Person> getDzieci() {
        return dzieci;
    }

    public void setDzieci(Set<Person> dzieci) {
        this.dzieci = dzieci;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Person)) return false;
        Person person = (Person) o;
        return wiek == person.wiek && Objects.equals(imie, person.imie) && Objects.equals(nazwisko, person.nazwisko) && Objects.equals(dzieci, person.dzieci);
    }

    @Override
    public int hashCode() {
        return Objects.hash(imie, nazwisko, wiek, dzieci);
    }

    @Override
    public String toString() {
        return imie + " " + nazwisko + ", lat " + wiek + ", dzieci: " + dzieci;
    }

    @Override
    public int compareTo(Person other) {
        int result = this.nazwisko.compareTo(other.nazwisko);
        if (result == 0) {
            result = this.imie.compareTo(other.imie);
        }
        return result;
    }
}
