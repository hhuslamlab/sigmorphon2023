## Corpus Data
* **NILK files**: exerpts from adult-directed speech
* **Ko file**: exerpts from child-directed corpus

Key to the column headers in the corpus files: 
* **Morphology_R** - morphological parse, romanization. Consists of more or less the URs for each morpheme
* **Morphology_H** - morphological parse, Hangul.
* **Production_R** - production, romanization. Represents the option chosen by the participant, in phonemic detail (ie, representing the actual assumed segmental targets, the "SR", with phonological processes applied)
* **Production_H** - production, Hangul.
* **U**R - segmental sequence surrounding the morpheme juncture (noted "-")
* **SR** - segmental sequence of how the UR was produced in the Production
* **simplify_delete_obstruent** - did the speaker delete an obstruent in the UR? (1 = yes, 0 = no, NA = not applicable)
* **simplify_delete_lateral** - did the speaker delete a lateral in the UR? 
* **nasalize** - did the speaker nasalize the coda of the stem? Nasal assimilation is regressive across the morpheme boundary from the suffix, targeting an obstruent. 
* **lateralize** - did the speaker lateralize the onset of the affix? In l-final stems, lateralization is progressive across the morpheme boundary. This is rare in this dataset, but can arise if the speaker simplifies an lC cluster by deleting the obstruent, which may then feed lateralization of a following C.
* **tensify**	- did the speaker tensify the onset of the affix?
* **Type** - type of juncture.

## Experimental Data
[Here](https://github.com/sigmorphon/2023InflectionST/blob/main/part2/Korean_data_slides.pdf) is a slide deck describing the data, modeled on a talk from the 2023 LSA Annual Meeting.

The file [`experimental_data_description`](https://github.com/hhuslamlab/sigmorphon2023/blob/98ced3170487093cebe55fb4f4a087a715d9c96a/data/experimental_data_description.md) contains/will contain additional information on the datasets, like entropy, distribution of levels etc., that will be continually updated.

*  **dev**: 701 rows, 20 cols
*  **train**: 2144 rows, 20 cols
*  **test_no_answers**: 1248 rows, 14 cols

Key to the column headers in the corpus files: 
* **Trial_Nr** - ‘linear trial order’ i.e. order of experimental items (range 1-180)
* **Trial_Id** - stem+affix combination for that trial (range 1-180)
* **Exp_Subject_Id** - participant id (7 levels)
* **OptionChosen** - production option that corresponds to the particular combination of tensificaton, nasalization, simplification, etc. for that particular wug form (6 levels) (might actually not be that, pending answer from organisers)
* **TargetWord** - hangul version of verb + affix (180 levels)
* **knowledge** - familiarity rating on a 1-5 scale (5 levels)
* **StemType** - -lc or -c (simplex coda verb) (2 levels)
* **Stem_romanization** - romanized version of the stem (64 levels)
* **Frequency** - ‘low’, ‘nonce’ or ‘high’ (3 levels)
* **AffixInitialSegment** - vowel, sonorant or obstruent (3 levels)
* **Affix_romanization** - (4 levels)
* **JunctureType** - -lc + vowel/sonorant/obstruent, -c + vowel/sonorant/obstruent
* **UR** - segmental sequence surrounding the morpheme juncture (noted “-”) (30 levels)
* **Word_romanization** - Word_romanization (180 levels)
--------only in dev and train -----------
* **Production_R** - production, romanization. Represents the option chosen by the participant, in phonemic detail (ie, representing the actual assumed segmental targets, the "SR", with phonological processes applied)
* **nasalization** - did the speaker nasalize the coda of the stem? Nasal assimilation is regressive across the morpheme boundary from the suffix, targeting an obstruent. 
* **lateralization** - did the speaker lateralize the onset of the affix? In l-final stems, lateralization is progressive across the morpheme boundary. This is rare in this dataset, but can arise if the speaker simplifies an lC cluster by deleting the obstruent, which may then feed lateralization of a following C.
* **tensification**	- did the speaker tensify the onset of the affix?
* **C_deletion** - was the consonant in affix deleted? 0, 1, or NA

## Other files
* dictionary : frequency dict of -lc coda verbs
the dictionary used for the Dictionary file is:  Kang, B.-M., & Kim, H.-G. (2004). Hankwuke hyengtayso mich ehwi sayong pintouy pwunsek2 [Frequency analysis of Korean morpheme and word usage2]. Seoul: Institute of Korean Culture, Korea University

Please feel free to reach out if you have any questions, clarifications, or if you spot any errors - I'd love to hear from you! --> canaanbreiss1@gmail.com
