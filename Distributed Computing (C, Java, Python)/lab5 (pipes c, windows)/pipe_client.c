/**
 * Laboratorium 5 - Komunikacja międzyprocesowa w systemie MS Windows
 * 
 * Przykład implementacji komunikacji międzyprocesowej przy użyciu nazwanych potoków (Named Pipes).
 * Ten plik zawiera kod klienta, który łączy się z nazwanym potokiem i wysyła dane do serwera.
 * 
 * Kompilacja: gcc pipe_client.c -o pipe_client.exe
 * Uruchomienie: pipe_client.exe
 */

#include <windows.h>
#include <stdio.h>
#include <stdbool.h>

#define PIPE_NAME "\\\\.\\pipe\\example_pipe"
#define BUFFER_SIZE 1024

int main() {
    HANDLE hPipe;
    char buffer[BUFFER_SIZE];
    DWORD bytesWritten, bytesRead;
    
    printf("Klient: Łączenie z nazwanym potokiem...\n");
    
    // Próba połączenia z potokiem (z kilkoma powtórzeniami w przypadku niepowodzenia)
    int attempts = 0;
    while (attempts < 5) {
        hPipe = CreateFile(
            PIPE_NAME,                  // nazwa potoku
            GENERIC_READ | GENERIC_WRITE, // tryb dostępu
            0,                          // brak współdzielenia
            NULL,                       // domyślne atrybuty bezpieczeństwa
            OPEN_EXISTING,              // otwórz istniejący potok
            0,                          // domyślne atrybuty
            NULL                        // brak szablonu
        );
        
        if (hPipe != INVALID_HANDLE_VALUE) {
            break;
        }
        
        // Jeśli potok nie jest dostępny, czekaj i spróbuj ponownie
        if (GetLastError() != ERROR_PIPE_BUSY) {
            printf("Klient: Nie można połączyć się z potokiem. Kod błędu: %d\n", GetLastError());
            return 1;
        }
        
        printf("Klient: Potok zajęty, oczekiwanie...\n");
        if (!WaitNamedPipe(PIPE_NAME, 5000)) {
            printf("Klient: Przekroczono czas oczekiwania na potok.\n");
            return 1;
        }
        
        attempts++;
    }
    
    if (hPipe == INVALID_HANDLE_VALUE) {
        printf("Klient: Nie udało się połączyć z potokiem po %d próbach.\n", attempts);
        return 1;
    }
    
    printf("Klient: Połączono z potokiem.\n");
    
    // Zmiana trybu potoku na tryb wiadomości
    DWORD pipeMode = PIPE_READMODE_MESSAGE;
    if (!SetNamedPipeHandleState(hPipe, &pipeMode, NULL, NULL)) {
        printf("Klient: Nie można ustawić trybu potoku. Kod błędu: %d\n", GetLastError());
        CloseHandle(hPipe);
        return 1;
    }
    
    // Pętla komunikacji
    bool running = true;
    while (running) {
        printf("Klient: Wprowadź wiadomość (lub 'exit' aby zakończyć): ");
        fgets(buffer, BUFFER_SIZE, stdin);
        
        // Usunięcie znaku nowej linii
        size_t len = strlen(buffer);
        if (len > 0 && buffer[len - 1] == '\n') {
            buffer[len - 1] = '\0';
            len--;
        }
        
        // Wysłanie wiadomości do serwera
        if (!WriteFile(hPipe, buffer, len + 1, &bytesWritten, NULL)) {
            printf("Klient: Błąd podczas wysyłania wiadomości. Kod błędu: %d\n", GetLastError());
            break;
        }
        
        printf("Klient: Wysłano %d bajtów.\n", bytesWritten);
        
        // Odczyt odpowiedzi od serwera
        if (ReadFile(hPipe, buffer, BUFFER_SIZE, &bytesRead, NULL) && bytesRead > 0) {
            buffer[bytesRead] = '\0';
            printf("Klient: Otrzymano odpowiedź: %s\n", buffer);
        } else {
            printf("Klient: Błąd podczas odczytu odpowiedzi. Kod błędu: %d\n", GetLastError());
            break;
        }
        
        // Sprawdzenie, czy użytkownik chce zakończyć
        if (strcmp(buffer, "exit") == 0) {
            running = false;
        }
    }
    
    // Zamknięcie potoku
    CloseHandle(hPipe);
    printf("Klient: Połączenie zamknięte.\n");
    
    return 0;
} 