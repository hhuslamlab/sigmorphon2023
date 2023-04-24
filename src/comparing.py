import pandas as pd

if __name__ == "__main__":

    data = pd.read_csv("../data/test_with_right_answers_neural_all_participants.csv")

    neural_pred = data["neural_prediction"].tolist()

    ldl_pred = data["predicted"].tolist()

    truth = data["Production_R"].tolist()

    n_better = []
    l_better = []

    for n, l, t in zip(neural_pred, ldl_pred, truth):
        ## checking for cases where neural is better

        if n == t and l != t:
            n_better.append(n)

        if l == t and ldl_pred != t:
            n_better.append(n)
