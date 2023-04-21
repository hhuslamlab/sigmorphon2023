# sigmorphon_LDL_imp_v04
### Dominic Schmitz
2023-04-10

This file presents an updated LDL implementation. The rationale behind this implementation is as follows:
NIKL and Ko data represent the lexicon of an adult L1 speaker of Korean. Each form is represented once in the mental lexicon as we assume that this is what is true for the mental lexicon. As LDL aims to model/simulate the mental lexicon, this is in line with the theory behind LDL.
In a first step, the comprehension and production processes of the mental lexicon are modelled. This is done based on the shared real word lexicon and the experimental data of each participants. As a result, we have as many implementations as training data participants, i.e. 12.
With these 12 implementations, we can predict the production of the dev/test participants. Potentially, this is done by selecting the training and the dev/test participants who are most similar. For now, however, simply everyone is compared to everyone.

## Data
### Load data
```r
load("../data/NIKL_obstruent.RData")
load("../data/NIKL_sonorant.RData")
load("../data/NIKL_vowel.RData")
load("../data/ko.RData")
load("../data/train.RData")
load("../data/part_dev.RData")
```
### Clean & wrangle data
NIKL:
```r
NIKL_o <- NIKL_obstruent[c(1, 4:11)]
NIKL_s <- NIKL_sonorant[c(1, 4:11)]
NIKL_v <- NIKL_vowel[c(1, 4:11)]
 
NIKL <- rbind(NIKL_o, NIKL_s, NIKL_v)
 
names(NIKL)[1] <- "Morphology_R"
NIKL <-  NIKL[complete.cases(NIKL$Production_R), ]

# create morphology variables
NIKL$lexome1 <- gsub("-.*", "", NIKL$Morphology_R)
NIKL$lexome2 <- gsub(".*-", "", NIKL$Morphology_R)
 
# create phonology variable
NIKL$form <- gsub("\\.", "", NIKL$Production_R)
```

#### Ko:
```r
names(ko)[1] <- "Morphology_R"
 
Ko <- data.frame(Morphology_R = ko$Morphology_R, 
                 Production_R = ko$Production_R,
                 UR = ko$UR,
                 SR = ko$SR,
                 simplify_delete_obstruent = ko$C_deletion,
                 simplify_delete_lateral = ko$L_deletion,
                 nasalize = ko$Nasalization,
                 lateralize = ko$Lateralization,
                 tensify = ko$Tensification)
 
# create morphology variables
Ko$lexome1 <- gsub("-.*", "", Ko$Morphology_R)
Ko$lexome2 <- gsub(".*-", "", Ko$Morphology_R)
 
# create phonology variable
Ko$form <- gsub("\\.", "", Ko$Production_R)
```
#### Training:
```r
train_sub <- data.frame(Morphology_R = paste(train$Stem_romanization, train$Affix_romanization, sep ="-"), 
                        Production_R = train$Production_R,
                        UR = train$UR,
                        SR = train$Production_R,
                        simplify_delete_obstruent = train$C_deletion,
                        simplify_delete_lateral = train$L_deletion,
                        nasalize = train$Nasalization,
                        lateralize = train$Lateralization,
                        tensify = train$Tensification,
                        lexome1 = train$Stem_romanization,
                        lexome2 = train$Affix_romanization,
                        form = train$Production_R,
                        participant = train$Exp_Subject_Id)
```
#### Dev:
```r
dev_sub <- data.frame(Morphology_R = paste(part_dev$Stem_romanization, part_dev$Affix_romanization, sep ="-"), 
                        Production_R = part_dev$Production_R,
                        UR = part_dev$UR,
                        SR = part_dev$Production_R,
                        simplify_delete_obstruent = part_dev$C_deletion,
                        simplify_delete_lateral = part_dev$L_deletion,
                        nasalize = part_dev$Nasalization,
                        lateralize = part_dev$Lateralization,
                        tensify = part_dev$Tensification,
                        lexome1 = part_dev$Stem_romanization,
                        lexome2 = part_dev$Affix_romanization,
                        form = part_dev$Production_R,
                        participant = part_dev$Exp_Subject_Id)
                       
```

## LDL implementation
### Part 1: Training Data
The implementations for the individual training data participants are all done in one giant for-loop:
```r
library(WpmWithLdl)
 
train_list <- list()
 
for(i in 1:nlevels(as.factor(train_sub$participant))){
  
  run <- list()
  
  # DATA
  NIKL_Ko <- rbind(NIKL, Ko)
  NIKL_Ko <- subset(NIKL_Ko, !duplicated(NIKL_Ko))
  
  train_run <- subset(train_sub, participant == levels(as.factor(train_sub$participant))[i])
  
  NIKL_Ko_train <- rbind(NIKL_Ko, train_run[1:12])
  
  # C MAT
  C_mat <- make_cue_matrix(data = NIKL_Ko_train, formula = ~ lexome1 + lexome2, grams = 3, wordform = "form")
  
  # S MAT
  segments_list <- strsplit(NIKL_Ko_train$Morphology_R, "-")
 
  all_segments <- unique(unlist(segments_list))
  
  binary_matrix <- matrix(0, nrow = nrow(NIKL_Ko_train), ncol = length(all_segments), dimnames = list(NULL, all_segments))
  
  for (m in 1:nrow(NIKL_Ko_train)) {
    segments <- segments_list[[m]]
    binary_matrix[m, segments] <- 1
  }
  
  S_mat <- binary_matrix
  
  # COMPREHENSION
  rownames(S_mat) <- rownames(C_mat$matrices$C)
  
  comp <- learn_comprehension(cue_obj = C_mat, S = S_mat)
  
  comp_acc <- accuracy_comprehension(m = comp, data = NIKL_Ko_train, wordform = "form", show_rank = T, neighborhood_density = T)
  
  # PRODUCTION
  prod <- learn_production(cue_obj = C_mat, S = S_mat, comp = comp)
  
  prod_acc <- accuracy_production(m = prod, data = NIKL_Ko_train, grams = 3, full_results = T, wordform = "form", return_triphone_supports = T)
  
  # SAVING
  run[[1]] <- levels(as.factor(train_sub$participant))[i]
  run[[2]] <- train_run
  run[[3]] <- NIKL_Ko_train
  run[[4]] <- C_mat
  run[[5]] <- S_mat
  run[[6]] <- comp
  run[[7]] <- comp_acc
  run[[8]] <- comp_acc$acc
  run[[9]] <- prod
  run[[10]] <- prod_acc
  run[[11]] <- prod_acc$acc
  
  names(run) <- c("part", "train_run", "NIKL_Ko_train", "C_mat", "S_mat", "comp", "comp_acc", 
                  "comp_accuracy", "prod", "prod_acc", "prod_accuracy")
  
  train_list[[i]] <- run
  
}
 
names(train_list) <- levels(as.factor(train_sub$participant))
 
save(train_list, file = "../data/train_list.RData")
```

### Part 2: Dev Data
Next, the forms produced by the dev data participants are predicted. This is done with a function (so we can check individual pairings if we want/need to). This is the function:
```r
get_predictions <- function(train_participant, train_list, predicted_participant, predicted_data){
  
  run <- list()
  
  # DATA
  dev_run <- subset(predicted_data, participant == predicted_participant)
  
  NIKL_Ko_train_dev <- rbind(NIKL_Ko_train, dev_run[1:12])
  
  # S MAT
  segments_list <- strsplit(NIKL_Ko_train_dev$Morphology_R, "-")
  
  all_segments <- unique(unlist(segments_list))
  
  binary_matrix <- matrix(0, nrow = nrow(NIKL_Ko_train_dev), ncol = length(all_segments), dimnames = list(NULL, all_segments))
  
  for (m in 1:nrow(NIKL_Ko_train_dev)) {
    segments <- segments_list[[m]]
    binary_matrix[m, segments] <- 1
  }
  
  S_mat_run <- binary_matrix
  
  # C MAT
  G_run <- train_list[[train_participant]][["prod"]][["production_matrices"]][["G"]]
  
  C_run <- S_mat_run %*% G_run
  
  C_mat_run <- train_list[[train_participant]][["C_mat"]]
  C_mat_run$matrices$C <- C_run
  
  # PRODUCTION
  prod_run <- learn_production(cue_obj = C_mat_run, S = S_mat_run)
  
  prod_acc_run <- accuracy_production(m = prod_run, data = NIKL_Ko_train_dev, grams = 3, full_results = T, wordform = "form", return_triphone_supports = T)
  
  # PREDICTIONS
  predicted <- prod_acc_run$forms$preds
  predicted <- tail(predicted, nrow(dev_run))
  
  data_run_pred <- cbind(dev_run, predicted)
  data_run_pred$pred_correct <- "yes"
  data_run_pred$pred_correct[data_run_pred$predicted != data_run_pred$Production_R] <- "no"
  data_run_pred$pred_correct <- as.factor(data_run_pred$pred_correct)
  
  prediction_abs <- summary(data_run_pred$pred_correct)
  prediction_yes_ratio <- prediction_abs[2]/nrow(dev_run)
  
  
  # SAVING
  run[[1]] <- train_participant
  run[[2]] <- predicted_participant
  run[[3]] <- NIKL_Ko_train_dev
  run[[4]] <- S_mat_run
  run[[5]] <- G_run
  run[[6]] <- C_run
  run[[7]] <- C_mat_run
  run[[8]] <- prod_run
  run[[9]] <- prod_acc_run
  run[[10]] <- prod_acc_run$acc
  run[[11]] <- data_run_pred
  run[[12]] <- prediction_abs
  run[[13]] <- prediction_yes_ratio
  
  names(run) <- c("train_participant", "predicted_participant", "NIKL_Ko_train_dev", "S_mat_run", "G_run", "C_run", "C_mat_run", 
                  "prod_run", "prod_acc_run", "prod_acc_run_accuracy", "data_run_pred", "prediction_abs", "prediction_yes_ratio")
  
  return(run)
}
```

Next, we use this function to compare all combinations of training and dev participants:
```r
predictions_575760 <- list()
 
for(i in 1:nlevels(as.factor(train_sub$participant))){
  
  predictions_575760[[i]] <- get_predictions(train_participant = levels(as.factor(train_sub$participant))[i],
                                             train_list = train_list,
                                             predicted_participant = "575760",
                                             predicted_data = dev_sub)
}
 
save(predictions_575760, file = "../data/predictions_575760.RData")
 
 
predictions_578698 <- list()
 
for(i in 1:nlevels(as.factor(train_sub$participant))){
  
  predictions_578698[[i]] <- get_predictions(train_participant = levels(as.factor(train_sub$participant))[i],
                                             train_list = train_list,
                                             predicted_participant = "578698",
                                             predicted_data = dev_sub)
}
 
save(predictions_578698, file = "../data/predictions_578698.RData")
 
 
predictions_592117 <- list()
 
for(i in 1:nlevels(as.factor(train_sub$participant))){
  
  predictions_592117[[i]] <- get_predictions(train_participant = levels(as.factor(train_sub$participant))[i],
                                             train_list = train_list,
                                             predicted_participant = "592117",
                                             predicted_data = dev_sub)
}
 
save(predictions_592117, file = "../data/predictions_592117.RData")
 
 
predictions_592166 <- list()
 
for(i in 1:nlevels(as.factor(train_sub$participant))){
  
  predictions_592166[[i]] <- get_predictions(train_participant = levels(as.factor(train_sub$participant))[i],
                                             train_list = train_list,
                                             predicted_participant = "592166",
                                             predicted_data = dev_sub)
}
 
save(predictions_592166, file = "../data/predictions_592166.RData")
```

## Prediction accuracy
The following lists contain the percentage of correctly predicted SRs.
### participant 575760
```r
load("../data/predictions_575760.RData")
 
yes_ratio_575760 <- data.frame()
for(i in 1:12){
  yes_ratio_575760[i,1] <- print(predictions_575760[[i]][["prediction_yes_ratio"]][["yes"]])
}
## [1] 0.4550898
## [1] 0.5329341
## [1] 0.3592814
## [1] 0.3892216
## [1] 0.3892216
## [1] 0.3113772
## [1] 0.3772455
## [1] 0.3413174
## [1] 0.5808383
## [1] 0.3293413
## [1] 0.3772455
## [1] 0.3832335
```

#### participant 578698
```r
load("../data/predictions_578698.RData")
 
yes_ratio_578698 <- data.frame()
for(i in 1:12){
  yes_ratio_578698[i,1] <- print(predictions_578698[[i]][["prediction_yes_ratio"]][["yes"]])
}
## [1] 0.6871508
## [1] 0.5865922
## [1] 0.5865922
## [1] 0.6256983
## [1] 0.726257
## [1] 0.6089385
## [1] 0.6592179
## [1] 0.6536313
## [1] 0.6089385
## [1] 0.6312849
## [1] 0.7486034
## [1] 0.7206704
```

#### participant 592117
```r
load("../data/predictions_592117.RData")
 
yes_ratio_592117 <- data.frame()
for(i in 1:12){
  yes_ratio_592117[i,1] <- print(predictions_592117[[i]][["prediction_yes_ratio"]][["yes"]])
}
## [1] 0.7333333
## [1] 0.5944444
## [1] 0.6722222
## [1] 0.7166667
## [1] 0.7666667
## [1] 0.6888889
## [1] 0.7666667
## [1] 0.7111111
## [1] 0.5611111
## [1] 0.7222222
## [1] 0.75
## [1] 0.7777778
```
#### participant 592166
```r
load("../data/predictions_592166.RData")
 
yes_ratio_592166 <- data.frame()
for(i in 1:12){
  yes_ratio_592166[i,1] <- print(predictions_592166[[i]][["prediction_yes_ratio"]][["yes"]])
}
## [1] 0.6321839
## [1] 0.5977011
## [1] 0.5057471
## [1] 0.5632184
## [1] 0.6091954
## [1] 0.5402299
## [1] 0.6034483
## [1] 0.5574713
## [1] 0.5344828
## [1] 0.5574713
## [1] 0.6264368
## [1] 0.6436782
```` 
