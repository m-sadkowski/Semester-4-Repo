package org.example;

public class PersonController {

    private final Repository repository;

    public PersonController(Repository repository) {
        this.repository = repository;
    }

    // zapisanie
    public String savePerson(PersonDTO personDTO) {
        Person person = new Person(personDTO.getImie(), personDTO.getNazwisko(), personDTO.getWiek());
        // id generowane przez repozytorium

        try {
            repository.save(person);
            return "done";
        } catch (IllegalArgumentException ex) {
            return "bad request";
        }
    }

    // szukanie i usuwanie po id

    // zwraca dto
    public String getPerson(String idStr) {
        try {
            Long id = Long.parseLong(idStr);
            return repository.find(id)
                    .map(p -> {
                        PersonDTO dto = new PersonDTO(p.getId(), p.getImie(), p.getNazwisko(), p.getWiek());
                        return dto.toString();
                    })
                    .orElse("not found");
        } catch (NumberFormatException e) {
            return "bad request";
        }
    }

    // zwraca Person
    public Object getPersonEntity(String idStr) {
        try {
            Long id = Long.parseLong(idStr);
            return repository.find(id)
                    .orElse(null);
        } catch (NumberFormatException e) {
            return "bad request";
        }
    }

    public String deletePerson(String idStr) {
        try {
            Long id = Long.parseLong(idStr);
            repository.delete(id);
            return "done";
        } catch (NumberFormatException e) {
            return "bad request";
        } catch (IllegalArgumentException e) {
            return "not found";
        }
    }

}
