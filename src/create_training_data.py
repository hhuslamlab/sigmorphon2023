import pandas as pd



if __name__ == "__main__":


    data = pd.read_csv("../data/IPA_NIKL_lC+Obstruent.csv")

    ipa_morph_r = data["IPA_Morphology_R"].tolist()

    simplify_del_obstruent = data["simplify_delete_obstruent"].tolist()

    simplify_del_lateral = data["simplify_delete_lateral"].tolist()

    ipa_prod_r = data["IPA_Production_R"].tolist()

    _input = []
    _output = []

    for morph, sdo, sdl, prod in zip(ipa_morph_r, simplify_del_obstruent, simplify_del_lateral, ipa_prod_r):
        morph = " ".join(str(item) for item in morph)
        _input.append(morph + " " + str(sdo) + " " + str(sdl))
        prod = " ".join(str(i) for i in prod)
        _output.append(prod)
