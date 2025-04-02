from connect4 import Connect4

def heuristic(my_token, connect4: Connect4):
    total = 0
    points = 0
    weights = [0, 10, 50, 100]

    for four in connect4.iter_fours():
        total += 1
        own = four.count(my_token)
        enemy = 4 - own - four.count('_')

        if enemy == 0:
            points += weights[own]

    return points / (total * weights[-1])