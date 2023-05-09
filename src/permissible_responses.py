import pandas as pd
import json

if __name__ == "__main__":
    with open("dev_obstruent.json") as f:
         dev_obstruent = json.load(f)

    with open("train_obstruent.json") as f:
         train_obstruent = json.load(f)


    obstruent = train_obstruent + dev_obstruent

    with open("dev_sonorant.json") as f:
         dev_sonorant = json.load(f)

    with open("train_sonorant.json") as f:
         train_sonorant = json.load(f)


    sonorant = train_sonorant + dev_sonorant

    set_obstruent = []
    for item in obstruent:
        set_obstruent.append([item["word"], item["generated_word"]])
    unique_obstruent = [list(x) for x in set(tuple(x) for x in set_obstruent)]

    set_sonorant = []
    for item in sonorant:
        set_sonorant.append([item["word"], item["generated_word"]])
    unique_sonorant = [list(x) for x in set(tuple(x) for x in set_sonorant)]

    all_data = unique_obstruent + unique_sonorant
    data = [list(x) for x in set(tuple(x) for x in all_data)]

    with open("../data/all.input", "w+") as f:
        for item in data:
            f.write(item[0].replace("", " ") + "\n")

    with open("../data/all.output", "w+") as f:
        for item in data:
            f.write(item[1].replace("", " ") + "\n")
