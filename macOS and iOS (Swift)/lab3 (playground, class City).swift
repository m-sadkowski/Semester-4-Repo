// Data model
struct Location {
    var id: Int
    var type: String
    var name: String?
    var rating: Int
}

let orio = Location(id: 1, type: "Restaurant", name: "Orio Kebab", rating: 4)
let mim = Location(id: 2, type: "Restaurant", name: "MIM Kebab", rating: 5)
let drwal = Location(id: 3, type: "Restaurant", name: "Drwal Kebab", rating: 5)
let wół = Location(id: 4, type: "Restaurant", name: "Wół i spółka", rating: 5)
let teatrmuzyczny = Location(id: 5, type: "Theater", name: "Teatr muzyczny", rating: 5)
let pg = Location(id: 6, type: "University", name: "Politechnika Gdańska", rating: 5)
let ug = Location(id: 7, type: "University", name: "Uniwersytet Gdański", rating: 4)
let helios = Location(id: 8, type: "Cinema", name: "Helios", rating: 3)
let multikino = Location(id: 9, type: "Cinema", name: "Multikino", rating: 4)

class City {
    var id: Int
    var name: String?
    var description: String
    var latitude: Double
    var longitude: Double
    var keywords: [String]
    var locations: [Location]

    init(id: Int, name: String?, description: String, latitude: Double, longitude: Double, keywords: [String], locations: [Location]) {
        self.id = id
        self.name = name
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.keywords = keywords
        self.locations = locations
    }
}

let cities = [
    City(id: 1, name: "Gdańsk", description: "Największe miasto w północnej Polsce.", latitude: 54.21, longitude: 18.40, keywords: ["pomorskie", "trójmiasto", "pg"], locations: [helios, multikino, ug, pg, orio, mim, drwal]),
    City(id: 2, name: "Gdynia", description: "Uzyskała prawa miejskie w 1926 roku.", latitude: 54.31, longitude: 18.32, keywords: ["pomorskie", "trójmiasto", "ug"], locations: [multikino, teatrmuzyczny]),
    City(id: 3, name: "Sopot", description: "Najmniejsze miasto aglomeracji trójmiejskiej.", latitude: 54.26, longitude: 18.33, keywords: ["pomorskie", "trójmiasto", "molo"], locations: [helios]),
    City(id: 4, name: "Kraków", description: "Stolica Polski do 1795 roku.", latitude: 50.03, longitude: 19.56, keywords: ["małopolskie", "friz", "ekipa"], locations: [multikino, helios, drwal]),
    City(id: 5, name: "Warszawa", description: "Stolica Polski.", latitude: 52.13, longitude: 21.0, keywords: ["mazowieckie", "stolica", "syrenka"], locations: [multikino, helios]),
    City(id: 6, name: "Poznań", description: "Położone na Pojezierzu Wielkopolskim.", latitude: 52.24, longitude: 16.56, keywords: ["wielkopolskie", "lech"], locations: [teatrmuzyczny, helios]),
    City(id: 7, name: "Białystok", description: "Stolica województwa podlaskiego.", latitude: 53.08, longitude: 23.08, keywords: ["podlaskie", "granica"], locations: [multikino]),
    City(id: 8, name: "Katowice", description: "Jedenaste największe miasto w Polsce.", latitude: 50.15, longitude: 19.01, keywords: ["śląskie", "IEM", "spodek"], locations: [multikino]),
    City(id: 9, name: "Łódź", description: "Ośrodek akademicki, kulturalny i przemysłowy", latitude: 51.46, longitude: 19.27, keywords: ["łódzkie", "film"], locations: [orio, helios]),
    City(id: 10, name: "Wrocław", description: "Historyczna stolica Dolnego Śląska.", latitude: 51.06, longitude: 17.01, keywords: ["dolnośląskie", "pwr", "uwr"], locations: []),
    City(id: 11, name: "Szczecin", description: "Centrum aglomeracji szczecińskiej.", latitude: 53.26, longitude: 14.32, keywords: ["zachodniopomorskie", "niemcy", "pogoń"], locations: [helios]),
    City(id: 12, name: "Częstochowa", description: "W 2024 zamieszkiwane przez 204 730 osób.", latitude: 50.49, longitude: 19.08, keywords: ["śląskie", "Jasna Góra"], locations: [multikino]),
    City(id: 13, name: "Rzeszów", description: "Miasto w południowo-wschodniej Polsce.", latitude: 50.02, longitude: 22.0, keywords: ["podkarpackie", "lotnisko"], locations: []),
    City(id: 14, name: "Lublin", description: "Centralny ośrodek aglomeracji lubelskiej.", latitude: 51.15, longitude: 22.34, keywords: ["lubelskie", "bystrzyca", "via carpatia"], locations: [orio]),
    City(id: 15, name: "Bydgoszcz", description: "Miasto na prawach powiatu w północnej Polsce.", latitude: 53.07, longitude: 18.0, keywords: ["kujawskie", "kujawsko-pomorskie", "kujawy"], locations: [helios]),
    City(id: 16, name: "Olsztyn", description: "Główny ośrodek gospodarczy, edukacyjny i kulturowy.", latitude: 53.46, longitude: 20.28, keywords: ["warmińsko-mazurskie", "warmia", "mazury"], locations: [multikino, drwal]),
    City(id: 17, name: "Lębork", description: "Leży w pradolinie Redy-Łeby nad Łebą i Okalicą.", latitude: 54.32, longitude: 17.44, keywords: ["pomorskie", "czołg", "Łeba"], locations: [wół]),
    City(id: 18, name: "Kwidzyn", description: "Historycznie Prusy Górne.", latitude: 53.44, longitude: 18.55, keywords: ["Kwidzyń", "pomorskie", "Nogat"], locations: []),
    City(id: 19, name: "Opole", description: "Siedziba władz województwa opolskiego.", latitude: 50.39, longitude: 17.55, keywords: ["opolskie", "festiwal", "odra"], locations: []),
    City(id: 20, name: "Kielce", description: "Miasto położone w Górach Świętokrzyskich.", latitude: 50.52, longitude: 20.38, keywords: ["świętokrzyskie", "Sandomierz"], locations: [])
]

// Search
func searchCitiesByName(_ name: String) -> [City] {
    return cities.filter { $0.name == name }
}

func searchCitiesByKeyword(_ keyword: String) -> [City] {
    return cities.filter { $0.keywords.contains { $0 == keyword } }
}

let citiesByName = searchCitiesByName("Gdańsk")
print("Cities with name 'Gdańsk':")
for city in citiesByName {
    print(city.name ?? "")
}

let citiesByKeyword = searchCitiesByKeyword("trójmiasto")
print("\nCities with keyword 'trójmiasto':")
for city in citiesByKeyword {
    print(city.name ?? "")
}

// Distance
import Foundation

func calculateDistance(_ name1: String, _ name2: String) -> Double? {
    guard let city1 = cities.first(where: { $0.name == name1 }),
          let city2 = cities.first(where: { $0.name == name2 }) else {
        return nil
    }

    return sqrt(pow(city2.latitude - city1.latitude, 2) + pow(city2.longitude - city1.longitude, 2))
}

if let distance = calculateDistance("Gdańsk", "Kraków") {
    print("\nDistance between Gdańsk and Kraków: \(distance)")
}

func closestFurthest(_ funcLatitude: Double, _ funcLongitude: Double) {
    var closestCity: City?
    var farthestCity: City?
    var minDistance = 99999999999999999999.99999999
    var maxDistance = 0.0

    for city in cities {
        let distance = sqrt(pow(city.latitude - funcLatitude, 2) + pow(city.longitude - funcLongitude, 2))
        if distance < minDistance {
            minDistance = distance
            closestCity = city
        }
        if distance > maxDistance {
            maxDistance = distance
            farthestCity = city
        }
    }

    if let closest = closestCity {
        print("\nClosest city: \(closest.name ?? "Unknown") (Distance: \(minDistance))")
    }
    if let farthest = farthestCity {
        print("Farthest city: \(farthest.name ?? "Unknown") (Distance: \(maxDistance))")
    } 
}

closestFurthest(52.01, 21.05)

func farthestCities() {
    var farthestCity1: City?
    var farthestCity2: City?
    var maxDistance = 0.0

    for i in 0..<cities.count {
        for j in i+1..<cities.count {
            let city1 = cities[i]
            let city2 = cities[j]

            let distance = sqrt(pow(city2.latitude - city1.latitude, 2) + pow(city2.longitude - city1.longitude, 2))

            if distance > maxDistance {
                maxDistance = distance
                farthestCity1 = city1
                farthestCity2 = city2
            }
        }
    }

    if let city1 = farthestCity1, let city2 = farthestCity2 {
        print("\nThe two farthest cities are:")
        print("\(city1.name ?? "Unknown") (Lat: \(city1.latitude), Lon: \(city1.longitude))")
        print("\(city2.name ?? "Unknown") (Lat: \(city2.latitude), Lon: \(city2.longitude))")
        print("Distance between them: \(maxDistance)")
    }
}

farthestCities()

// Extend data model

// Advance search
func citiesWithRestaurant(_ cities: [City]) {
    let filteredCities = cities.filter { city in city.locations.contains { $0.type == "Restaurant" && $0.rating == 5 }
    }
    print("\nCities with 5-star restaurants:")
    for city in filteredCities {
        if let name = city.name {
            print("- \(name)")
        }
    }
}

func sortedByRate(for cities: City) -> [Location] {
    return cities.locations.sorted { $0.rating > $1.rating }
}

func citiesWithFiveStar(_ cities: [City]) {
    for city in cities {
        let fiveStar = city.locations.filter { $0.rating == 5 }
        if let cityName = city.name {
            print("\n\(cityName) has \(fiveStar.count) locations with 5-star rating:")
        }
        for location in fiveStar {
            print("  - \(location.name ?? "Unknown location") (\(location.type))")
        }
    }
}

citiesWithRestaurant(cities)

let sortedLocations = sortedByRate(for: cities[0])
print("\nLocations in \(cities[0].name ?? "Unknown City") sorted by rating:")
for location in sortedLocations {
    print("- \(location.name ?? "Unknown location") (Rating: \(location.rating))")
}

citiesWithFiveStar(cities)






