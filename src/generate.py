import pandas as pd
import json

def nikl_sonorant():

    with open("output_nikl_sonorant.json") as f:
        data = json.load(f)

    condition6 = {"pot": 0, "cs": 0, "l-deletion": 0, "c-deletion": 0, "tensification": 0, "nasalization": 0}
    condition7 = {"pot": 0, "cs": 1, "l-deletion": 1, "c-deletion": 0, "tensification": 0, "nasalization": 0}
    condition8 = {"pot": 0, "cs": 1, "l-deletion": 1, "c-deletion": 0, "tensification": 0, "nasalization": 1}
    condition9 = {"pot": 0, "cs": 1, "l-deletion": 0, "c-deletion": 1, "tensification": 0, "nasalization": 0}

    new_lst = []

    for item in data:
        for word, conditions in item.items():
            for condition in conditions:
                new_data = {}

                if condition == condition6:
                    new_word = word.replace("-", "")

                    new_data["word"] = word
                    new_data["pot"] = 0
                    new_data["cs"] = 0
                    new_data["l-deletion"] = 0
                    new_data["c-deletion"] = 0
                    new_data["tensification"] = 0
                    new_data["nasalization"] = 0
                    new_data["generated_word"] = new_word
                    new_lst.append(new_data)

                if condition == condition7:
                    stem = word.split("-")[0]
                    l_first_half_word = stem.replace(stem[-2], "")
                    l_deletion = l_first_half_word + word.split("-")[1]
                    new_data["word"] = word
                    new_data["pot"] = 0
                    new_data["cs"] = 1
                    new_data["l-deletion"] = 1
                    new_data["c-deletion"] = 0
                    new_data["tensification"] = 0
                    new_data["nasalization"] = 0
                    new_data["generated_word"] = l_deletion
                    new_lst.append(new_data)

                if condition == condition8:
                    stem = word.split("-")[0]
                    lc_first_half_word = stem.replace(stem[-2], "")[:-1]
                    assm = ""
                    if stem[-1] == "p":
                        assm = "m"

                    if stem[-1] == "t":
                        assm = "n"

                    if stem[-1] == "k":
                        assm = "N"
                    print(word)
                    new_word = lc_first_half_word + assm + word.split("-")[1]
                    new_data["word"] = word
                    new_data["pot"] = 0
                    new_data["cs"] = 1
                    new_data["l-deletion"] = 1
                    new_data["c-deletion"] = 0
                    new_data["tensification"] = 0
                    new_data["nasalization"] = 1
                    new_data["generated_word"] = new_word
                    new_lst.append(new_data)


                if condition == condition9:
                    stem = word.split("-")[0]
                    c_first_half_word = stem[:-1]
                    new_word = c_first_half_word + word.split("-")[1]
                    new_data["word"] = word
                    new_data["pot"] = 0
                    new_data["cs"] = 1
                    new_data["l-deletion"] = 0
                    new_data["c-deletion"] = 1
                    new_data["tensification"] = 0
                    new_data["nasalization"] = 0
                    new_data["generated_word"] = new_word
                    new_lst.append(new_data)

    return new_lst


def nikl_obstruent():

    with open("output_nikl_obstruent.json") as f:
        data = json.load(f)

    raw_data = pd.read_csv("../data/NIKL_lC+Obstruent.csv").fillna("")
    srs = raw_data["SR"]

    condition1 = {"pot": 1, "cs": 0, "l-deletion": 0, "c-deletion": 0, "tensification": 1}
    condition2 = {"pot": 0, "cs": 1, "l-deletion": 1, "c-deletion": 0, "tensification": 0}
    condition3 = {"pot": 0, "cs": 1, "l-deletion": 0, "c-deletion": 1, "tensification": 0}
    condition4 = {"pot": 1, "cs": 1, "l-deletion": 1, "c-deletion": 0, "tensification": 1}
    condition5 = {"pot": 1, "cs": 1, "l-deletion": 0, "c-deletion": 1, "tensification": 1}


    new_lst = []

    for item in data:
        for word, conditions in item.items():
            print(word)
            mapping = {"*p": "b", "*t": "d", "*k": "g", "S": "*s", "*c": "J"}
            for condition in conditions:
                new_data = {}
                if condition == condition1:
                    stem = word.split("-")[0]
                    pot = stem + "*" + word.split("-")[1]
                    for k, v in mapping.items():
                        if k in pot:
                            new_word = pot.replace(k,v)
                    new_data["word"] = word
                    new_data["pot"] = 1
                    new_data["cs"] = 0
                    new_data["l-deletion"] = 0
                    new_data["c-deletion"] = 0
                    new_data["tensification"] = 1
                    new_data["generated_word"] = new_word
                    new_lst.append(new_data)

                if condition == condition2:
                    stem = word.split("-")[0]
                    l_first_half_word = stem.replace(stem[-2], "")
                    l_deletion = l_first_half_word + word.split("-")[1]

                    new_data["word"] = word
                    new_data["pot"] = 0
                    new_data["cs"] = 1
                    new_data["l-deletion"] = 1
                    new_data["c-deletion"] = 0
                    new_data["tensification"] = 0
                    new_data["generated_word"] = l_deletion
                    new_lst.append(new_data)

                if condition == condition3:
                    stem = word.split("-")[0]
                    c_first_half_word = stem[:-1]
                    c_deletion = c_first_half_word + word.split("-")[1]

                    new_data["word"] = word
                    new_data["pot"] = 0
                    new_data["cs"] = 1
                    new_data["l-deletion"] = 0
                    new_data["c-deletion"] = 1
                    new_data["tensification"] = 0
                    new_data["generated_word"] = c_deletion
                    new_lst.append(new_data)

                if condition == condition4:
                    stem = word.split("-")[0]

                    l_first_half_word = stem.replace(stem[-2], "")
                    l_deletion = l_first_half_word + "-" + word.split("-")[1]

                    pot = l_first_half_word + "*" + word.split("-")[1]
                    for k, v in mapping.items():
                        if k in pot:
                            new_word = pot.replace(k,v)

                    new_data["word"] = word
                    new_data["pot"] = 1
                    new_data["cs"] = 1
                    new_data["l-deletion"] = 1
                    new_data["c-deletion"] = 0
                    new_data["tensification"] = 1
                    new_data["generated_word"] = new_word
                    new_lst.append(new_data)


                if condition == condition5:
                    stem = word.split("-")[0]
                    c_first_half_word = stem[:-1]
                    c_deletion = c_first_half_word + word.split("-")[1]

                    pot = c_first_half_word + "*" + word.split("-")[1]

                    for k, v in mapping.items():
                        if k in pot:
                            new_word = pot.replace(k,v)

                    new_data["word"] = word
                    new_data["pot"] = 1
                    new_data["cs"] = 1
                    new_data["l-deletion"] = 1
                    new_data["c-deletion"] = 0
                    new_data["tensification"] = 1
                    new_data["generated_word"] = new_word
                    new_lst.append(new_data)


    return new_lst


def nikl_vowels():

    with open("output_nikl_vowel.json") as f:
        data = json.load(f)


    new_lst = []

    for item in data:

        new_data = {}
        word = list(item.keys())[0]
        new_word = word.replace("-", "")

        new_data["word"] = word
        new_data["pot"] = 0
        new_data["tensification"] = 0
        new_data["lateralization"] = 0
        new_data["generated_word"] = new_word
        new_lst.append(new_data)

    return new_lst

if __name__ == "__main__":

    new_lst = nikl_sonorant()
    with open("final_nikl_sonorant.json", "w+") as f:
        json.dump(new_lst, f)
