import pandas as pd

if __name__ == "__main__":
    experimental = pd.read_csv("../data/train_and_dev_without_best.csv")
    nikl = pd.read_csv("../data/all_NIKL_files.csv")

    input_exp = experimental["Word_romanization"].tolist()
    ur_exp = experimental["UR"].tolist()
    input_nikl = nikl["Morphology_R"].tolist()

    input_nikl = [item.replace('-', '') for item in input_nikl]

    ur_nikl = nikl["UR"].tolist()

    with open("../data/train_predictions.txt") as f:
        train_preds = f.readlines()
        train_preds = [item.strip() for item in train_preds]
    with open("../data/train.kr.input") as f:
        train_input = f.readlines()
        train_input = [item.replace(" ", "").strip() for item in train_input]


    actual_input = input_nikl + input_exp
    actual_ur = ur_nikl + ur_exp

    df = pd.DataFrame()

    df["Morphology_R"] = actual_input
    df["UR"] = actual_ur
    df["pred"] = train_preds

    df.to_csv("../data/train_predictions_df.csv", index=False)
