import pandas as pd

if __name__ == "__main__":
    with open("../data/data_files_nikl_training/sorted_kr.txt") as f:
        pred = f.readlines()
        pred = [item.strip() for item in pred]
        clean_pred = [item.split(",")[1].strip() for item in pred]
    with open("../data/data_files_nikl_training/wrong_preds_kr.txt") as f:
        wrong_pred = f.readlines()
        wrong_pred = [item.strip() for item in wrong_pred]

    data = pd.read_csv("../data/train_and_dev.csv")

    train_and_dev_input = data["Word_romanization"].tolist()
    train_and_dev_output = data["Production_R"].tolist()

    with open("../data/all_participants/train.kr.input", "w+") as f:
        for item in train_and_dev_input:
            f.write(item.replace("", " ") + "\n")

    with open("../data/all_participants/train.kr.output", "w+") as f:
        for item in train_and_dev_output:
            f.write(item.replace("", " ") + "\n")

    correct_wrong = []
    w_num = [w.split(",")[0] for w in wrong_pred]

    for p in pred:
        p_num = p.split(",")[0]
        if p_num in w_num:
            correct_wrong.append("no")
        else:
            correct_wrong.append("yes")

    new_data = pd.read_csv("/home/akhilesh/Downloads/data_test_predictions_wansw.csv")
    new_data["correct_wrong"] = correct_wrong

    new_test_input = new_data["Word_romanization"].tolist()

    new_data["neural_prediction"] = clean_pred

    new_data.to_csv("../data/test_with_right_answers_neural_all_participants.csv", index=False)
    with open("../data/actual_test.kr.input", "w+") as f:
        for item in new_test_input:
            f.write(item.replace('', ' ') + "\n")

    new_test_output = new_data["Production_R"].tolist()

    with open("../data/actual_test.kr.output", "w+") as f:
        for item in new_test_output:
            f.write(item.replace('', ' ') + "\n")



    best_participant = data[data["Exp_Subject_Id"] == 597515]
    second_best_participant = data[data["Exp_Subject_Id"] == 589028]

    third_best_participant = data[data["Exp_Subject_Id"] == 578698]

    fourth_best_participant = data[data["Exp_Subject_Id"] == 592117]
    best_four_participants = pd.concat([best_participant, second_best_participant, third_best_participant, fourth_best_participant], axis=0)

    worst_participant = data[data["Exp_Subject_Id"] == 575760]
    other_participants = data[data["Exp_Subject_Id"] != 597515]
    other_participants = pd.concat([data, best_four_participants, best_four_participants]).drop_duplicates(keep=False)

    other_participants = other_participants["Exp_Subject_Id"] != 597515]

    other_participants["predicted"] = pred

    participants_neural = list(set(data["Exp_Subject_Id"].tolist()))

    ldl_data = pd.read_csv("/home/akhilesh/Downloads/data_train_dev_predictions.csv")
    ldl_data["neural_prediction"] = pred
    ldl_data["neural_correct_wrong"] = correct_wrong

    ldl_data.to_csv("../data/best_participant/ldl_and_neural.csv", index=False)

    ### checking for conditions where neural is better

    correct_wrong_ldl = ldl_data["pred_correct"]

    n_better = []
    for n, l in zip(correct_wrong, correct_wrong_ldl):
        if n == "yes" and l == "no":
            n_better.append("better")

    other_participants.to_csv("../data/best_participant/df.csv", index=False)
    other_better_participants = data[data["Exp_Subject_Id"] != 575760]

    best_morph_r = best_four_participants["Word_romanization"].tolist()
    worst_morph_r = worst_participant["Word_romanization"].tolist()

    best_prod_r = best_four_participants["Production_R"].tolist()

    worst_prod_r = worst_participant["Production_R"].tolist()

#     input_mapping = {"*p": "P", "*t": "T", "S": "*s"}
#     output_mapping = {"*p": "b", "*t": "d", "*k": "g", "S": "*s", "*c": "J"}

#     new_best_morph_r = []
#     for item in best_morph_r:
#         for k, v in input_mapping.items():
#             if k in item:
#                 new_best_morph_r.append(item.replace(k,v))
#             else:
#                 new_best_morph_r.append(item)

#     new_best_prod_r = []
#     for item in best_prod_r:
#         for k, v in output_mapping.items():
#             if k in item:
#                 new_best_prod_r.append(item.replace(k,v))
#             else:
#                 new_best_prod_r.append(item)


    best_input = []
    best_output = []

    for morph, prod in zip(best_morph_r, best_prod_r):
        morph = " ".join(str(item) for item in morph)
        best_input.append(morph)
        prod = " ".join(str(i) for i in prod)
        best_output.append(prod)

    other_morph_r = other_participants["Word_romanization"].tolist()
    other_better_morph_r = other_better_participants["Word_romanization"].tolist()


    other_prod_r = other_participants["Production_R"].tolist()

    other_better_prod_r = other_better_participants["Production_R"].tolist()
#     new_other_morph_r = []
#     for item in other_morph_r:
#         for k, v in input_mapping.items():
#             if k in item:
#                 new_other_morph_r.append(item.replace(k,v))
#             else:
#                 new_other_morph_r.append(item)


#     new_other_prod_r = []
#     for item in other_prod_r:
#         for k, v in output_mapping.items():
#             if k in item:
#                 new_other_prod_r.append(item.replace(k,v))
#             else:
#                 new_other_prod_r.append(item)


    other_input = []
    other_output = []

    for morph, prod in zip(other_morph_r, other_prod_r):
        morph = " ".join(str(item) for item in morph)
        other_input.append(morph)
        prod = " ".join(str(i) for i in prod)
        other_output.append(prod)


    with open("../data/best_participant/train.kr.input", "w+") as f:
        for item in best_input:
            f.write(item + "\n")

    with open("../data/best_participant/train.kr.output", "w+") as f:
        for item in best_output:
            f.write(item + "\n")


    with open("../data/other_participants/test11.kr.input", "w+") as f:
        for item in other_input:
            f.write(item + "\n")

    with open("../data/other_participants/test11.kr.output", "w+") as f:
        for item in other_output:
            f.write(item + "\n")
