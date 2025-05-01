package org.example;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@Entity
public class Person implements Comparable<Person>, Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String imie;
    private String nazwisko;
    private int wiek;

    @OneToMany(mappedBy = "rodzic", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Child> dzieci = new HashSet<>();

    public Person() {}

    public Person(String imie, String nazwisko, int wiek) {
        this.imie = imie;
        this.nazwisko = nazwisko;
        this.wiek = wiek;
    }

    public Long getId() {
        return id;
    }


    public void setId(Long id) { this.id = id; }

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

    public Set<Child> getDzieci() {
        return dzieci;
    }

    public void setDzieci(Set<Child> dzieci) {
        this.dzieci = dzieci;
    }

    public void addChild(Child child) {
        dzieci.add(child);
        child.setRodzic(this);
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
        return "Person{" +
                "id=" + id +
                ", imie='" + imie + '\'' +
                ", nazwisko='" + nazwisko + '\'' +
                ", wiek=" + wiek +
                '}';
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
