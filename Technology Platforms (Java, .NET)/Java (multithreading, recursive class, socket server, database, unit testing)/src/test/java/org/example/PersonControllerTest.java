package org.example;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import java.util.Optional;
import java.lang.reflect.Field;
import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PersonControllerTest {

    @Mock
    private Repository repository;

    @InjectMocks
    private PersonController personController;

    private PersonDTO validPersonDTO;
    private Person existingPerson;

    @BeforeEach
    void setUp() throws NoSuchFieldException, IllegalAccessException {
        validPersonDTO = new PersonDTO();
        validPersonDTO.setImie("Jan");
        validPersonDTO.setNazwisko("Kowalski");
        validPersonDTO.setWiek(30);

        existingPerson = new Person("Jan", "Kowalski", 30);

        Field idField = Person.class.getDeclaredField("id");
        idField.setAccessible(true);
        idField.set(existingPerson, 1L);
    }

    @Test
    void savePerson_ValidData_ReturnsDone() {
        doNothing().when(repository).save(any(Person.class));

        String result = personController.savePerson(validPersonDTO);

        assertThat(result).isEqualTo("done");
        verify(repository).save(any(Person.class));
    }

    @Test
    void savePerson_DuplicateId_ReturnsBadRequest() {
        validPersonDTO.setId(1L);
        doThrow(IllegalArgumentException.class).when(repository).save(any(Person.class));

        String result = personController.savePerson(validPersonDTO);

        assertThat(result).isEqualTo("bad request");
    }

    @Test
    void getPerson_ValidExistingId_ReturnsPersonDTOString() {
        when(repository.find(1L)).thenReturn(Optional.of(existingPerson));

        String result = personController.getPerson("1");

        assertThat(result).contains("id=1", "imie='Jan'", "nazwisko='Kowalski'");
    }

    @Test
    void getPerson_NonExistingId_ReturnsNotFound() {
        when(repository.find(2L)).thenReturn(Optional.empty());

        String result = personController.getPerson("2");

        assertThat(result).isEqualTo("not found");
    }

    @Test
    void getPerson_InvalidId_ReturnsBadRequest() {
        String result = personController.getPerson("abc");

        assertThat(result).isEqualTo("bad request");
    }

    @Test
    void deletePerson_ExistingId_ReturnsDone() {
        doNothing().when(repository).delete(1L);

        String result = personController.deletePerson("1");

        assertThat(result).isEqualTo("done");
        verify(repository).delete(1L);
    }

    @Test
    void deletePerson_NonExistingId_ReturnsNotFound() {
        doThrow(IllegalArgumentException.class).when(repository).delete(2L);

        String result = personController.deletePerson("2");

        assertThat(result).isEqualTo("not found");
    }

    @Test
    void deletePerson_InvalidId_ReturnsBadRequest() {
        String result = personController.deletePerson("xyz");

        assertThat(result).isEqualTo("bad request");
    }

    @Test
    void getPersonEntity_ValidExistingId_ReturnsPerson() {
        when(repository.find(1L)).thenReturn(Optional.of(existingPerson));

        Object result = personController.getPersonEntity("1");

        assertThat(result).isEqualTo(existingPerson);
    }

    @Test
    void getPersonEntity_InvalidId_ReturnsBadRequest() {
        Object result = personController.getPersonEntity("invalid");
        
        assertThat(result).isEqualTo("bad request");
    }
}