package org.example;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;

class RepositoryTest {
    private Repository repository;
    private Person existingPerson;
    private final Long EXISTING_ID = 1L;
    private final Long NON_EXISTING_ID = 999L;

    @BeforeEach
    void setUp() {
        repository = new Repository();
        existingPerson = new Person("Jan", "Kowalski", 30);
        existingPerson.setId(EXISTING_ID);
        repository.save(existingPerson);
    }

    @Test
    void save_shouldStoreNewPerson() {
        Person newPerson = new Person("Anna", "Nowak", 25);
        newPerson.setId(2L);
        repository.save(newPerson);
        Optional<Person> found = repository.find(newPerson.getId());
        assertTrue(found.isPresent(), "Powinien istnieć zapisany obiekt");
        assertEquals(newPerson, found.get(), "Znaleziony obiekt powinien być równy zapisanemu");
    }

    @Test
    void delete_shouldRemovePerson() {
        repository.delete(EXISTING_ID);
        assertFalse(repository.find(EXISTING_ID).isPresent(), "Po usunięciu obiektu nie powinien być znajdowany");
    }

    // próba usunięcia nieistniejącego obiektu powoduje IllegalArgumentException,
    @Test
    void delete_shouldThrowWhenPersonNotFound() {
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> repository.delete(NON_EXISTING_ID), "Powinien zostać rzucony wyjątek dla nieistniejącego ID");
        assertEquals("Osoba o id " + NON_EXISTING_ID + " nie istnieje.", exception.getMessage());
    }

    // próba pobrania nieistniejącego obiektu zwraca pusty obiekt Optional
    @Test
    void find_shouldReturnEmptyOptionalForNonExistingId() {
        Optional<Person> result = repository.find(NON_EXISTING_ID);
        assertFalse(result.isPresent(), "Dla nieistniejącego ID powinien zwrócić pusty Optional");
    }

    // próba pobrania istniejącego obiektu zwraca obiekt Optional z zawartością
    @Test
    void find_shouldReturnPersonForExistingId() {
        Optional<Person> result = repository.find(EXISTING_ID);
        assertTrue(result.isPresent(), "Dla istniejącego ID powinien zwrócić wypełniony Optional");
        assertEquals(existingPerson, result.get(), "Znaleziony obiekt powinien być równy zapisanemu");
    }

    // próba zapisania obiektu, którego klucz główny już znajduje się w repozytorium powoduje IllegalArgumentException
    @Test
    void save_shouldThrowWhenDuplicateId() {
        Person duplicatePerson = new Person("Anna", "Nowak", 25);
        duplicatePerson.setId(EXISTING_ID);
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> repository.save(duplicatePerson), "Powinien zostać rzucony wyjątek dla duplikatu ID");
        assertEquals("Osoba o id " + EXISTING_ID + " już istnieje.", exception.getMessage());
    }
}