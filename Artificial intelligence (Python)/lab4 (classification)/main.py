import numpy as np

from decision_tree import DecisionTree
from random_forest import RandomForest
from load_data import generate_data, load_titanic

def main():
    np.random.seed(123)

    train_data, test_data = load_titanic()

    dt = DecisionTree({"depth": 14})
    dt.train(*train_data)
    print("Train, decision tree: ")
    dt.evaluate(*train_data)
    print("Test, decision tree: ")
    dt.evaluate(*test_data)

    rf = RandomForest({"ntrees": 10, "feature_subset": 2, "depth": 16})
    rf.train(*train_data)
    print("Train, random forest: ")
    rf.evaluate(*train_data)
    print("Test, random forest: ")
    rf.evaluate(*test_data)

if __name__=="__main__":
    main()