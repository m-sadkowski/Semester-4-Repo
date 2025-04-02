from heuristic import heuristic
import copy

class MinMaxAgent:
    def __init__(self, token, depth=4):
        self.my_token = token
        self.depth = depth

    def decide(self, connect4):
        v_best, y_best = -float('inf'), None

        for column in connect4.possible_drops():
            board_copy = copy.deepcopy(connect4)
            board_copy.drop_token(column)
            value = self.minimax(board_copy, self.depth - 1, False)
            if value > v_best:
                v_best, y_best = value, column

        return y_best

    def minimax(self, connect4, depth, is_maximizing):
        if connect4.game_over:
            if connect4.wins == self.my_token:
                return 1
            elif connect4.wins is None:
                return 0
            else:
                return -1

        if depth == 0:
            return heuristic(self.my_token, connect4)

        if is_maximizing:
            value = -float('inf')
            for column in connect4.possible_drops():
                board_copy = copy.deepcopy(connect4)
                board_copy.drop_token(column)
                value = max(value, self.minimax(board_copy, depth - 1, not is_maximizing))
            return value
        else:
            value = float('inf')
            for column in connect4.possible_drops():
                board_copy = copy.deepcopy(connect4)
                board_copy.drop_token(column)
                value = min(value, self.minimax(board_copy, depth - 1, not is_maximizing))
            return value