## NIKL + Ko with productions all participants except the productions from the worst participant

In this experiment, we train a model on the combined dataset (NIKL, and the Ko corpus) with productions from all participants except the worst participant's productions and using the productions from worst participant as development data.

TODO Add dataset preparation scripts

### Preprocessing

```sh
sh preproces.sh kr
```

### Training

```sh
sh train.sh kr
```
