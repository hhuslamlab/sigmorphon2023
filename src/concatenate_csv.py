import pandas as pd
import glob
import os

if __name__ == "__main__":
    path = "/home/akhilesh/personal/sigmorphon2023/data/"  ## change to your filepath

    all_files = [
        "NIKL_lC+Obstruent.csv",
        "NIKL_lC+Sonorant.csv",
        "modified_NIKL_lC+Vowel.csv",
    ]
    # for filename in os.listdir(path):
    #     if filename.startswith("NIKL"):
    #         all_files.append(os.path.join(path, filename))

    li = []

    for filename in all_files:
        df = pd.read_csv(filename, index_col=None, header=0)
        li.append(df)

    frame = pd.concat(li, axis=0, ignore_index=True).fillna("")

    frame.to_csv(
        "/home/akhilesh/personal/sigmorphon2023/data/all_NIKL.csv", index=False
    )
