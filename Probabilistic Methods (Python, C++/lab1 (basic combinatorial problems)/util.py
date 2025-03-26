import math

def factorial(n) -> int:
    result = 1
    for i in range(2, n + 1):
        result *= i
    return result

def newton(n, k) -> int:
    return factorial(n) / (factorial(k) * factorial(n-k))

def permutations_m_from_n(elements, N, M):
    if M == 0:
        return [[]]
    if N < M or N == 0:
        return []
    elements = elements[:N]
    generated = []
    for i in range(N):
        rest = elements[:i] + elements[i + 1:]
        for p in permutations_m_from_n(rest, len(rest), M - 1):
            generated.append([elements[i]] + p)
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
    routes = permutations_m_from_n(cities, N, M)
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

def population_probability(cities, N, M):
    subsets = multisets(cities, N, M)
    sum_all = sum(city['population'] for city in cities[:N])
    valid_subsets = 0
    for subset in subsets:
        unique_subset = list({city['id']: city for city in subset}.values())
        current_sum = sum(city['population'] for city in unique_subset)
        if 0.4 * sum_all <= current_sum <= 0.6 * sum_all:
            valid_subsets += 1
    return valid_subsets / sum(1 for _ in subsets)

