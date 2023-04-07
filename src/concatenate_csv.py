import pandas as pd
import glob
import os

if __name__ == "__main__":
    path = "../data/"

    all_files = []

    for filename in os.dir(path):
        if filename.startswith("NIKL"):
            all_files.append(os.path.join(path, filename))

    li = []

    for filename in all_files:
        df = pd.read_csv(filename, index_col=None, header=0)
        li.append(df)

    frame = pd.concat(li, axis=0, ignore_index=True)
