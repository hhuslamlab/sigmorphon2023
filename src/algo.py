import pandas as pd
import json

if __name__ == "__main__":

    data = pd.read_csv("../data/NIKL_lC+Vowel.csv").fillna("")

    words = data["Morphology_R"].tolist()
    # affix_romanization = data["Affix_romanization"].tolist()

    # stem_types = data["StemType"].tolist()

    # affix_initial_segments = data["AffixInitialSegment"].tolist()

    # words = data["Word_romanization"].tolist()

    # df = pd.DataFrame()
    final_lst = []


    # for word, affix, stem_type, affix_initial_segment in zip(words, affix_romanization, stem_types, affix_initial_segments):

    for word in words:
        all_cs = []
        all_pot = []
        all_vowels = []
        all_both = []
        custom_dict = {}
        custom_lst = []
        pot = {"pot": 1, "cs": 0}
        cs = {"pot": 0, "cs": 1}
        both = {"pot": 1, "cs": 1}
        vowels = {"pot": 0, "cs": 0}

        ## obstruent
        condition1 = {"pot": 1, "cs": 0, "l-deletion": 0, "c-deletion": 0, "tensification": 1}
        condition2 = {"pot": 0, "cs": 1, "l-deletion": 1, "c-deletion": 0, "tensification": 0}
        condition3 = {"pot": 0, "cs": 1, "l-deletion": 0, "c-deletion": 1, "tensification": 0}
        condition4 = {"pot": 1, "cs": 1, "l-deletion": 1, "c-deletion": 0, "tensification": 1}
        condition5 = {"pot": 1, "cs": 1, "l-deletion": 0, "c-deletion": 1, "tensification": 1}

        ## sonorant
        condition6 = {"pot": 0, "cs": 0, "l-deletion": 0, "c-deletion": 0, "tensification": 0, "nasalization": 0}
        condition7 = {"pot": 0, "cs": 1, "l-deletion": 1, "c-deletion": 0, "tensification": 0, "nasalization": 0}
        condition8 = {"pot": 0, "cs": 1, "l-deletion": 1, "c-deletion": 0, "tensification": 0, "nasalization": 1}
        condition9 = {"pot": 0, "cs": 1, "l-deletion": 0, "c-deletion": 1, "tensification": 0, "nasalization": 0}

        ## vowels
        condition11 = {"pot": 0, "cs": 0, "tensification": 0, "lateralization": 0}

        custom_lst.append(condition11)

        # if stem_type == "lC":
        #     if affix_initial_segment == "Obstruent":
        # custom_lst.append(both)

        # custom_lst.append(pot)
        ## obstruent

#         custom_lst.append(condition1)
#         custom_lst.append(condition2)
#         custom_lst.append(condition3)
#         custom_lst.append(condition4)
#         custom_lst.append(condition5)

        ## sonorant
        # custom_lst.append(condition6)
        # custom_lst.append(condition7)
        # custom_lst.append(condition8)
        # custom_lst.append(condition9)
        # # print("POT or CS, affix: ", affix, ", word: ", word)
            # if affix_initial_segment == "Sonorant":
            #     custom_lst.append(cs)
            #     # print("CS, affix: ", affix, " word: ", word)
            # if affix_initial_segment == "Vowel":
            #     # print("CS, affix: ", affix, " word: ", word)
            #     custom_lst.append(vowels)


        # if stem_type == "C":
            # # print("POT, affix: ", affix, ", word: ", word)
            # custom_lst.append(pot)
        custom_dict[word] = custom_lst
        final_lst.append(custom_dict)


with open("output_nikl_vowel.json", "w+") as f:
    json.dump(final_lst, f)
