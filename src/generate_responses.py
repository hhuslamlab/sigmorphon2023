jmport pandas as pd
import json

def simple_coda(data):

    c_obstruent = data[data["JunctureType"] == "C+Obstruent"]
    c_sonorant = data[data["JunctureType"] == "C+Sonorant"]
    c_vowel = data[data["JunctureType"] == "C+Vowel"]

    obstruent_cond_1 = {"pot": 1, "cs": 0, "l-deletion": 0, "c-deletion": 0, "tensification": 1}
    obstruent_cond_2 = {"pot": 0, "cs": 0, "l-deletion": 0, "c-deletion": 0, "tensification": 0}

    sonorant_cond_1 =  {"pot": 0, "cs": 0, "l-deletion": 0, "c-deletion": 0, "tensification": 0}

    vowel_cond_1 =  {"pot": 0, "cs": 0, "l-deletion": 0, "c-deletion": 0, "tensification": 0}

def complex_coda(stem, affix):

    lc_obstruent = data[data["JunctureType"] == "lC+Obstruent"]
    lc_sonorant = data[data["JunctureType"] == "lC+Sonorant"]
    lc_vowel = data[data["JunctureType"] == "lC+Vowel"]

    obstruent_cond_1 = {"pot": 1, "cs": 1, "l-deletion": 1, "c-deletion": 0, "tensification": 1}
    obstruent_cond_2 = {"pot": 0, "cs": 1, "l-deletion": 1, "c-deletion": 0, "tensification": 0}
    obstruent_cond_3 =  {"pot": 0, "cs": 1, "l-deletion": 0, "c-deletion": 1, "tensification": 0}
    obstruent_cond_4 = {"pot": 1, "cs": 1, "l-deletion": 0, "c-deletion": 1, "tensification": 1}

    sonorant_cond_1 = {"pot": 0, "cs": 1, "l-deletion": 1, "c-deletion": 0, "tensification": 0}
    sonorant_cond_2 =  {"pot": 0, "cs": 1, "l-deletion": 0, "c-deletion": 1, "tensification": 0}

    vowel_cond_1 = {"pot": 0, "cs": 0, "l-deletion": 0, "c-deletion": 0, "tensification": 0}

if __name__ == "__main__":

    data = pd.read_csv("../data/train.csv").fillna("")

    stem = data["Stem_romanization"].tolist()
    stem_type = data["StemType"].tolist()

    affix = data["Affix_romanization"].tolist()


    lc = data[data["StemType"] == "lC"]

    c = data[data["StemType"] == "C"]
