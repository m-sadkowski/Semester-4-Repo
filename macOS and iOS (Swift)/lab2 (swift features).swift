// Functions

func minValue(a: Int, b: Int) -> Int {
    if a > b {
        return b
    }
    return a
}
let minimum = minValue(a: 5, b: 10)
print(minimum)

func lastDigit(_ a: Int) -> Int {
    return a % 10
}
let last = lastDigit(897)
print(last)

func divides(_ a: Int, _ b: Int) -> Bool {
    if a % b == 0 {
        return true
    }
    return false
}
print(divides(7, 3))
print(divides(8, 4))

func countDivisors(_ a: Int) -> Int {
    var number = 0
    for i in 1...a {
        if(divides(a, i)) {
            number = number + 1
        }
    }
    return number
}
print(countDivisors(1))
print(countDivisors(10))
print(countDivisors(12))

func isPrime(_ a: Int) -> Bool {
    if(countDivisors(a) > 2) {
        return false
    }
    return true
}
print(isPrime(3))
print(isPrime(8))
print(isPrime(13))

// Closures

func smartBart(n: Int, closure: () -> Void) {
    for _ in 1...n {
        closure()
    }
}
smartBart(n: 5) {
    print(“I will pass this course with best mark, because Swift is great!”)
}

let numbers = [10, 16, 18, 30, 38, 40, 44, 50]
var filtered = numbers.filter{$0 % 4 == 0}
print(filtered)

let maxValue = numbers.reduce(-999999) { max($0, $1) }
print(maxValue)

var strings = ["Gdansk", "University", "of", "Technology"]
let combined = strings.reduce(""){$0 + " " + $1}
print(combined)

let numbers2 = [1, 2 ,3 ,4, 5, 6]
print(((numbers2.filter{$0 % 2 == 1}).map{$0 * $0}).reduce(0){$0 + $1})

// Tuples

func minmax(_ a: Int, _ b: Int) -> (Int, Int) {
    let min = (a > b) ? b : a
    let max = (a > b) ? a : b
    return (min, max)
}
let result = minmax(3, 6)
print("Min: \(result.0), Max: \(result.1)")

var stringsArray = ["gdansk", "university", "gdansk", "university", "university", "of", "technology", "technology", "gdansk", "gdansk"]
let countedStrings = stringsArray.reduce(into: [(String, Int)]()) { result, string in
    if let index = result.firstIndex(where: { $0.0 == string }) {
        result[index].1 += 1
    } else {
        result.append((string, 1))
    }
}
print(countedStrings)

// Enums

enum Day: String {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
    
    func dayNumber() -> Int {
        switch self {
        case .Monday:
            return 1
        case .Tuesday:
            return 2
        case .Wednesday:
            return 3
        case .Thursday:
            return 4
        case .Friday:
            return 5
        case .Saturday:
            return 6
        case .Sunday:
            return 7
        }
    }
    
    func emoji() -> String {
        switch self {
        case .Monday:
            return "😭"
        case .Tuesday:
            return "😴"
        case .Wednesday:
            return "👽"
        case .Thursday:
            return "🤠"
        case .Friday:
            return "😎"
        case .Saturday:
            return "🍾"
        case .Sunday:
            return "😶️"
        }
    }
}

let day = Day.Saturday
print(day.dayNumber())
print(day.emoji())


