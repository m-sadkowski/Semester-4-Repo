import Foundation

struct Player {
    let id: Int
    let sign: String
}

class TicTacToe {
    private var board: [[Int]]
    private var currentPlayer: Player
    private let human: Player
    private let computer: Player
    private var difficultyLevel: DifficultyLevel = .medium
    
    enum DifficultyLevel {
        case easy
        case medium
        case hard
    }
    
    init() {
        board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
        human = Player(id: 1, sign: "X")
        computer = Player(id: 2, sign: "O")
        currentPlayer = human
    }
    
    func startGame() {
        while true {
            print("Witaj w grze Kółko i Krzyżyk!")
            print("Wybierz poziom trudności:")
            print("1 - Łatwy")
            print("2 - Średni")
            print("3 - Trudny")
            print("Twój wybór (1-3): ", terminator: "")
            
            if let input = readLine(), let level = Int(input) {
                switch level {
                case 1: difficultyLevel = .easy
                case 2: difficultyLevel = .medium
                case 3: difficultyLevel = .hard
                default: difficultyLevel = .medium
                }
            }
            
            gameLoop()
            
            print("Czy chcesz zagrać jeszcze raz? (t/n): ", terminator: "")
            if let answer = readLine()?.lowercased(), answer != "t" {
                print("Dziękujemy za grę!")
                break
            }
            
            resetGame()
        }
    }
    
    private func gameLoop() {
        while true {
            printBoard()
            
            if currentPlayer.id == human.id {
                humanMove()
            } else {
                switch difficultyLevel {
                case .easy: computerMoveEasy()
                case .medium: computerMoveMedium()
                case .hard: computerMoveHard()
                }
            }
            
            let gameStatus = checkEnd()
            if gameStatus != 0 {
                printBoard()
                if gameStatus == human.id {
                    print("Gratulacje! Wygrałeś!")
                } else if gameStatus == computer.id {
                    print("Niestety, komputer wygrał.")
                } else {
                    print("Remis!")
                }
                break
            }
            
            currentPlayer = (currentPlayer.id == human.id) ? computer : human
        }
    }
    
    private func resetGame() {
        board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
        currentPlayer = human
    }
    
    private func humanMove() {
        while true {
            print("Twój ruch (wiersz kolumna): ", terminator: "")
            if let input = readLine() {
                let coordinates = input.split(separator: " ").compactMap { Int($0) }
                
                if coordinates.count == 2 {
                    let row = coordinates[0]
                    let col = coordinates[1]
                    
                    if row >= 0 && row < 3 && col >= 0 && col < 3 {
                        if board[row][col] == 0 {
                            board[row][col] = human.id
                            return
                        } else {
                            print("To pole jest już zajęte. Wybierz inne.")
                        }
                    } else {
                        print("Nieprawidłowe współrzędne. Wprowadź liczby od 0 do 2.")
                    }
                } else {
                    print("Nieprawidłowy format. Wprowadź dwie liczby oddzielone spacją, np. '1 2'")
                }
            }
        }
    }
    
    private func computerMoveEasy() {
        print("Ruch komputera (łatwy)...")
        for i in 0..<3 {
            for j in 0..<3 {
                if board[i][j] == 0 {
                    board[i][j] = computer.id
                    return
                }
            }
        }
    }
    
    private func computerMoveMedium() {
        print("Ruch komputera (średni)...")
        for _ in 0..<10 {
            let row = Int.random(in: 0..<3)
            let col = Int.random(in: 0..<3)
            
            if board[row][col] == 0 {
                board[row][col] = computer.id
                return
            }
        }
        computerMoveEasy()
    }
    
    private func computerMoveHard() {
        print("Ruch komputera (trudny)...")
        if let winningMove = findWinningMove(for: computer.id) {
            board[winningMove.row][winningMove.col] = computer.id
            return
        }
        if let blockingMove = findWinningMove(for: human.id) {
            board[blockingMove.row][blockingMove.col] = computer.id
            return
        }
        computerMoveMedium()
    }
    
    private func findWinningMove(for playerId: Int) -> (row: Int, col: Int)? {
        for i in 0..<3 {
            if board[i].filter({ $0 == playerId }).count == 2 {
                for j in 0..<3 where board[i][j] == 0 {
                    return (i, j)
                }
            }
        }
        
        for j in 0..<3 {
            var count = 0
            var emptyCol = -1
            for i in 0..<3 {
                if board[i][j] == playerId {
                    count += 1
                } else if board[i][j] == 0 {
                    emptyCol = i
                }
            }
            if count == 2 && emptyCol != -1 {
                return (emptyCol, j)
            }
        }
        
        var count = 0
        var emptySpot: (Int, Int)? = nil
        for i in 0..<3 {
            if board[i][i] == playerId {
                count += 1
            } else if board[i][i] == 0 {
                emptySpot = (i, i)
            }
        }
        if count == 2, let spot = emptySpot {
            return spot
        }
        
        count = 0
        emptySpot = nil
        for i in 0..<3 {
            if board[i][2-i] == playerId {
                count += 1
            } else if board[i][2-i] == 0 {
                emptySpot = (i, 2-i)
            }
        }
        if count == 2, let spot = emptySpot {
            return spot
        }
        
        return nil
    }
    
    private func checkEnd() -> Int {
        for i in 0..<3 {
            if board[i][0] != 0 && board[i][0] == board[i][1] && board[i][1] == board[i][2] {
                return board[i][0]
            }
        }
        
        for j in 0..<3 {
            if board[0][j] != 0 && board[0][j] == board[1][j] && board[1][j] == board[2][j] {
                return board[0][j]
            }
        }
        
        if board[0][0] != 0 && board[0][0] == board[1][1] && board[1][1] == board[2][2] {
            return board[0][0]
        }
        
        if board[0][2] != 0 && board[0][2] == board[1][1] && board[1][1] == board[2][0] {
            return board[0][2]
        }
        
        var isDraw = true
        for i in 0..<3 {
            for j in 0..<3 {
                if board[i][j] == 0 {
                    isDraw = false
                    break
                }
            }
            if !isDraw {
                break
            }
        }
        
        return isDraw ? 3 : 0
    }
    
    private func printBoard() {
        print("\n  0 1 2")
        for i in 0..<3 {
            print("\(i)", terminator: " ")
            for j in 0..<3 {
                let cell = board[i][j]
                if cell == 0 {
                    print(".", terminator: " ")
                } else if cell == human.id {
                    print(human.sign, terminator: " ")
                } else {
                    print(computer.sign, terminator: " ")
                }
            }
            print()
        }
        print()
    }
}

let game = TicTacToe()
game.startGame()