import Foundation

// Strings and Text

var a = 5
var b = 10
let equ = "\(a) + \(b) = \(a+b)"
print(equ)

let gdansk = "Gdansk University of Technology"
var gdansk2 = ""
for character in gdansk {
  if character == "n" {
    gdansk2 = gdansk2 + "⭐️"
  }
  else {
    gdansk2 = gdansk2 + String(character)
  }
}
print(gdansk2)


var imie = "Michał Sadkowski"
imie=String(imie.reversed())
print(imie)

// Control Flow

for _ in 0...11 {
  print("I will pass this course with best mark, because Swift is great!")
}

var N = 5
for i in 1...N {
  print("\(i * i)", terminator: " ")
}
print("")

for _ in 1...N {
  for _ in 1...N {
    print("@", terminator: "")
  }
  print("")
}

// Arrays

var numbers = [5, 10, 20, 15, 80, 13]
if let max = numbers.max() {
  print("max = \(max)")
}

for number in numbers.reversed() {
  print("\(number)", terminator: " ")
}
print("")

var allNumbers = [10, 20, 10, 11, 13, 20, 10, 30]
allNumbers.sort()
var uniqueNumbers = [Int]()
if let first = allNumbers.first {
    uniqueNumbers.append(first)
}
for i in 1..<allNumbers.count {
    if allNumbers[i] != allNumbers[i-1] {
        uniqueNumbers.append(allNumbers[i])
    }
}
print("unique = \(uniqueNumbers)")

// Sets

var divisors = Set<Int>()
var number = 10
for i in 1...number {
    if number % i == 0 {
        divisors.insert(i)
    }
}
print("divisors = \(divisors)")

// Dictionaries 

var flights: [[String: String]] = [
    [
        "flightNumber" : "AA8025",
        "destination" : "Copenhagen"
    ],
    [
        "flightNumber" : "BA1442",
        "destination" : "New York"
    ],
    [
        "flightNumber" : "BD6741",
        "destination" : "Barcelona"
    ]
]
var flightNumbers = [String]()
for flight in flights {
    if let flightNumber = flight["flightNumber"] {
        flightNumbers.append(flightNumber)
    }
}
print("flightNumbers = \(flightNumbers)")

let names = ["Hommer", "Lisa", "Bart"]
let lastName = "Simpson"
var fullName: [[String: String]] = []
for name in names {
    fullName.append(["firstName": name, "lastName": lastName])
}
print("fullName = \(fullName)")



