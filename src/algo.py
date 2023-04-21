import pandas as pd

if __name__ == "__main__":

    data = pd.read_csv("../data/test_no_answers.csv").fillna("")

    affix_romanization = data["Affix_romanization"].tolist()

    stem_types = data["StemType"].tolist()

    affix_initial_segments = data["AffixInitialSegment"].tolist()

    words = data["Word_romanization"].tolist()

    for word, affix, stem_type, affix_initial_segment in zip(words, affix_romanization, stem_types, affix_initial_segments):
        if stem_type == "lC":
            if affix_initial_segment == "Obstruent":
                print("POT or CS, affix: ", affix, ", word: ", word)
            elif affix_initial_segment == "Sonorant":
                print("CS, affix: ", affix, " word: ", word)

            else:
                print("nothing, affix: ", affix, ", word: ", word)

        if stem_type == "C":
            print("POT, affix: ", affix, ", word: ", word)
