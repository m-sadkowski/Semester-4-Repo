package org.example;

import java.util.Comparator;

public class PersonAgeComparator implements Comparator<Person> {

    @Override
    public int compare(Person p1, Person p2) {
        int ageComparison = Integer.compare(p1.getWiek(), p2.getWiek());
        if (ageComparison != 0) {
            return ageComparison;
        }

        int lastNameComparison = p1.getNazwisko().compareTo(p2.getNazwisko());
        if (lastNameComparison != 0) {
            return lastNameComparison;
        }

        return p1.getImie().compareTo(p2.getImie());
    }
}