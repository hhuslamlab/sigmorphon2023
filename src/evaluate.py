"""
Script to evaluate predictions.

Usage:
    evaluate --lang=<l> --prediction-filepath=<pp> --gold-filepath=<gp> --config=<c>

Options:
   --lang=<l>                       Provide language (eng, deu, ara)
   --prediction-filepath=<pp>       Provide path for predictions
   --gold-filepath=<gp>             Provide path for the gold outputs
   --config=<c>                     Provide configuration (eg: _100, _200)
"""
from docopt import docopt
import sys, os
import json

def read_predictions(fprediction):
    id2pred = {}
    with open(fprediction) as f:
        for line in f:
            if line[:2] == "H-":
                idx, score, pred = line.split("\t")
                idx = int(idx.split("-")[-1])
                pred = pred.strip().replace(" ", "").replace("<<unk>>", "?").replace("<unk>", "?").replace("_", " ")
                id2pred[idx] = pred
    return id2pred

def read_gold(fgold):
    idx = 0
    id2gold = {}
    with open(fgold) as f:
        for line in f:
            id2gold[idx] =line.strip().replace(' ','')
            idx += 1
    return id2gold


def eval_metrics(id2pred, id2gold):
    guess = 0
    correct = 0
    wrong_preds = []
    for idx, gold in id2gold.items():
        if gold == id2pred[idx]:
            correct += 1
        else:
            wrong_preds.append(str(idx) + ',' + id2pred[idx])
        guess += 1
    acc = round(100*correct/guess, 1)
    return acc, wrong_preds

if __name__ == "__main__":
    args = docopt(__doc__)

    lang = args["--lang"]
    fprediction = args["--prediction-filepath"]
    fgold = args["--gold-filepath"]
    config = args["--config"]
    id2pred = read_predictions(fprediction)

    with open('processed_predictions_orig/'+ lang + '_' + config + ".txt", 'w+') as f:
        for k, v in id2pred.items():
            f.write(str(k) + ',' + v + '\n')

    id2gold = read_gold(fgold)
    acc, wrong_preds = eval_metrics(id2pred, id2gold)

    if not os.path.exists("processed_predictions_orig"):
        os.makedirs("processed_predictions_orig")

    with open('processed_predictions_orig/wrong_preds_' + lang + '_' + config + '_' + halsize + ".txt", 'w+') as f:
        for i in wrong_preds:
            f.write(i + '\n')

    if not os.path.exists("accuracies_orig"):
        os.makedirs("accuracies_orig")

    with open("accuracies_orig/" + lang + '_' + config + '_' + halsize +  ".txt", "w+") as f:
        f.write("Accuracy for {} test set: {}%".format(lang, acc))
