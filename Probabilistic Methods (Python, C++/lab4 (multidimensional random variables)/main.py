import random

# Funkcja generująca wartość zmiennej losowej X zgodnie z określonym rozkładem prawdopodobieństwa
def generate_x():
    # Generuje liczbę losową z przedziału [0, 1)
    p = random.random()
    
    # Określa wartość X na podstawie przedziałów prawdopodobieństwa
    if p < 0.5:    # P(X=1) = 0.5
        return 1
    if p < 0.7:    # P(X=2) = 0.2 (0.7 - 0.5)
        return 2
    if p < 0.9:    # P(X=3) = 0.2 (0.9 - 0.7)
        return 3
    return 4          # P(X=4) = 0.1 (1.0 - 0.9)

# Funkcja generująca wartość zmiennej losowej Y, która zależy od wartości X
def generate_y(x):
    # Generuje liczbę losową z przedziału [0, 1)
    p = random.random()
    
    # Określa wartość Y na podstawie wartości X i odpowiednich rozkładów warunkowych
    if x == 1:
        if p < 0.2:    # P(Y=1 | X=1) = 0.2
            return 1
        return 4          # P(Y=4 | X=1) = 0.8
    if x == 2:
        return 1          # P(Y=1 | X=2) = 1.0
    if x == 3:
        if p < 0.5:    # P(Y=2 | X=3) = 0.5
            return 2
        return 4          # P(Y=4 | X=3) = 0.5
    if x == 4:
        return 3          # P(Y=3 | X=4) = 1.0

# Funkcja tworząca losowy wektor (X, Y)
def create_random_vector():
    # Generuje wartość X
    x = generate_x()
    # Generuje wartość Y na podstawie wygenerowanego X
    y = generate_y(x)
    return x, y

# Inicjalizacja tabeli częstości występowania par (X, Y)
# Tabela ma wymiary 5x5 (indeksy od 0 do 4), ale używamy tylko indeksów 1-4
results = [[0 for _ in range(5)] for _ in range(5)]

# Generowanie 100 000 próbek i zliczanie wystąpień każdej pary (X, Y)
for _ in range(100_000):
    x, y = create_random_vector()
    results[x][y] += 1

# Wyświetlanie wyników w formie tabeli
print("X/Y", end="\t")       # Nagłówek tabeli
for i in range(1, 5):
    print(i, end="\t")       # Wyświetla numery kolumn (wartości Y)
print()

for i in range(1, 5):
    print(i, end="\t")       # Wyświetla numery wierszy (wartości X)
    for j in range(1, 5):
        print(results[i][j], end="\t")  # Wyświetla częstości dla par (X, Y)
    print()
    

"""
def generate_x():
    p = random.random()
    
    if p < 0.5:
        return 1
    if p < 0.7: 
        return 2
    if p < 0.9:
        return 3
    return 4     
    
def generate_y(x):
    p = random.random()
    
    if x == 1:
        if p < 0.2:    # P(Y=1 | X=1) = 0.2
            return 1
        return 4          # P(Y=4 | X=1) = 0.8
    if x == 2:
        return 1          # P(Y=1 | X=2) = 1.0
    if x == 3:
        if p < 0.5:    # P(Y=2 | X=3) = 0.5
            return 2
        return 4          # P(Y=4 | X=3) = 0.5
    if x == 4:
        return 3          # P(Y=3 | X=4) = 1.0

def create_random_vector():
    x = generate_x()
    y = generate_y(x)
    return x, y

results = [[0 for _ in range(5)] for _ in range(5)]

for _ in range(100_000):
    x, y = create_random_vector()
    results[x][y] += 1

print("X/Y", end="\t")
for i in range(1, 5):
    print(i, end="\t")
print()

for i in range(1, 5):
    print(i, end="\t")
    for j in range(1, 5):
        print(results[i][j], end="\t")
    print()
"""