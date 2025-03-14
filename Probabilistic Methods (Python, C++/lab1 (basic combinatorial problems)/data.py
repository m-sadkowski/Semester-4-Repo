def load_cities(filename):
    cities = []
    with open(filename, "r", encoding="utf-8") as file:
        lines = file.readlines()[1:]
        for line in lines:
            parts = line.split()
            city = {
                "id": int(parts[0]),  #
                "name": parts[1],
                "population": int(parts[2]),
                "latitude": float(parts[3]),
                "longitude": float(parts[4])
            }
            cities.append(city)
    return cities