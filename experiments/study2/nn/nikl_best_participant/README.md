## NIKL + Ko with productions all participants except the productions from the best participant

In this experiment, we train a model on the combined dataset (NIKL, and the Ko corpus) with productions from all participants except the best participant's productions and using the productions from best participant as development data.

TODO Add dataset preparation scripts

### Preprocessing

```sh
sh preproces.sh kr
```

### Training

```sh
sh train.sh kr
```
