class Game {
    let fruitsEasy = ["jabłko", "śliwka", "gruszka"]
    let fruitsMedium = ["shake bananowy", "dobre mango", "zdrowa pomarańcza"]
    let fruitsHard = ["wielki rozkrojony ananas", "bardzo smaczna truskawka", "duży zielony arbuz"]
    
    let citiesEasy = ["Szczecin", "Gdynia", "Bydgoszcz"]
    let citiesMedium = ["Trójmiasto", "Gdańsk", "Kraków"]
    let citiesHard = ["Starogard Gdański", "Krępa Kaszubska", "Białka Tatrzańska"]
    
    let animalsEasy = ["kot", "pies", "tygrys"]
    let animalsMedium = ["tłusty hipopotam", "pracowita pszczoła", "młoda żyrafa"]
    let animalsHard = ["groźne małe lwiątko", "wielki silny orangutan", "nosorożec bez rogu"]
    
    var player_tries: Int
    var chosen_word: String
    var guessed: [Character]

    init() {
        self.player_tries = 5
        self.chosen_word = ""
        self.guessed = []
    }
    
    func drawBoard() {
        print(guessed.map { String($0) }.joined(separator: " "))
    }
    
    func gameLoop() {
        while player_tries > 0 {
            drawBoard()
            print("You have \(player_tries) tries left.")
            print("Guess a letter: ", terminator: "")
            if let guess = readLine(), let letter = guess.first {
                checkGuess(letter)
            }
            if !guessed.contains("_") {
                print("Congratulations! You've guessed the word: \(chosen_word)")
                break
            }
        }
        if player_tries == 0 {
            print("Game over! The word was: \(chosen_word)")
        }
    }
    
    func initWord(_ difficulty: Int, _ category: Int) {
        switch category {
        case 1: 
            switch difficulty {
            case 1:
                chosen_word = fruitsEasy.randomElement() ?? ""
            case 2:
                chosen_word = fruitsMedium.randomElement() ?? ""
            case 3:
                chosen_word = fruitsHard.randomElement() ?? ""
            default:
                chosen_word = ""
            }
        case 2:
            switch difficulty {
            case 1:
                chosen_word = citiesEasy.randomElement() ?? ""
            case 2:
                chosen_word = citiesMedium.randomElement() ?? ""
            case 3:
                chosen_word = citiesHard.randomElement() ?? ""
            default:
                chosen_word = ""
            }
        case 3: 
            switch difficulty {
            case 1:
                chosen_word = animalsEasy.randomElement() ?? ""
            case 2:
                chosen_word = animalsMedium.randomElement() ?? ""
            case 3:
                chosen_word = animalsHard.randomElement() ?? ""
            default:
                chosen_word = ""
            }
        default:
            chosen_word = ""
        }

        guessed = chosen_word.map { $0 == " " ? " " : "_" }
    }
    
    func checkGuess(_ letter: Character) {
        var correctGuess = false
        for (index, char) in chosen_word.enumerated() {
            guard char != " " else { continue }
            if char.lowercased() == letter.lowercased(),
               guessed[index] == "_" {
                guessed[index] = char
                correctGuess = true
            }
        }
        
        if !correctGuess {
            player_tries -= 1
            print("Wrong guess! Try again.")
        }
    }
    
    func startGame() {
        print("Hello, welcome in GuessTheWord!")
        
        print("Select category: ")
        print("(1) fruits")
        print("(2) cities")
        print("(3) animals")
        
        var category = 0
        
        if let key = readLine(), let categoryChoice = Int(key) {
            switch categoryChoice {
            case 1:
                print("Fruits selected!")
                category = 1
            case 2:
                print("Cities selected!")
                category = 2
            case 3:
                print("Animals selected!")
                category = 3
            default:
                print("Wrong key! Please select a valid category.")
                startGame()
                return
            }
        } else {
            print("Invalid input! Please enter a number.")
            startGame()
            return
        }
        
        print("Select difficulty: ")
        print("(1) easy")
        print("(2) medium")
        print("(3) hard")
        
        if let key = readLine(), let difficultyChoice = Int(key) {
            switch difficultyChoice {
            case 1:
                print("Easy mode selected!")
                initWord(1, category)
                gameLoop()
            case 2:
                print("Medium mode selected!")
                initWord(2, category)
                gameLoop()
            case 3:
                print("Hard mode selected!")
                initWord(3, category)
                gameLoop()
            default:
                print("Wrong key! Please select a valid difficulty.")
                startGame()
            }
        } else {
            print("Invalid input! Please enter a number.")
            startGame()
        }
    }
}

let game = Game()
game.startGame()
