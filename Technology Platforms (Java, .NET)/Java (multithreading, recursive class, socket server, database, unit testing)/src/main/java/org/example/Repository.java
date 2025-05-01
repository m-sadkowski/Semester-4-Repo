package org.example;

import java.util.Map;
import java.util.HashMap;
import java.util.Optional;

public class Repository {
    // id - osoba
    private final Map<Long, Person> storage = new HashMap<>();

    public void save(Person person) {
        if (person.getId() != null && storage.containsKey(person.getId())) {
            throw new IllegalArgumentException("Osoba o id " + person.getId() + " już istnieje.");
        }
        Long newId = (person.getId() == null) ? generateNewId() : person.getId();
        storage.put(newId, person);
    }

    public Optional<Person> find(Long id) {
        return Optional.ofNullable(storage.get(id));
    }

    public void delete(Long id) {
        if (!storage.containsKey(id)) {
            throw new IllegalArgumentException("Osoba o id " + id + " nie istnieje.");
        }
        storage.remove(id);
    }

    private Long generateNewId() {
        return storage.keySet().stream().mapToLong(Long::longValue).max().orElse(0L) + 1L;
    }
}
