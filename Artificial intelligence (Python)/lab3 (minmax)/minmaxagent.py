from connect4 import Connect4
import copy


class MinMaxAgent:
    def __init__(self, token: str, depth: int = 4):
        """
        Inicjalizacja agenta Min-Max.
        :param token: Symbol gracza (np. 'X' lub 'O').
        :param depth: Maksymalna głębokość przeszukiwania.
        """
        self.my_token = token
        self.depth = depth

    def decide(self, connect4: Connect4):
        """
        Decyduje o najlepszym ruchu dla obecnej pozycji.
        :param connect4: Obiekt gry Connect4.
        :return: Indeks kolumny dla najlepszego ruchu.
        """
        v = -float('inf')  # Najlepsza wartość (maksymalizowana).
        y = None  # Najlepszy ruch (kolumna).
        for n_column in connect4.possible_drops():
            # Symulacja wykonania ruchu w danej kolumnie.
            new_connect4 = copy.deepcopy(connect4)
            new_connect4.drop_token(n_column)

            # Wywołanie Min-Max na zaktualizowanej planszy.
            v_local = self.minimax(new_connect4, self.depth - 1, False)

            # Aktualizacja najlepszego ruchu, jeśli znaleziono lepszą wartość.
            if v_local > v:
                v = v_local
                y = n_column
        return y

    def minimax(self, connect4: Connect4, depth: int, maximizing: bool):
        """
        Algorytm Min-Max do oceny wartości pozycji.
        :param connect4: Obiekt gry Connect4.
        :param depth: Pozostała głębokość przeszukiwania.
        :param maximizing: Czy aktualny gracz maksymalizuje wynik?
        :return: Wartość pozycji.
        """
        # Sprawdzenie zakończenia gry.
        if connect4.game_over:
            if connect4.wins == self.my_token:
                return 1  # Wygrana agenta.
            elif connect4.wins is None:
                return 0  # Remis.
            else:
                return -1  # Przegrana agenta.

        # Sprawdzenie osiągnięcia maksymalnej głębokości.
        if depth == 0:
            return self.heuristic(connect4)

        if maximizing:
            v = -float('inf')  # Maksymalizujemy wartość.
            for n_column in connect4.possible_drops():
                new_connect4 = copy.deepcopy(connect4)
                new_connect4.drop_token(n_column)
                v = max(v, self.minimax(new_connect4, depth - 1, not maximizing))
            return v
        else:
            v = float('inf')  # Minimalizujemy wartość.
            for n_column in connect4.possible_drops():
                new_connect4 = copy.deepcopy(connect4)
                new_connect4.drop_token(n_column)
                v = min(v, self.minimax(new_connect4, depth - 1, not maximizing))
            return v

    def heuristic(self, connect4: Connect4):
        """
        Funkcja heurystyczna oceniająca stan gry.
        :param connect4: Obiekt gry Connect4.
        :return: Wartość heurystyczna pozycji.
        """
        total = 0  # Liczba rozważanych układów 4 pól.
        points = 0  # Całkowita liczba punktów za nasze układy.
        weights = [0, 10, 50, 100]  # Wagi dla 1, 2, 3 lub 4 pionków w układzie.

        for four in connect4.iter_fours():
            total += 1
            count_ours = four.count(self.my_token)  # Liczba naszych pionków.
            count_empty = four.count('_')  # Liczba pustych pól.
            count_theirs = 4 - count_ours - count_empty  # Liczba pionków przeciwnika.

            if count_theirs != 0:
                continue  # Układ z pionkami przeciwnika nie jest rozważany.

            points += weights[count_ours]  # Dodajemy wagę za nasze pionki.

        # Normalizacja wyniku do wartości między 0 a 1.
        return points / (total * weights[-1])
