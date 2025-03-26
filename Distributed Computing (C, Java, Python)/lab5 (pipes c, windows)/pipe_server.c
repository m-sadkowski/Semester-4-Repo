/**
 * Laboratorium 5 - Komunikacja międzyprocesowa w systemie MS Windows
 * 
 * Przykład implementacji komunikacji międzyprocesowej przy użyciu nazwanych potoków (Named Pipes).
 * Ten plik zawiera kod serwera, który tworzy nazwany potok i odbiera dane od klienta.
 * 
 * Kompilacja: gcc pipe_server.c -o pipe_server.exe
 * Uruchomienie: pipe_server.exe
 */

#include <windows.h>
#include <stdio.h>
#include <stdbool.h>

#define PIPE_NAME "\\\\.\\pipe\\example_pipe"
#define BUFFER_SIZE 1024

int main() {
    HANDLE hPipe;
    char buffer[BUFFER_SIZE];
    DWORD bytesRead;
    bool connected = false;
    
    printf("Serwer: Tworzenie nazwanego potoku...\n");
    
    // Utworzenie nazwanego potoku
    hPipe = CreateNamedPipe(
        PIPE_NAME,                      // nazwa potoku
        PIPE_ACCESS_DUPLEX,             // dwukierunkowy dostęp
        PIPE_TYPE_MESSAGE |             // tryb komunikacji - wiadomości
        PIPE_READMODE_MESSAGE |         // tryb odczytu - wiadomości
        PIPE_WAIT,                      // blokujący tryb operacji
        PIPE_UNLIMITED_INSTANCES,       // maksymalna liczba instancji
        BUFFER_SIZE,                    // rozmiar bufora wyjściowego
        BUFFER_SIZE,                    // rozmiar bufora wejściowego
        0,                              // domyślny czas oczekiwania
        NULL                            // domyślne atrybuty bezpieczeństwa
    );
    
    if (hPipe == INVALID_HANDLE_VALUE) {
        printf("Serwer: Błąd podczas tworzenia potoku. Kod błędu: %d\n", GetLastError());
        return 1;
    }
    
    printf("Serwer: Potok utworzony. Oczekiwanie na połączenie klienta...\n");
    
    // Oczekiwanie na połączenie klienta
    connected = ConnectNamedPipe(hPipe, NULL) ? true : (GetLastError() == ERROR_PIPE_CONNECTED);
    
    if (connected) {
        printf("Serwer: Klient połączony. Oczekiwanie na dane...\n");
        
        // Odczyt danych z potoku
        while (ReadFile(hPipe, buffer, BUFFER_SIZE, &bytesRead, NULL) && bytesRead > 0) {
            buffer[bytesRead] = '\0'; // Dodanie znaku końca ciągu
            printf("Serwer: Otrzymano wiadomość: %s\n", buffer);
            
            // Odpowiedź do klienta
            char response[BUFFER_SIZE];
            sprintf(response, "Serwer potwierdza odbiór: %s", buffer);
            DWORD bytesWritten;
            WriteFile(hPipe, response, strlen(response) + 1, &bytesWritten, NULL);
            
            // Jeśli klient wysłał "exit", kończymy
            if (strcmp(buffer, "exit") == 0) {
                printf("Serwer: Otrzymano polecenie zakończenia.\n");
                break;
            }
        }
    } else {
        printf("Serwer: Błąd podczas oczekiwania na klienta. Kod błędu: %d\n", GetLastError());
    }
    
    // Zamknięcie potoku
    CloseHandle(hPipe);
    printf("Serwer: Potok zamknięty.\n");
    
    return 0;
} 