import math

def permutations(elements, N):
    if N == 0:
        return [[]]
    elements = elements[:N]
    generated = []
    for i in range(N):
        rest = elements[:i] + elements[i+1:]
        for p in permutations(rest, len(rest)):
            generated.append([elements[i]] + p)
    return generated

def combinations(elements, N, K):
    if K == 0:
        return [[]]
    if N < K or N == 0:
        return []
    elements = elements[:N]
    generated = []
    for i in range(N):
        rest = elements[i+1:]
        for c in combinations(rest, len(rest), K-1):
            generated.append([elements[i]] + c)
    return generated

def multisets(elements, N, K):
    if K == 0 or N == 0:
        return [[]]
    elements = elements[:N]
    generated = []
    for i in range(N):
        rest = elements[i:]
        for m in multisets(rest, len(rest), K-1):
            generated.append([elements[i]] + m)
    return generated

def radians(deg):
    return deg * math.pi / 180

def haversine(latitude1, longitude1, latitude2, longitude2):
    phi1, phi2 = radians(latitude1), radians(latitude2)
    diff_phi = radians(latitude2 - latitude1)
    diff_lambda = radians(longitude2 - longitude1)
    alfa = (math.sin(diff_phi/2))**2 + math.cos(phi1) * math.cos(phi2) * (math.sin(diff_lambda/2))**2
    return 2 * 6371 * math.asin(math.sqrt(alfa))

def shortest_route(cities, N):
    cities = cities[:N]
    best_route, min_distance = None, float('inf')
    for p in permutations(cities, N):
        distance = 0
        for i in range(len(p) - 1):
            distance += haversine(p[i]['latitude'], p[i]['longitude'], p[i+1]['latitude'], p[i+1]['longitude'])
        distance += haversine(p[-1]['latitude'], p[-1]['longitude'], p[0]['latitude'], p[0]['longitude'])
        if distance < min_distance:
            min_distance = distance
            best_route = p
    return best_route, min_distance

def closest_population_comb(cities, N):
    cities = cities[:N]
    total_population = sum(city['population'] for city in cities)
    target = total_population / 2
    best_c, best_diff = None, float('inf')
    for r in range(1, len(cities) + 1):
        for c in combinations(cities, N, r):
            c_population = sum(city['population'] for city in c)
            diff = abs(c_population - target)
            if diff < best_diff:
                best_diff, best_c = diff, c
    return best_c