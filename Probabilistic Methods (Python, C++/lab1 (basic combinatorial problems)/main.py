from util import *
from data import *

cities = load_cities("France.txt")

N, M = 5, 3

print("\nOczekiwane: ", factorial(N) / factorial(N - M))
for i, v in enumerate(variations(cities, N, M), 1):
     print(i, [city["name"] for city in v])

print("\nOczekiwane: ", newton(M + N - 1, N - 1))
for i, m in enumerate(multisets(cities, N, M), 1):
     print(i, [city["name"] for city in m])

N, M = 7, 5

route, distance = shortest_route(cities, N, M)[0]
print("\nMiasta:", [city["name"] for city in route])
print("Długość trasy:", distance)

probability = population_probability(cities, N, M)
print("\nPrawdopodobieństwo:", probability)
