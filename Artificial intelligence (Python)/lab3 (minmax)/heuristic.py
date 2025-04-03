def heuristic(my_token, connect4):
    total = 0
    points = 0

    for four in connect4.iter_fours():
        total += 1
        own = four.count(my_token)
        enemy = 4 - own - four.count('_')

        if enemy == 0:
            points += own * own
        else:
            points -= enemy * enemy
        # points += own - enemy

    return points / (total * 16)

