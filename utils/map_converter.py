import pandas as pd
import json


if __name__ == "__main__"
    data = pd.read_csv("../data/RomanizationToIPAKey.csv")
    data_dict = {}
    roman = data["Romanization"].tolist()
    ipa = data["IPA"].tolist()

    for ro, ip in zip(roman, ipa):
        data_dict[ro] = ip with open("../data/mapping.json", "w+") as f:
        json.dump(data_dict, f)
