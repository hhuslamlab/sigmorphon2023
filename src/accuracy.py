import pandas as pd
import json

if __name__ == "__main__":
    data = pd.read_csv("../data/test_no_answers.csv")
    with open("../data/actual_test.kr.output") as f:
        truth = f.readlines()
        truth = [item.replace(' ', '').strip() for item in truth]
    with open("../data/modified_kr.txt") as f:
        pred = f.readlines()
        pred = [item.strip() for item in pred]

    data["output"] = truth
    data["pred"] = pred

    print(sum(1 for x,y in zip(pred,truth) if x == y) / float(len(truth)))


    low = data[data["Frequency"] == "low"]

    truth_low = low["output"].tolist()
    pred_low = low["pred"].tolist()

    print(sum(1 for x,y in zip(pred_low,truth_low) if x == y) / float(len(truth_low)))

    high = data[data["Frequency"] == "high"]

    truth_high = high["output"].tolist()
    pred_high = high["pred"].tolist()

    print(sum(1 for x,y in zip(pred_high,truth_high) if x == y) / float(len(truth_high)))

    nonce = data[data["Frequency"] == "nonce"]

    truth_nonce = nonce["output"].tolist()
    pred_nonce = nonce["pred"].tolist()

    print(sum(1 for x,y in zip(pred_nonce,truth_nonce) if x == y) / float(len(truth_nonce)))
