# Task 2 of the SIGMORPHON–UniMorph Shared Task on Typologically Diverse and Acquisition-Inspired Morphological Inflection Generation

_Description_: This is the code and data repository of Task 2 of the SIGMORPHON–UniMorph Shared Task on Typologically Diverse and Acquisition-Inspired Morphological Inflection Generation.
The repository contains the code and analysis scripts for both modelling approaches (Linear Discriminative Learning and Transformer).
Each modelling approach has two parts (Study 1 and Study 2). In addition, there is an analysis on the variability of the experimental data.

_Citation_: If you use any part of this repository, please cite the following paper and the Github repository.

```bibtex
@inproceedings{jeong-etal-2023-linear,
    title = "Linear Discriminative Learning: a competitive non-neural baseline for morphological inflection",
    author = "Jeong, Cheonkam  and
      Schmitz, Dominic  and
      Kakolu Ramarao, Akhilesh  and
      Stein, Anna  and
      Tang, Kevin",
    booktitle = "Proceedings of the 20th SIGMORPHON workshop on Computational Research in Phonetics, Phonology, and Morphology",
    month = jul,
    year = "2023",
    address = "Toronto, Canada",
    publisher = "Association for Computational Linguistics",
    url = "https://aclanthology.org/2023.sigmorphon-1.16",
    pages = "138--150",
    abstract = "This paper presents our submission to the SIGMORPHON 2023 task 2 of Cognitively Plausible Morphophonological Generalization in Korean. We implemented both Linear Discriminative Learning and Transformer models and found that the Linear Discriminative Learning model trained on a combination of corpus and experimental data showed the best performance with the overall accuracy of around 83{\%}. We found that the best model must be trained on both corpus data and the experimental data of one particular participant. Our examination of speaker-variability and speaker-specific information did not explain why a particular participant combined well with the corpus data. We recommend Linear Discriminative Learning models as a future non-neural baseline system, owning to its training speed, accuracy, model interpretability and cognitive plausibility. In order to improve the model performance, we suggest using bigger data and/or performing data augmentation and incorporating speaker- and item-specifics considerably.",
}
```

## Linear Discriminative Learning

### Installation


## Neural

![Platform]

[![Cuda]()](https://developer.nvidia.com/cuda-toolkit-archive)

[![Python](https://img.shields.io/badge/python-v3.8-blue?logo=python)](https://www.python.org/)


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


## Acknowledgements
We gratefully acknowledge the support of the central HPC system `HILBERT` at Heinrich-Heine-University, Düsseldorf.
