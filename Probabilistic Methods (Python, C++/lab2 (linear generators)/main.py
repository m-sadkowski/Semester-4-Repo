def generator_liniowy(a, c, M, Xn, n):
    wygenerowane = []
    for _ in range(n):
        Xn1 = (a * Xn + c) % M
        Xn = Xn1
        wygenerowane.append(Xn1)
    return wygenerowane

def zlicz_generowane(liczby, M):
    kubelki = [0] * 10
    for liczba in liczby:
        indeks_kubelka = int(liczba * 10 / M)
        kubelki[indeks_kubelka] += 1
    print(kubelki)

def generator_przesuwny(p, q, n):
    start = [1, 1, 0, 1, 0, 0, 1]
    for i in range(31 - 7):
        start.append(0)
    wygenerowane = []
    for _ in range(n):
        start.pop()
        start.insert(0, (start[p-1] + start[q-1]) % 2)
        wygenerowana_liczba = 0
        for i in range(31):
            potega = 2**i
            wygenerowana_liczba += start[i] * potega
        wygenerowane.append(wygenerowana_liczba)
    return wygenerowane

Xo = 15
a = 69069
c = 1
n = 100000
M = 2**31
wygenerowane1 = generator_liniowy(a, c, M, Xo, n)
zlicz_generowane(wygenerowane1, M)

p = 7
q = 3
wygenerowane2 = generator_przesuwny(p, q, n)
zlicz_generowane(wygenerowane2, M)

