import pandas as pd
from sklearn.model_selection import train_test_split


if __name__ == "__main__":

    data = pd.read_csv(
        "/home/akhilesh/personal/sigmorphon2023/data/all_NIKL.csv"
    ).fillna("")

    morph_r = data["Morphology_R"].tolist()

    # simplify_del_obstruent = data["simplify_delete_obstruent"].tolist()

    # simplify_del_lateral = data["simplify_delete_lateral"].tolist()

    prod_r = data["Production_R"].tolist()

    _input = []
    _output = []

    for morph, prod in zip(morph_r, prod_r):
        morph = " ".join(str(item) for item in morph)
        _input.append(morph)
        prod = " ".join(str(i) for i in prod)
        _output.append(prod)

    with open(
        "/home/akhilesh/personal/sigmorphon2023/data/neural/baseline/kr.input", "w+"
    ) as f:
        for item in _input:
            f.write(item + "\n")

    with open(
        "/home/akhilesh/personal/sigmorphon2023/data/neural/baseline/kr.output", "w+"
    ) as f:
        for item in _output:
            f.write(item + "\n")

    X_train, X_test, y_train, y_test = train_test_split(
        _input, _output, test_size=0.2, random_state=42
    )
    X_train, X_val, y_train, y_val = train_test_split(
        X_train, y_train, test_size=0.125, random_state=1
    )

    with open(
        "/home/akhilesh/personal/sigmorphon2023/data/neural/baseline/train.kr.input",
        "w+",
    ) as f:
        for item in X_train:
            f.write(item + "\n")

    with open(
        "/home/akhilesh/personal/sigmorphon2023/data/neural/baseline/train.kr.output",
        "w+",
    ) as f:
        for item in y_train:
            f.write(item + "\n")

    with open(
        "/home/akhilesh/personal/sigmorphon2023/data/neural/baseline/valid.kr.input",
        "w+",
    ) as f:
        for item in X_val:
            f.write(item + "\n")

    with open(
        "/home/akhilesh/personal/sigmorphon2023/data/neural/baseline/valid.kr.output",
        "w+",
    ) as f:
        for item in y_val:
            f.write(item + "\n")

    with open(
        "/home/akhilesh/personal/sigmorphon2023/data/neural/baseline/test.kr.input",
        "w+",
    ) as f:
        for item in X_test:
            f.write(item + "\n")

    with open(
        "/home/akhilesh/personal/sigmorphon2023/data/neural/baseline/test.kr.output",
        "w+",
    ) as f:
        for item in y_test:
            f.write(item + "\n")
