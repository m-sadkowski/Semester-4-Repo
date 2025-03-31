from connect4 import Connect4
import copy

# Klasa reprezentująca agenta AlphaBeta
class AlphaBetaAgent:
    def __init__(self, token: str, depth: int = 5):
        self.my_token = token  # Symbol tokenu, którym gra agent (np. 'X' lub 'O')
        self.depth = depth  # Głębokość przeszukiwania drzewa gry (ilość poziomów)

    # Metoda decyzyjna agenta, zwraca najlepszą kolumnę, w którą agent powinien wrzucić token
    def decide(self, connect4: Connect4):
        alfa = -float('inf')  # Początkowa wartość alfa (najlepszy wynik gracza max)
        v = -float('inf')  # Najlepsza wartość (wyjściowo nieskończoność)
        y = None  # Najlepszy ruch (kolumna, którą agent wybierze)

        # Przechodzimy przez wszystkie możliwe kolumny, w które można wrzucić token
        for n_column in connect4.possible_drops():
            new_connect4 = copy.deepcopy(connect4)  # Tworzymy kopię obecnej planszy
            new_connect4.drop_token(n_column)  # Wrzucamy token w daną kolumnę
            v_local = self.alphabeta(new_connect4, self.depth - 1, False, alfa)  # Obliczamy wartość ruchu z użyciem Alpha-Beta
            if v_local > v:  # Jeśli uzyskana wartość jest lepsza niż dotychczasowa najlepsza
                v = v_local  # Aktualizujemy najlepszą wartość
                y = n_column  # Zapamiętujemy najlepszy ruch

        return y  # Zwracamy najlepszą kolumnę do zrobienia ruchu

    # Algorytm Alpha-Beta
    def alphabeta(self, connect4: Connect4, depth: int, maximizing: bool, alpha=-float('inf'), beta=float('inf')):
        # Sprawdzamy, czy gra się zakończyła (czy ktoś wygrał)
        if connect4.game_over:
            if connect4.wins == self.my_token:  # Jeśli agent wygrał
                return 1  # Wartość pozytywna dla gracza maksymalizującego
            elif connect4.wins is None:  # Jeżeli gra zakończyła się remisem
                return 0  # Wartość neutralna
            else:  # Jeśli wygrał przeciwnik
                return -1  # Wartość negatywna dla gracza maksymalizującego

        # Jeżeli osiągnięto limit głębokości przeszukiwania
        if depth == 0:
            return self.heuristic(connect4)  # Zwracamy wartość heurystyczną

        # Przeszukiwanie drzewa dla gracza maksymalizującego
        if maximizing:
            v = -float('inf')  # Początkowa wartość dla maksymalizującego
            for n_column in connect4.possible_drops():  # Przechodzimy przez wszystkie możliwe ruchy
                new_connect4 = copy.deepcopy(connect4)  # Tworzymy kopię planszy
                new_connect4.drop_token(n_column)  # Wrzucamy token
                v = max(v, self.alphabeta(new_connect4, depth - 1, not maximizing, alpha, beta))  # Rekurencyjnie wywołujemy Alpha-Beta
                alpha = max(alpha, v)  # Ustawiamy nową wartość alfa
                if v >= beta:  # Cięcie Beta
                    break  # Jeśli wartość v jest większa lub równa beta, nie sprawdzamy już kolejnych ruchów

            return v  # Zwracamy najlepszą wartość uzyskaną przez maksymalizującego

        # Przeszukiwanie drzewa dla gracza minimalizującego
        else:
            v = float('inf')  # Początkowa wartość dla minimalizującego
            for n_column in connect4.possible_drops():  # Przechodzimy przez wszystkie możliwe ruchy
                new_connect4 = copy.deepcopy(connect4)  # Tworzymy kopię planszy
                new_connect4.drop_token(n_column)  # Wrzucamy token
                v = min(v, self.alphabeta(new_connect4, depth - 1, not maximizing, alpha, beta))  # Rekurencyjnie wywołujemy Alpha-Beta
                beta = min(beta, v)  # Ustawiamy nową wartość beta
                if v <= alpha:  # Cięcie Alfa
                    break  # Jeśli wartość v jest mniejsza lub równa alfa, nie sprawdzamy już kolejnych ruchów

            return v  # Zwracamy najlepszą wartość uzyskaną przez minimalizującego

    # Funkcja heurystyczna oceniająca wartość planszy
    def heuristic(self, connect4: Connect4):
        total = 0  # Całkowita liczba "czwórek"
        points = 0  # Całkowita liczba punktów
        weights = [0, 10, 50, 100]  # Wagi dla różnych liczb własnych tokenów w czwórkach

        # Iterujemy przez wszystkie "czwórki" (cztery pola w jednej linii)
        for four in connect4.iter_fours():
            total += 1  # Liczymy łączną liczbę czwórek
            count_ours = four.count(self.my_token)  # Liczymy liczbę naszych tokenów w tej czwórce
            count_empty = four.count('_')  # Liczymy liczbę pustych miejsc w tej czwórce
            count_theirs = 4 - count_ours - count_empty  # Liczymy liczbę tokenów przeciwnika

            # Jeśli są jakiekolwiek tokeny przeciwnika w tej czwórce, nie dodajemy punktów
            if count_theirs != 0:
                continue

            # Dodajemy punkty w zależności od liczby naszych tokenów
            points += weights[count_ours]  # Punktacja zależna od liczby naszych tokenów w tej linii

        # Zwracamy ocenę heurystyczną (punkty podzielone przez maksymalną możliwą wartość)
        return points / (total * weights[-1])
