package org.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class AppTest {
    @Test
    void contextLoads() {
        assertTrue(true);
    }

    @Test
    void sampleRepositoryTest() {
        Repository repository = new Repository();
        Person person = new Person("Jan", "Kowalski", 30);
        repository.save(person);
        assertNotNull(repository.find(person.getId()).orElse(null));
    }
}