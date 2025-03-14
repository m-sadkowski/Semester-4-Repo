from util import *
from data import *

cities = load_cities("France.txt")
N, M = 3, 2

i = 1
# 1) Dla podanej liczby N wypisać ponumerowane wszystkie porządki odwiedzin N miast 1,2,...,N
for p in permutations(cities, N):
    city_names = [city['name'] for city in p]
    print(i, city_names)
    i += 1
print("")

# Dla podanych liczb N i M wypisać ponumerowane wszystkie porządki odwiedzin M z N miast 1,2,...,N
# Dla podanych liczb N i K <= N wypisać ponumerowane wszystkie podzbiory K z N miast 1,2,...,N
i = 1
for c in combinations(cities, N, M):
    city_names = [city['name'] for city in c]
    print(i, city_names)
    i += 1
print("")

# Dla podanych liczb N i M wypisać ponumerowane wszystkie podzbiory, z możliwymi powtórzeniami, M z N miast 1,2,...,N
i = 1
for m in multisets(cities, N, M):
    city_names = [city['name'] for city in m]
    print(i, city_names)
    i += 1
print("")

# Korzystając z informacji o współrzędnych x i y miast, podać przebieg i długość najkrótszej trasy-cyklu odwiedzin miast.
route, distance = shortest_route(cities, N)
print("Najkrótsza trasa:", [city["name"] for city in route])
print("Długość trasy:", distance, "km")
print("")

# Korzystając z informacji o liczbie ludności miast, podać podzbiór, dla którego sumaryczna liczba mieszkańców jest najbliższa 50% liczby mieszkańców (bez powtórzeń) N miast.
best_comb = closest_population_comb(cities, N)
print("Najlepszy podzbiór:", [city["name"] for city in best_comb])
