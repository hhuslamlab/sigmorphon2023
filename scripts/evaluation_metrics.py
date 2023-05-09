"""
evaluation
"""
from sklearn.metrics import precision_recall_fscore_support
from sklearn.metrics import precision_score, recall_score, f1_score
import pandas as pd


if __name__ == "__main__":

    data = pd.read_csv("../data/modified_kr_vectors.csv").fillna(-1)

    truth_simplify_do = [int(item) for item in data["truth_simplify_delete_obstruent"].tolist()]

    pred_simplify_do = [int(item) for item in data["simplify_delete_obstruent"].tolist()]

    truth_delete_lateral = [int(item) for item in data["truth_simplify_delete_lateral"].tolist()]

    pred_delete_lateral = [int(item) for item in data["simplify_delete_lateral"].tolist()]

    truth_nasalize = [int(item) for item in data["truth_nasalize"].tolist()]

    pred_nasalize = [int(item) for item in data["nasalize"].tolist()]

    truth_lateralize = [int(item) for item in data["truth_lateralize"].tolist()]

    pred_lateralize = [int(item) for item in data["lateralize"].tolist()]

    truth_tensify = []
    for item in data["truth_tensify"].tolist():
        if item == "yes":
            truth_tensify.append(1)
        if item == "no":
            truth_tensify.append(0)

        if item != "yes" and item != "no":
            truth_tensify.append(item)

    truth_tensify = [int(item) for item in truth_tensify]

    pred_tensify = [int(item) for item in data["tensify"].tolist()]

    precision_simplify_do = round(precision_score(truth_simplify_do, pred_simplify_do, average="macro"), 2)

    recall_simplify_do = round(recall_score(truth_simplify_do, pred_simplify_do, average="macro"), 2)

    f1_score_simplify_do = round(f1_score(truth_simplify_do, pred_simplify_do, average="macro"), 2)

    precision_delete_lateral = round(precision_score(truth_delete_lateral, pred_delete_lateral, average="macro"), 2)

    recall_delete_lateral = round(recall_score(truth_delete_lateral, pred_delete_lateral, average="macro"), 2)

    f1_score_delete_lateral = round(f1_score(truth_delete_lateral, pred_delete_lateral, average="macro"), 2)

    precision_nasalize = round(precision_score(truth_delete_lateral, pred_delete_lateral, average="macro"), 2)

    recall_nasalize = round(recall_score(truth_delete_lateral, pred_delete_lateral, average="macro"), 2)

    f1_score_nasalize = round(f1_score(truth_delete_lateral, pred_delete_lateral, average="macro"), 2)

    precision_lateralize = round(precision_score(truth_lateralize, pred_lateralize, average="macro"), 2)

    recall_lateralize = round(recall_score(truth_lateralize, pred_lateralize, average="macro"), 2)

    f1_score_lateralize = round(f1_score(truth_lateralize, pred_lateralize, average="macro"), 2)

    precision_tensify = round(precision_score(truth_tensify, pred_tensify, average="macro"), 2)

    recall_tensify = round(recall_score(truth_tensify, pred_tensify, average="macro"), 2)

    f1_score_tensify = round(f1_score(truth_tensify, pred_tensify, average="macro"), 2)

    final_dict = {}
    final_dict["simplify_delete_obstruent"] = {"precision":
                                 precision_simplify_do, "recall": recall_simplify_do, "f1_score": f1_score_simplify_do}

    final_dict["delete_lateral"] = {"precision":
                                 precision_delete_lateral, "recall": recall_delete_lateral, "f1_score": f1_score_delete_lateral}
    final_dict["nasalize"] = {"precision":
                                 precision_nasalize, "recall": recall_nasalize, "f1_score": f1_score_nasalize}
    final_dict["lateralize"] = {"precision":
                                 precision_lateralize, "recall": recall_lateralize, "f1_score": f1_score_lateralize}

    final_dict["tensify"] = {"precision":
                             precision_tensify, "recall": recall_tensify, "f1_score": f1_score_tensify}

    pd.DataFrame.from_dict(final_dict, orient="index").to_csv("../data/nn_test_evaluation_metrics.csv")
