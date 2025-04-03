import time
from exceptions import GameplayException
from connect4 import Connect4
from randomagent import RandomAgent
from minmaxagent import MinMaxAgent
from alphabetaagent import AlphaBetaAgent

connect4 = Connect4(width=7, height=6)
agent1 = MinMaxAgent('x', True, 4)
agent2 = AlphaBetaAgent('o', True, 4)
length1 = 0
length2 = 0
while not connect4.game_over:
    connect4.draw()
    try:
        if connect4.who_moves == agent1.my_token:
            startAgent1 = time.time()
            n_column = agent1.decide(connect4)
            length1 += time.time() - startAgent1
        else:
            startAgent2 = time.time()
            n_column = agent2.decide(connect4)
            length2 += time.time() - startAgent2
        connect4.drop_token(n_column)
    except (ValueError, GameplayException):
        print('invalid move')

connect4.draw()
print("Agent 1:", length1, " Agent 2: ", length2)
