/**
 * Laboratorium 6 - Interfejs gniazdek w systemie MS Windows
 * 
 * Implementacja serwera TCP, który:
 * - Inicjalizuje bibliotekę Winsock
 * - Tworzy gniazdo nasłuchujące na porcie 8888
 * - Akceptuje połączenia od klientów
 * - Odbiera wiadomości od klientów i odsyła je z powrotem (echo)
 * - Obsługuje wielu klientów jednocześnie
 */

#include <stdio.h>
#include <winsock2.h>
#include <ws2tcpip.h>

#pragma comment(lib, "ws2_32.lib")  // Linkowanie z biblioteką Winsock

#define DEFAULT_PORT "8888"
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
    hints.ai_flags = AI_PASSIVE;      // Dla serwera (bind)
    
    // Rozwiązanie adresu lokalnego i portu do użycia przez serwer
    result = getaddrinfo(NULL, DEFAULT_PORT, &hints, &addr);
    if (result != 0) {
        printf("getaddrinfo failed: %d\n", result);
        WSACleanup();
        return 1;
    }
    
    // Utworzenie gniazda nasłuchującego
    SOCKET listenSocket = socket(addr->ai_family, addr->ai_socktype, addr->ai_protocol);
    if (listenSocket == INVALID_SOCKET) {
        printf("Error creating socket: %d\n", WSAGetLastError());
        freeaddrinfo(addr);
        WSACleanup();
        return 1;
    }
    
    // Powiązanie gniazda z adresem IP i portem
    result = bind(listenSocket, addr->ai_addr, (int)addr->ai_addrlen);
    if (result == SOCKET_ERROR) {
        printf("Bind failed: %d\n", WSAGetLastError());
        closesocket(listenSocket);
        freeaddrinfo(addr);
        WSACleanup();
        return 1;
    }
    
    freeaddrinfo(addr);  // Struktura addrinfo nie jest już potrzebna
    
    // Rozpoczęcie nasłuchiwania
    if (listen(listenSocket, SOMAXCONN) == SOCKET_ERROR) {
        printf("Listen failed: %d\n", WSAGetLastError());
        closesocket(listenSocket);
        WSACleanup();
        return 1;
    }
    
    printf("Serwer uruchomiony. Nasluchiwanie na porcie %s...\n", DEFAULT_PORT);
    
    // Główna pętla serwera
    while (1) {
        // Akceptowanie połączenia
        SOCKET clientSocket = accept(listenSocket, NULL, NULL);
        if (clientSocket == INVALID_SOCKET) {
            printf("Accept failed: %d\n", WSAGetLastError());
            continue;
        }
        
        printf("Nowe polaczenie zaakceptowane\n");
        
        // Obsługa klienta
        char recvBuffer[BUFFER_SIZE];
        int bytesReceived;
        
        // Odbieranie danych od klienta
        do {
            ZeroMemory(recvBuffer, BUFFER_SIZE);
            bytesReceived = recv(clientSocket, recvBuffer, BUFFER_SIZE, 0);
            
            if (bytesReceived > 0) {
                printf("Odebrano: %s\n", recvBuffer);
                
                // Odesłanie danych z powrotem do klienta (echo)
                int bytesSent = send(clientSocket, recvBuffer, bytesReceived, 0);
                if (bytesSent == SOCKET_ERROR) {
                    printf("Blad podczas wysylania: %d\n", WSAGetLastError());
                    break;
                }
                
                printf("Odpowiedz wyslana\n");
            } else if (bytesReceived == 0) {
                printf("Klient zamknal polaczenie\n");
            } else {
                printf("Blad podczas odbierania: %d\n", WSAGetLastError());
            }
        } while (bytesReceived > 0);
        
        // Zamknięcie gniazda klienta
        closesocket(clientSocket);
    }
    
    // Sprzątanie
    closesocket(listenSocket);
    WSACleanup();
    
    return 0;
} 