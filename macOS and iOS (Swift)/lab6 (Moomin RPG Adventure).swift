struct MoominCharacter {
    var name: String
    var health: Int
    var friendship: Int
    var level: Int
    
    mutating func levelUp() {
        level += 1
        health += 5
        friendship += 2
        print("\(name) leveled up to level \(level)! Health: \(health), Friendship: \(friendship)")
    }
    
    var isHealthy: Bool {
        health > 0
    }
}

struct Creature {
    var name: String
    var mood: Int
    var patience: Int
    
    static func randomEncounter() -> Creature {
        let names = ["The Groke", "Hattifattener", "Stinky"]
        let name = names.randomElement()!
        let mood = Int.random(in: 1...3)
        let patience = Int.random(in: 5...10)
        return Creature(name: name, mood: mood, patience: patience)
    }
    
    var isCalm: Bool {
        patience <= 0
    }
}

var journal: [String] = []

func handleEncounter(moomin: inout MoominCharacter, creature: inout Creature) -> Bool {
    journal.append("Encountered \(creature.name) (Mood: \(creature.mood), Patience: \(creature.patience))")
    
    while true {
        print("\n---")
        print("\(creature.name) | mood: \(creature.mood)]")
        print("Moomin | Health: \(moomin.health) | Friendship: \(moomin.friendship)")
        print("Choose an action:")
        print("1. Talk to \(creature.name)")
        print("2. Run away")
        guard let choice = readLine() else { continue }
        
        switch choice {
        case "1":
            let prevPatience = creature.patience
            creature.patience -= moomin.friendship
            journal.append("Used Talk. Patience reduced from \(prevPatience) to \(creature.patience).")
            print("\nYou try to charm \(creature.name)...")
            if creature.isCalm {
                print("\(creature.name) calms down and smiles!")
                moomin.levelUp()
                journal.append("Calmed \(creature.name). Leveled up to \(moomin.level).")
                return true
            } 
            else {
                let damage = creature.mood * 3
                moomin.health -= damage
                print("\(creature.name) is still moody! It deals \(damage) damage.")
                journal.append("Took \(damage) damage. Health: \(moomin.health)")
                if !moomin.isHealthy {
                    journal.append("Defeated by \(creature.name).")
                    return false
                }
            }
            
        case "2":
            if Bool.random() {
                print("\nYou successfully run away from \(creature.name)!")
                journal.append("Ran away successfully.")
                return true
            } 
            else {
                let damage = creature.mood * 2
                moomin.health -= damage
                print("\nYou tried to run but failed! \(creature.name) spooks you for \(damage) damage.")
                journal.append("Failed to run. Took \(damage) damage. Health: \(moomin.health)")
                if !moomin.isHealthy {
                    journal.append("Defeated while fleeing.")
                    return false
                }
            }
            
        default:
            print("\nInvalid choice. Please enter 1 or 2.")
        }
    }
}

print("Welcome to Moominvalley!")
var moomin = MoominCharacter(name: "Dyzio", health: 10, friendship: 4, level: 1)
journal.append("Game started. Playing as \(moomin.name).")

gameLoop: while moomin.isHealthy {
    var creature = Creature.randomEncounter()
    print("\nA mysterious creature approaches...")
    let survived = handleEncounter(moomin: &moomin, creature: &creature)
    if !survived {
        break gameLoop
    }
}

print("\n--- Game Over ---")
print("\(moomin.name)'s Journey:")
journal.forEach { print("- \($0)") }