package org.example;

import javax.persistence.*;

@Entity
public class Child {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String imie;
    private int wiek;

    // Relacja wiele do jednego - każde dziecko ma jednego rodzica.
    @ManyToOne
    @JoinColumn(name = "rodzic_id")
    private Person rodzic;

    public Child() {}

    public Child(String imie, int wiek) {
        this.imie = imie;
        this.wiek = wiek;
    }

    public Long getId() {
        return id;
    }

    public String getImie() {
        return imie;
    }

    public void setImie(String imie) {
        this.imie = imie;
    }

    public Person getRodzic() {
        return rodzic;
    }

    public int getWiek() {
        return wiek;
    }

    public void setRodzic(Person rodzic) {
        this.rodzic = rodzic;
    }

    @Override
    public String toString() {
        return "Child{" +
                "id=" + id +
                ", imie='" + imie + '\'' +
                '}';
    }
}