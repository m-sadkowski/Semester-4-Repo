import math

def factorial(n) -> int:
    result = 1
    for i in range(2, n + 1):
        result *= i
    return result

def newton(n, k) -> int:
    return factorial(n) / (factorial(k) * factorial(n-k))

def variations(elements, N, M):
    if M == 0:
        return [[]]
    if N < M or N == 0:
        return []
    elements = elements[:N]
    generated = []
    for i in range(N):
        rest = elements[:i] + elements[i + 1:]
        for v in variations(rest, len(rest), M - 1):
            generated.append([elements[i]] + v)
    return generated

def multisets(elements, N, M):
    if M == 0 or N == 0:
        return [[]]
    elements = elements[:N]
    generated = []
    for i in range(N):
        rest = elements[i:]
        for m in multisets(rest, len(rest), M - 1):
            generated.append([elements[i]] + m)
    return generated

def distance(latitude1, latitude2, longitude1, longitude2):
    return math.sqrt((latitude2 - latitude1)**2 + (longitude2 - longitude1)**2)

def shortest_route(cities, N, M):
    routes = variations(cities, N, M)
    distances = []
    for route in routes:
        current_distance = 0
        for i in range(M - 1):
            current_distance += distance(route[i]['latitude'], route[i + 1]['latitude'], route[i]['longitude'], route[i + 1]['longitude'])
        current_distance += distance(route[M - 1]['latitude'], route[0]['latitude'], route[M - 1]['longitude'], route[0]['longitude'])
        route.append(route[0])
        distances.append((route, current_distance))
    distances.sort(key=lambda x: x[1])
    return distances

def combinations(elements, N, K):
    if K == 0:
        return [[]]
    if N < K or N == 0:
        return []
    elements = elements[:N]
    generated = []
    for i in range(N):
        rest = elements[i + 1:]
        for c in combinations(rest, len(rest), K - 1):
            generated.append([elements[i]] + c)
    return generated

def population_probability(cities, N, M):
    subsets = combinations(cities, N, M)
    sum_all = sum(city['population'] for city in cities[:N])
    valid_subsets = 0
    for subset in subsets:
        current_sum = sum(city['population'] for city in subset)
        if 0.4 * sum_all <= current_sum <= 0.6 * sum_all:
            valid_subsets += 1
    return valid_subsets / len(subsets)

