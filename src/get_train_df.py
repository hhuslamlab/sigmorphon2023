import pandas as pd
import json

if __name__ == "__main__":
    data = pd.read_csv("../data/all_NIKL_experimental.csv")

    input_data = data["Morphology_R"].tolist()

    ur = data["UR"].tolist()


    new_input = input_data[: int(len(input_data) * .7)]

    with open("../data/train.kr.input") as f:
        test = f.readlines()
        test = [item.replace(' ', '').strip() for item in test]

    new_input = [item.replace('-', '') for item in new_input]
