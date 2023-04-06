"""
Script for converting contents of your file to IPA.

Usage:
    converter.py --filename=<f>

Options:
   --filename=<f>                   Provide the filename
"""
from docopt import docopt
import pandas as pd
import json

def read_data(filename):
    data = pd.read_csv(filename)

    return data

def roman2ipa(filename):
    data = pd.read_csv(filename)
    data_dict = {}
    roman = data["Romanization"].tolist()
    ipa = data["IPA"].tolist()

    for ro, ip in zip(roman, ipa):
        data_dict[ro] = ip

    return data_dict

def convert(col_lst, mapper):
    new_col_lst = []
    for item in col_lst:
        print(item)
        word = []
        for c in item:
            print(c)
            if c == "-" or c == '.':
                word.append(c)
            else:
                word.append(mapper[c])

        new_col_lst.append("".join(word))

    return new_col_lst

if __name__ == "__main__":
    args = docopt(__doc__)

    filename = args["--filename"]


    ## reading the raw csv
    raw_data = read_data(filename)

    ## getting the roman to ipa map
    mapper = roman2ipa("../data/RomanizationToIPAKey.csv")

    ## converting the romanized coloumns to ipa-based
    morph_r = raw_data["Morphology_R"].tolist()
    ipa_morph_r = convert(morph_r, mapper)

    if filename != "../data/NIKL_lC+Vowel.csv":
        production_r = raw_data["Production_R"].tolist()
        ipa_production_r = convert(production_r, mapper)

    ur = raw_data["UR"].tolist()

    ipa_ur = convert(ur, mapper)

    sr = raw_data["SR"].tolist()
    ipa_sr = convert(sr, mapper)

    raw_data["IPA_Morphology_R"] = ipa_morph_r

    ## HACKME
    if filename != "../data/NIKL_lC+Vowel.csv":
        raw_data["IPA_Production_R"] = ipa_production_r

    raw_data["IPA_UR"] = ipa_ur
    raw_data["IPA_SR"] = ipa_sr

    raw_data.to_csv(filename.split('/')[0] + "/" + filename.split('/')[1] + "/" + "IPA_" + filename.split('/')[2], index=False)
