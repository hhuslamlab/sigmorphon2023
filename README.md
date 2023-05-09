# Task 2 of the SIGMORPHON–UniMorph Shared Task on Typologically Diverse and Acquisition-Inspired Morphological Inflection Generation

_Description_: This is the code and data repository of Task 2 of the SIGMORPHON–UniMorph Shared Task on Typologically Diverse and Acquisition-Inspired Morphological Inflection Generation.
The repository contains the code and analysis scripts for both modelling approaches (Linear Discriminative Learning and Transformer).
Each modelling approach has two parts (Study 1 and Study 2). In addition, there is an analysis on the variability of the experimental data.

_Citation_: If you use any part of this repository, please cite the following paper and the Github repository.

```
@InProceedings{JeongSchmitzKakoluRSteinTang_LDL_SIGMORPHON_2023,
  author    = {Cheonkam Jeong and Dominic Schmitz and Akhilesh {Kakolu Ramarao} and Anna Sophia {Stein} and Kevin Tang},
  title     = {Linear Discriminative Learning: a competitive non-neural baseline for morphological inflection},
  booktitle = {Proceedings of the 20th SIGMORPHON Workshop on Computational Research in Phonetics, Phonology, and Morphology},
  year      = {2023},
  publisher = {Association for Computational Linguistics},
  month     = {},
  pages     = {},
  url       = {},
  abstract  = {This paper presents our submission to the SIGMORPHON 2023 task 2 of Cognitively Plausible Morphophonological Generalization in Korean. We implemented both Linear Discriminative Learning and Transformer models and found that the Linear Discriminative Learning model trained on a combination of corpus and experimental data showed the best performance with the overall accuracy of around 83\%. We found that the best model must be trained on both corpus data and the experimental data of one particular participant. Our examination of speaker-variability and speaker-specific information did not explain why a particular participant combined well with the corpus data. We recommend Linear Discriminative Learning models as a future non-neural baseline system, owning to its training speed, accuracy, model interpretability and cognitive plausibility. In order to improve the model performance, we suggest using bigger data and/or performing data augmentation and incorporating speaker- and item-specifics considerably.},
  address   = {},
}
```

## Linear Discriminative Learning

### Installation


## Neural


### Installation

- Python3.8
- PyTorch version >= 1.10.0

```
pip install fairseq
```

All other python libraries can be installed using:

```
pip install -r requirements.txt
```
