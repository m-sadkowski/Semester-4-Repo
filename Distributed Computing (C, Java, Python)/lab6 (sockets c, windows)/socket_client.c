/**
 * Laboratorium 6 - Interfejs gniazdek w systemie MS Windows
 * 
 * Implementacja klienta TCP, który:
 * - Inicjalizuje bibliotekę Winsock
 * - Łączy się z serwerem na localhost:8888
 * - Wysyła wiadomości do serwera
 * - Odbiera odpowiedzi od serwera
 * - Pozwala użytkownikowi na interaktywne wysyłanie wiadomości
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>
#include <ws2tcpip.h>

#pragma comment(lib, "ws2_32.lib")  // Linkowanie z biblioteką Winsock

#define DEFAULT_PORT "8888"
#define DEFAULT_SERVER "localhost"
#define BUFFER_SIZE 1024

int main() {
    // Inicjalizacja Winsock
    WSADATA wsaData;
    int result;
    
    result = WSAStartup(MAKEWORD(2, 2), &wsaData);
    if (result != 0) {
        printf("WSAStartup failed: %d\n", result);
        return 1;
    }
    
    // Konfiguracja adresu serwera
    struct addrinfo *addr = NULL, hints;
    ZeroMemory(&hints, sizeof(hints));
    hints.ai_family = AF_INET;        // IPv4
    hints.ai_socktype = SOCK_STREAM;  // TCP
    hints.ai_protocol = IPPROTO_TCP;
    
    // Rozwiązanie adresu serwera i portu
    result = getaddrinfo(DEFAULT_SERVER, DEFAULT_PORT, &hints, &addr);
    if (result != 0) {
        printf("getaddrinfo failed: %d\n", result);
        WSACleanup();
        return 1;
    }
    
    // Utworzenie gniazda
    SOCKET connectSocket = socket(addr->ai_family, addr->ai_socktype, addr->ai_protocol);
    if (connectSocket == INVALID_SOCKET) {
        printf("Error creating socket: %d\n", WSAGetLastError());
        freeaddrinfo(addr);
        WSACleanup();
        return 1;
    }
    
    // Połączenie z serwerem
    result = connect(connectSocket, addr->ai_addr, (int)addr->ai_addrlen);
    if (result == SOCKET_ERROR) {
        printf("Nie mozna polaczyc z serwerem: %d\n", WSAGetLastError());
        closesocket(connectSocket);
        freeaddrinfo(addr);
        WSACleanup();
        return 1;
    }
    
    freeaddrinfo(addr);  // Struktura addrinfo nie jest już potrzebna
    
    printf("Polaczono z serwerem %s:%s\n", DEFAULT_SERVER, DEFAULT_PORT);
    printf("Wpisz wiadomosc do wyslania (lub 'exit' aby zakonczyc):\n");
    
    char sendBuffer[BUFFER_SIZE];
    char recvBuffer[BUFFER_SIZE];
    int bytesReceived;
    
    // Główna pętla klienta
    while (1) {
        printf("> ");
        fgets(sendBuffer, BUFFER_SIZE, stdin);
        
        // Usunięcie znaku nowej linii
        sendBuffer[strcspn(sendBuffer, "\n")] = 0;
        
        // Sprawdzenie, czy użytkownik chce zakończyć
        if (strcmp(sendBuffer, "exit") == 0) {
            break;
        }
        
        // Wysłanie wiadomości do serwera
        int bytesSent = send(connectSocket, sendBuffer, (int)strlen(sendBuffer), 0);
        if (bytesSent == SOCKET_ERROR) {
            printf("Blad podczas wysylania: %d\n", WSAGetLastError());
            break;
        }
        
        // Odebranie odpowiedzi od serwera
        ZeroMemory(recvBuffer, BUFFER_SIZE);
        bytesReceived = recv(connectSocket, recvBuffer, BUFFER_SIZE, 0);
        
        if (bytesReceived > 0) {
            printf("Odpowiedz serwera: %s\n", recvBuffer);
        } else if (bytesReceived == 0) {
            printf("Serwer zamknal polaczenie\n");
            break;
        } else {
            printf("Blad podczas odbierania: %d\n", WSAGetLastError());
            break;
        }
    }
    
    // Zamknięcie gniazda i sprzątanie
    closesocket(connectSocket);
    WSACleanup();
    
    return 0;
} 