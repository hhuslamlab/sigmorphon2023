## LDL - Study 2
#  last update: 07/05/2023

## set working directory
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))
rm(current_path)

## load libraries
library(WpmWithLdl)
library(LDLConvFunctions)

# load data ----

load("../data/NIKL_obstruent.RData")
load("../data/NIKL_sonorant.RData")
load("../data/NIKL_vowel.RData")

load("../data/Ko_clean.RData")

load("../data/train.RData")

load("../data/part_dev.RData")

# prepare data ----

## NIKL ----

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

# create freq variable
NIKL$frequency <- NA

# create origin variable
NIKL$origin <- "NIKL"

## Ko ----

ko <- Ko_clean

names(ko)[1] <- "Morphology_R"

Ko <- data.frame(Morphology_R = ko$Morphology_R,
                 Production_R = ko$corrected_Production_R,
                 UR = ko$UR,
                 SR = ko$SR,
                 simplify_delete_obstruent = ko$C_deletion,
                 simplify_delete_lateral = ko$L_deletion,
                 nasalize = ko$Nasalization,
                 lateralize = ko$Lateralization,
                 tensify = ko$Tensification)

# remove double notation for singular sound
Ko$Morphology_R <- gsub("\\*s", "S", Ko$Morphology_R)
Ko$Production_R <- gsub("\\*s", "S", Ko$Production_R)
Ko$UR <- gsub("\\*s", "S", Ko$UR)
Ko$SR <- gsub("\\*s", "S", Ko$SR)
Ko$Production_R <- gsub("\\*k", "g", Ko$Production_R)
Ko$Production_R <- gsub("\\*t", "d", Ko$Production_R)

# create morphology variables
Ko$lexome1 <- gsub("-.*", "", Ko$Morphology_R)
Ko$lexome2 <- gsub(".*-", "", Ko$Morphology_R)

# create phonology variable
Ko$form <- gsub("\\.", "", Ko$Production_R)

# create freq variable
Ko$frequency <- NA

# create origin variable
Ko$origin <- "Ko"


## training ----

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
                        participant = train$Exp_Subject_Id,
                        frequency = train$Frequency)

# create origin variable
train_sub$origin <- "train"

# remove double notation for singular sound
train_sub$Morphology_R <- gsub("p\\*", "b", train_sub$Morphology_R)
train_sub$Morphology_R <- gsub("t\\*", "d", train_sub$Morphology_R)
train_sub$Morphology_R <- gsub("k\\*", "g", train_sub$Morphology_R)
train_sub$Morphology_R <- gsub("s\\*", "S", train_sub$Morphology_R)

train_sub$lexome1 <- gsub("p\\*", "b", train_sub$lexome1)
train_sub$lexome1 <- gsub("t\\*", "d", train_sub$lexome1)
train_sub$lexome1 <- gsub("k\\*", "g", train_sub$lexome1)
train_sub$lexome1 <- gsub("s\\*", "S", train_sub$lexome1)


## dev ----

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
                      participant = part_dev$Exp_Subject_Id,
                      frequency = part_dev$Frequency)

# create origin variable
dev_sub$origin <- "dev"

# remove double notation for singular sound
dev_sub$Morphology_R <- gsub("p\\*", "b", dev_sub$Morphology_R)
dev_sub$Morphology_R <- gsub("t\\*", "d", dev_sub$Morphology_R)
dev_sub$Morphology_R <- gsub("k\\*", "g", dev_sub$Morphology_R)
dev_sub$Morphology_R <- gsub("s\\*", "S", dev_sub$Morphology_R)

dev_sub$lexome1 <- gsub("p\\*", "b", dev_sub$lexome1)
dev_sub$lexome1 <- gsub("t\\*", "d", dev_sub$lexome1)
dev_sub$lexome1 <- gsub("k\\*", "g", dev_sub$lexome1)
dev_sub$lexome1 <- gsub("s\\*", "S", dev_sub$lexome1)


## train + dev ----

data_td <- rbind(train_sub, dev_sub)


# LDL ----

## LDL for train + dev ----

td_list <- list()

for(i in 1:nlevels(as.factor(data_td$participant))){
  
  run <- list()
  
  # DATA
  NIKL_Ko <- rbind(NIKL, Ko)
  NIKL_Ko <- subset(NIKL_Ko, !duplicated(NIKL_Ko))
  
  train_run <- subset(data_td, participant == levels(as.factor(data_td$participant))[i])
  
  NIKL_Ko_train <- rbind(NIKL_Ko, train_run[c(1:12, 14:15)])
  
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
  run[[1]] <- levels(as.factor(data_td$participant))[i]
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
  
  td_list[[i]] <- run
  
}

names(td_list) <- levels(as.factor(data_td$participant))


## predicting train + dev by train + dev ----

get_predictions <- function(train_participant, train_list, predicted_participant, predicted_data){
  
  run <- list()
  
  # DATA
  dev_run <- subset(predicted_data, participant == predicted_participant)
  
  NIKL_Ko_train_dev <- rbind(train_list[[train_participant]][["NIKL_Ko_train"]][c(1,3,10,11,13,14)], dev_run[c(1, 3, 10:11, 14:15)])
  
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
  
  NIKL_Ko_train_dev$form <- paste(NIKL_Ko_train_dev$lexome1, NIKL_Ko_train_dev$lexome2, sep = "-")
  
  prod_acc_run <- accuracy_production(m = prod_run, data = NIKL_Ko_train_dev, grams = 3, full_results = T, wordform = "form", return_triphone_supports = T, threshold = 0.08)
  
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


# in the following objects you find the LDL accuracies for all 16 train+dev participants by all other train+dev participants

predictions_td_556014 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_556014[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "556014",
                                                predicted_data = data_td)
}


predictions_td_556033 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_556033[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "556033",
                                                predicted_data = data_td)
}


predictions_td_556505 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_556505[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "556505",
                                                predicted_data = data_td)
}


predictions_td_559838 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_559838[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "559838",
                                                predicted_data = data_td)
}


predictions_td_563118 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_563118[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "563118",
                                                predicted_data = data_td)
}


predictions_td_565631 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_565631[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "565631",
                                                predicted_data = data_td)
}


predictions_td_575760 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_575760[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "575760",
                                                predicted_data = data_td)
}


predictions_td_578085 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_578085[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "578085",
                                                predicted_data = data_td)
}


predictions_td_578698 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_578698[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "578698",
                                                predicted_data = data_td)
}


predictions_td_581952 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_581952[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "581952",
                                                predicted_data = data_td)
}


predictions_td_585660 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_585660[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "585660",
                                                predicted_data = data_td)
}


predictions_td_589028 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_589028[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "589028",
                                                predicted_data = data_td)
}


predictions_td_592117 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_592117[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "592117",
                                                predicted_data = data_td)
}


predictions_td_592166 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_592166[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "592166",
                                                predicted_data = data_td)
}


predictions_td_594939 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_594939[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "594939",
                                                predicted_data = data_td)
}


predictions_td_597515 <- list()
for(i in 1:nlevels(as.factor(data_td$participant))){
  
  predictions_td_597515[[i]] <- get_predictions(train_participant = levels(as.factor(data_td$participant))[i],
                                                train_list = td_list,
                                                predicted_participant = "597515",
                                                predicted_data = data_td)
}


### accuracies ----

all_predictions <- list(predictions_td_556014,
                        predictions_td_556033,
                        predictions_td_556505,
                        predictions_td_559838,
                        predictions_td_563118,
                        predictions_td_565631,
                        predictions_td_575760,
                        predictions_td_578085,
                        predictions_td_578698,
                        predictions_td_581952,
                        predictions_td_585660,
                        predictions_td_589028,
                        predictions_td_592117,
                        predictions_td_592166,
                        predictions_td_594939,
                        predictions_td_597515)


yes_ratios_high <- data.frame()

for(i in 1:16){
  
  for(m in 1:16){
    
    value <- table(all_predictions[[i]][[m]][["data_run_pred"]]$pred_correct, all_predictions[[i]][[m]][["data_run_pred"]]$frequency)[2,1] /
      sum(table(all_predictions[[i]][[m]][["data_run_pred"]]$pred_correct, all_predictions[[i]][[m]][["data_run_pred"]]$frequency)[1,1],
          table(all_predictions[[i]][[m]][["data_run_pred"]]$pred_correct, all_predictions[[i]][[m]][["data_run_pred"]]$frequency)[2,1])
    
    yes_ratios_high[m, i] <- value
    
  }
  
}

colnames(yes_ratios_high) <- levels(as.factor(data_td$participant))
rownames(yes_ratios_high) <- levels(as.factor(data_td$participant))


yes_ratios_low <- data.frame()

for(i in 1:16){
  
  for(m in 1:16){
    
    value <- table(all_predictions[[i]][[m]][["data_run_pred"]]$pred_correct, all_predictions[[i]][[m]][["data_run_pred"]]$frequency)[2,2] /
      sum(table(all_predictions[[i]][[m]][["data_run_pred"]]$pred_correct, all_predictions[[i]][[m]][["data_run_pred"]]$frequency)[1,2],
          table(all_predictions[[i]][[m]][["data_run_pred"]]$pred_correct, all_predictions[[i]][[m]][["data_run_pred"]]$frequency)[2,2])
    
    yes_ratios_low[m, i] <- value
    
  }
  
}

colnames(yes_ratios_low) <- levels(as.factor(data_td$participant))
rownames(yes_ratios_low) <- levels(as.factor(data_td$participant))


yes_ratios_nonce <- data.frame()

for(i in 1:16){
  
  for(m in 1:16){
    
    value <- table(all_predictions[[i]][[m]][["data_run_pred"]]$pred_correct, all_predictions[[i]][[m]][["data_run_pred"]]$frequency)[2,3] /
      sum(table(all_predictions[[i]][[m]][["data_run_pred"]]$pred_correct, all_predictions[[i]][[m]][["data_run_pred"]]$frequency)[1,3],
          table(all_predictions[[i]][[m]][["data_run_pred"]]$pred_correct, all_predictions[[i]][[m]][["data_run_pred"]]$frequency)[2,3])
    
    yes_ratios_nonce[m, i] <- value
    
  }
  
}

colnames(yes_ratios_nonce) <- levels(as.factor(data_td$participant))
rownames(yes_ratios_nonce) <- levels(as.factor(data_td$participant))


### vectorisation ----

# this can be done for all 16 train + dev participants

data <- all_predictions[[1]][[1]][["data_run_pred"]]

vectors <- data.frame()

for(i in 1:nrow(data)){
  
  prediction <- data$predicted[i]
  
  
  # simplify_delete_obstruent
  if(grepl(data$lexome1[i], data$predicted[i]) & nchar(data$lexome1[i]) > 3){
    sdo <- 0
  }else if(nchar(data$lexome1[i]) > 3){
    sdo <- 1
  }else{
    sdo <- NA
  }
  
  
  # simplify_delete_lateral
  if(grepl("l", data$UR[i]) & grepl("l", data$predicted[i])){
    sdl <- 0
  }else if(grepl("l", data$UR[i]) & !grepl("l", data$predicted[i])){
    sdl <- 1
  }else{
    sdl <- NA
  }
  
  
  # nasalize
  if(grepl("n", data$UR[i]) & grepl("N", data$predicted[i])){
    nas <- 1
  }else if (grepl("n", data$UR[i]) & !grepl("N", data$predicted[i])){
    nas <- 0
  }else{
    nas <- NA
  }
  
  
  # lateralize 
  if(grepl("l", data$UR[i]) & grepl("ll", data$predicted[i])){
    lat <- 1
  }else if (grepl("l", data$UR[i]) & !grepl("ll", data$predicted[i])){
    lat <- 0
  }else{
    lat <- NA
  }
  
  
  # tensify 
  if(grepl("n", data$UR[i])){
    ten <- NA
  }else if(grepl("b", data$predicted[i]) | grepl("d", data$predicted[i]) | grepl("g", data$predicted[i])){
    ten <- 1
  }else{
    ten <- 0
  }
  
  
  vectors[i,1] <- sdo
  vectors[i,2] <- sdl
  vectors[i,3] <- nas
  vectors[i,4] <- lat
  vectors[i,5] <- ten
  
  names(vectors) <- c("simplify_delete_obstruent", "simplify_delete_lateral", 
                      "nasalize", "lateralize", "tensify")
  
}


## predicting test by train + dev ----

get_predictions2 <- function(train_participant, train_list, predicted_participant, predicted_data){
  
  run <- list()
  
  # DATA
  dev_run <- subset(predicted_data, participant == predicted_participant)
  
  # NIKL_Ko_train_dev <- rbind(NIKL_Ko_train[c(1,3,10,11,13,14)], dev_run[c(1:4, 6:7)])
  NIKL_Ko_train_dev <- rbind(train_list[[train_participant]][["NIKL_Ko_train"]][c(1,3,10,11,13,14)], dev_run[c(1:4, 6:7)])
  
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
  # G_run <- td_list[["597515"]][["prod"]][["production_matrices"]][["G"]]
  
  C_run <- S_mat_run %*% G_run
  
  C_mat_run <- train_list[[train_participant]][["C_mat"]]
  #C_mat_run <- td_list[["597515"]][["C_mat"]]
  
  C_mat_run$matrices$C <- C_run
  
  # PRODUCTION
  prod_run <- learn_production(cue_obj = C_mat_run, S = S_mat_run)
  
  NIKL_Ko_train_dev$form <- paste(NIKL_Ko_train_dev$lexome1, NIKL_Ko_train_dev$lexome2, sep = "-")
  
  prod_acc_run <- accuracy_production(m = prod_run, data = NIKL_Ko_train_dev, grams = 3, full_results = T, wordform = "form", return_triphone_supports = T, threshold = 0.08)
  
  # PREDICTIONS
  predicted <- prod_acc_run$forms$preds
  predicted <- tail(predicted, nrow(dev_run))
  
  data_run_pred <- cbind(dev_run, predicted)
  # data_run_pred$pred_correct <- "yes"
  # data_run_pred$pred_correct[data_run_pred$predicted != data_run_pred$Production_R] <- "no"
  # data_run_pred$pred_correct <- as.factor(data_run_pred$pred_correct)
  
  # prediction_abs <- summary(data_run_pred$pred_correct)
  # prediction_yes_ratio <- prediction_abs[2]/nrow(dev_run)
  
  
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
  # run[[12]] <- prediction_abs
  # run[[13]] <- prediction_yes_ratio
  
  names(run) <- c("train_participant", "predicted_participant", "NIKL_Ko_train_dev", "S_mat_run", "G_run", "C_run", "C_mat_run", 
                  "prod_run", "prod_acc_run", "prod_acc_run_accuracy", "data_run_pred")
  
  return(run)
}


load("../data/data_test.RData")

test_data <- data.frame(Morphology_R = paste(data_test$Stem_romanization, data_test$Affix_romanization, sep ="-"),
                        UR = data_test$UR,
                        lexome1 = data_test$Stem_romanization,
                        lexome2 = data_test$Affix_romanization,
                        participant = data_test$Exp_Subject_Id,
                        frequency = data_test$Frequency)

test_data$origin <- "test"

# remove double notation for singular sound
test_data$Morphology_R <- gsub("p\\*", "b", test_data$Morphology_R)
test_data$Morphology_R <- gsub("t\\*", "d", test_data$Morphology_R)
test_data$Morphology_R <- gsub("k\\*", "g", test_data$Morphology_R)
test_data$Morphology_R <- gsub("s\\*", "S", test_data$Morphology_R)

test_data$lexome1 <- gsub("p\\*", "b", test_data$lexome1)
test_data$lexome1 <- gsub("t\\*", "d", test_data$lexome1)
test_data$lexome1 <- gsub("k\\*", "g", test_data$lexome1)
test_data$lexome1 <- gsub("s\\*", "S", test_data$lexome1)


# predictions
p559474_by_p597515 <- get_predictions2(train_participant = "597515",
                                      train_list = td_list,
                                      predicted_participant = "559474",
                                      predicted_data = test_data)

p559679_by_p597515 <- get_predictions2(train_participant = "597515",
                                      train_list = td_list,
                                      predicted_participant = "559679",
                                      predicted_data = test_data)

p567753_by_p597515 <- get_predictions2(train_participant = "597515",
                                      train_list = td_list,
                                      predicted_participant = "567753",
                                      predicted_data = test_data)

p569705_by_p597515 <- get_predictions2(train_participant = "597515",
                                      train_list = td_list,
                                      predicted_participant = "569705",
                                      predicted_data = test_data)

p579254_by_p597515 <- get_predictions2(train_participant = "597515",
                                      train_list = td_list,
                                      predicted_participant = "579254",
                                      predicted_data = test_data)

p580616_by_p597515 <- get_predictions2(train_participant = "597515",
                                      train_list = td_list,
                                      predicted_participant = "580616",
                                      predicted_data = test_data)

p584007_by_p597515 <- get_predictions2(train_participant = "597515",
                                      train_list = td_list,
                                      predicted_participant = "584007",
                                      predicted_data = test_data)


### vectorisation ----

get_vector <- function(predictions){
  
  vectors <- data.frame()
  
  data <- predictions[["data_run_pred"]]
  
  for(i in 1:nrow(data)){
    
    prediction <- data$predicted[i]
    
    
    # simplify_delete_obstruent
    if(grepl(data$lexome1[i], data$predicted[i]) & nchar(data$lexome1[i]) > 3){
      sdo <- 0
    }else if(nchar(data$lexome1[i]) > 3){
      sdo <- 1
    }else{
      sdo <- NA
    }
    
    
    # simplify_delete_lateral
    if(grepl("l", data$UR[i]) & grepl("l", data$predicted[i])){
      sdl <- 0
    }else if(grepl("l", data$UR[i]) & !grepl("l", data$predicted[i])){
      sdl <- 1
    }else{
      sdl <- NA
    }
    
    
    # nasalize
    if(grepl("n", data$UR[i]) & grepl("N", data$predicted[i]) | grepl("mn", data$predicted[i]) | grepl("nn", data$predicted[i])){
      nas <- 1
    }else if (grepl("n", data$UR[i]) & !grepl("N", data$predicted[i]) | grepl("n", data$UR[i]) & !grepl("mn", data$predicted[i]) | grepl("n", data$UR[i]) & !grepl("nn", data$predicted[i])){
      nas <- 0
    }else{
      nas <- NA
    }
    
    
    # lateralize 
    if(grepl("l", data$UR[i]) & grepl("ll", data$predicted[i])){
      lat <- 1
    }else if (grepl("l", data$UR[i]) & !grepl("ll", data$predicted[i])){
      lat <- 0
    }else{
      lat <- NA
    }
    
    
    # tensify 
    if(grepl("n", data$UR[i])){
      ten <- NA
    }else if(grepl("b", data$predicted[i]) | grepl("d", data$predicted[i]) | grepl("g", data$predicted[i])){
      ten <- 1
    }else{
      ten <- 0
    }
    
    
    vectors[i,1] <- sdo
    vectors[i,2] <- sdl
    vectors[i,3] <- nas
    vectors[i,4] <- lat
    vectors[i,5] <- ten
    
    names(vectors) <- c("simplify_delete_obstruent", "simplify_delete_lateral", 
                        "nasalize", "lateralize", "tensify")
    
  }
  
  result <- cbind(data, vectors)
  
  return(result)
}


vectors_p559474 <- get_vector(p559474_by_p597515)
vectors_p559679 <- get_vector(p559679_by_p597515)
vectors_p567753 <- get_vector(p567753_by_p597515)
vectors_p569705 <- get_vector(p569705_by_p597515)
vectors_p579254 <- get_vector(p579254_by_p597515)
vectors_p580616 <- get_vector(p580616_by_p597515)
vectors_p584007 <- get_vector(p584007_by_p597515)

# add to data_test
vectors <- rbind(vectors_p559474,
                 vectors_p559679,
                 vectors_p567753,
                 vectors_p569705,
                 vectors_p579254,
                 vectors_p580616,
                 vectors_p584007)

data_test_predictions <- cbind(data_test, vectors[8:13])[2:21]


### perplexity ----

#### for test participants ----

# p559474
Pnorm_list_p559474 <- list()
Perplex_list_p559474 <- list()

for(i in 1:length(p559474_by_p597515[["prod_acc_run"]][["full"]])){
  
  n_candidates <- length(p559474_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]])
  
  for(m in 1:n_candidates){
    
    v_run <- names(p559474_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]])
    
    prediction <- p559474_by_p597515[["prod_acc_run"]][["full"]][[i]][["prediction"]]
    
    if(ngram2word(v = v_run) == prediction){
      
      product <- prod(p559474_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1])
      
      Pnorm <- product^(1 / length(p559474_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1]))
      
      Perplex <- 1 / Pnorm
      
    }
    
    Pnorm_list_p559474[[i]] <- Pnorm
    
    Perplex_list_p559474[[i]] <- Perplex
    
  }
  
}

data_p559474 <- get_vector(p559474_by_p597515)

data_p559474$perplexity <- tail(unlist(Perplex_list_p559474), nrow(data_p559474))

# p559679
Pnorm_list_p559679 <- list()
Perplex_list_p559679 <- list()

for(i in 1:length(p559679_by_p597515[["prod_acc_run"]][["full"]])){
  
  n_candidates <- length(p559679_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]])
  
  for(m in 1:n_candidates){
    
    v_run <- names(p559679_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]])
    
    prediction <- p559679_by_p597515[["prod_acc_run"]][["full"]][[i]][["prediction"]]
    
    if(ngram2word(v = v_run) == prediction){
      
      product <- prod(p559679_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1])
      
      Pnorm = product^(1 / length(p559679_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1]))
      
      Perplex <- 1 / Pnorm
      
    }
    
    Pnorm_list_p559679[[i]] <- Pnorm
    
    Perplex_list_p559679[[i]] <- Perplex
    
  }
  
}

data_p559679 <- get_vector(p559679_by_p597515)

data_p559679$perplexity <- tail(unlist(Perplex_list_p559679), nrow(data_p559679))

# p567753
Pnorm_list_p567753 <- list()
Perplex_list_p567753 <- list()

for(i in 1:length(p567753_by_p597515[["prod_acc_run"]][["full"]])){
  
  n_candidates <- length(p567753_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]])
  
  for(m in 1:n_candidates){
    
    v_run <- names(p567753_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]])
    
    prediction <- p567753_by_p597515[["prod_acc_run"]][["full"]][[i]][["prediction"]]
    
    if(ngram2word(v = v_run) == prediction){
      
      product <- prod(p567753_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1])
      
      Pnorm = product^(1 / length(p567753_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1]))
      
      Perplex <- 1 / Pnorm
      
    }
    
    Pnorm_list_p567753[[i]] <- Pnorm
    
    Perplex_list_p567753[[i]] <- Perplex
    
  }
  
}

data_p567753 <- get_vector(p567753_by_p597515)

data_p567753$perplexity <- tail(unlist(Perplex_list_p567753), nrow(data_p567753))

# p569705
Pnorm_list_p569705 <- list()
Perplex_list_p569705 <- list()

for(i in 1:length(p569705_by_p597515[["prod_acc_run"]][["full"]])){
  
  n_candidates <- length(p569705_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]])
  
  for(m in 1:n_candidates){
    
    v_run <- names(p569705_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]])
    
    prediction <- p569705_by_p597515[["prod_acc_run"]][["full"]][[i]][["prediction"]]
    
    if(ngram2word(v = v_run) == prediction){
      
      product <- prod(p569705_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1])
      
      Pnorm = product^(1 / length(p569705_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1]))
      
      Perplex <- 1 / Pnorm
      
    }
    
    Pnorm_list_p569705[[i]] <- Pnorm
    
    Perplex_list_p569705[[i]] <- Perplex
    
  }
  
}

data_p569705 <- get_vector(p569705_by_p597515)

data_p569705$perplexity <- tail(unlist(Perplex_list_p569705), nrow(data_p569705))


# p579254
Pnorm_list_p579254 <- list()
Perplex_list_p579254 <- list()

for(i in 1:length(p579254_by_p597515[["prod_acc_run"]][["full"]])){
  
  n_candidates <- length(p579254_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]])
  
  for(m in 1:n_candidates){
    
    v_run <- names(p579254_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]])
    
    prediction <- p579254_by_p597515[["prod_acc_run"]][["full"]][[i]][["prediction"]]
    
    if(ngram2word(v = v_run) == prediction){
      
      product <- prod(p579254_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1])
      
      Pnorm = product^(1 / length(p579254_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1]))
      
      Perplex <- 1 / Pnorm
      
    }
    
    Pnorm_list_p579254[[i]] <- Pnorm
    
    Perplex_list_p579254[[i]] <- Perplex
    
  }
  
}

data_p579254 <- get_vector(p579254_by_p597515)

data_p579254$perplexity <- tail(unlist(Perplex_list_p579254), nrow(data_p579254))

# p580616
Pnorm_list_p580616 <- list()
Perplex_list_p580616 <- list()

for(i in 1:length(p580616_by_p597515[["prod_acc_run"]][["full"]])){
  
  n_candidates <- length(p580616_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]])
  
  for(m in 1:n_candidates){
    
    v_run <- names(p580616_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]])
    
    prediction <- p580616_by_p597515[["prod_acc_run"]][["full"]][[i]][["prediction"]]
    
    if(ngram2word(v = v_run) == prediction){
      
      product <- prod(p580616_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1])
      
      Pnorm = product^(1 / length(p580616_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1]))
      
      Perplex <- 1 / Pnorm
      
    }
    
    Pnorm_list_p580616[[i]] <- Pnorm
    
    Perplex_list_p580616[[i]] <- Perplex
    
  }
  
}

data_p580616 <- get_vector(p580616_by_p597515)

data_p580616$perplexity <- tail(unlist(Perplex_list_p580616), nrow(data_p580616))

# p584007
Pnorm_list_p584007 <- list()
Perplex_list_p584007 <- list()

for(i in 1:length(p584007_by_p597515[["prod_acc_run"]][["full"]])){
  
  n_candidates <- length(p584007_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]])
  
  for(m in 1:n_candidates){
    
    v_run <- names(p584007_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]])
    
    prediction <- p584007_by_p597515[["prod_acc_run"]][["full"]][[i]][["prediction"]]
    
    if(ngram2word(v = v_run) == prediction){
      
      product <- prod(p584007_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1])
      
      Pnorm = product^(1 / length(p584007_by_p597515[["prod_acc_run"]][["full"]][[i]][["li"]][[m]][-1]))
      
      Perplex <- 1 / Pnorm
      
    }
    
    Pnorm_list_p584007[[i]] <- Pnorm
    
    Perplex_list_p584007[[i]] <- Perplex
    
  }
  
}

data_p584007 <- get_vector(p584007_by_p597515)

data_p584007$perplexity <- tail(unlist(Perplex_list_p584007), nrow(data_p584007))


test_w_perplexity <- rbind(data_p559474,
                           data_p559679,
                           data_p567753,
                           data_p569705,
                           data_p579254,
                           data_p580616,
                           data_p584007)


#### for participant 597515 ----

##### re-train LDL for p597515 ----

data_td_597515 <- subset(data_td, participant == 597515)

p597515_list <- list()

for(i in 1:nlevels(as.factor(data_td_597515$participant))){
  
  run <- list()
  
  # DATA
  NIKL_Ko <- rbind(NIKL, Ko)
  NIKL_Ko <- subset(NIKL_Ko, !duplicated(NIKL_Ko))
  
  train_run <- subset(data_td_597515, participant == levels(as.factor(data_td_597515$participant))[i])
  
  NIKL_Ko_train <- rbind(NIKL_Ko, train_run[c(1:12, 14:15)])
  
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
  
  prod_acc <- accuracy_production(m = prod, data = NIKL_Ko_train, grams = 3, full_results = T, wordform = "form", return_triphone_supports = T, threshold = 0.08)
  
  # SAVING
  run[[1]] <- levels(as.factor(data_td_597515$participant))[i]
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
  
  p597515_list[[i]] <- run
  
}

names(p597515_list) <- levels(as.factor(data_td_597515$participant))


##### perplexity for p597515_by_p597515 ----

Pnorm_list_p597515 <- list()
Perplex_list_p597515 <- list()

for(i in 1:length(p597515_list[["597515"]][["prod_acc"]][["full"]])){
  
  n_candidates <- length(p597515_list[["597515"]][["prod_acc"]][["full"]][[i]][["li"]])
  
  for(m in 1:n_candidates){
    
    v_run <- names(p597515_list[["597515"]][["prod_acc"]][["full"]][[i]][["li"]][[m]])
    
    prediction <- p597515_list[["597515"]][["prod_acc"]][["full"]][[i]][["prediction"]]
    
    if(ngram2word(v = v_run) == prediction){
      
      product <- prod(p597515_list[["597515"]][["prod_acc"]][["full"]][[i]][["li"]][[m]][-1])
      
      Pnorm = product^(1 / length(p597515_list[["597515"]][["prod_acc"]][["full"]][[i]][["li"]][[m]][-1]))
      
      Perplex <- 1 / Pnorm
      
    }
    
    Pnorm_list_p597515[[i]] <- Pnorm
    
    Perplex_list_p597515[[i]] <- Perplex
    
  }
  
}

data_p597515 <- p597515_list[["597515"]][["NIKL_Ko_train"]]

data_p597515$perplexity <- tail(unlist(Perplex_list_p597515), nrow(data_p597515))


## vectors for train data ----

p597515_list[["597515"]][["NIKL_Ko_train"]]$participant <- "597515"

p597515_list[["597515"]][["NIKL_Ko_train"]]$predicted <- p597515_list[["597515"]][["prod_acc"]][["forms"]][["preds"]]

data_train_NIKL_Ko <- p597515_list[["597515"]][["NIKL_Ko_train"]]


get_vector2 <- function(data){
  
  vectors <- data.frame()
  
  for(i in 1:nrow(data)){
    
    prediction <- data$predicted[i]
    
    
    # simplify_delete_obstruent
    if(grepl(data$lexome1[i], data$predicted[i]) & nchar(data$lexome1[i]) > 3){
      sdo <- 0
    }else if(nchar(data$lexome1[i]) > 3){
      sdo <- 1
    }else{
      sdo <- NA
    }
    
    
    # simplify_delete_lateral
    if(grepl("l", data$UR[i]) & grepl("l", data$predicted[i])){
      sdl <- 0
    }else if(grepl("l", data$UR[i]) & !grepl("l", data$predicted[i])){
      sdl <- 1
    }else{
      sdl <- NA
    }
    
    
    # nasalize
    if(grepl("n", data$UR[i]) & grepl("N", data$predicted[i]) | grepl("mn", data$predicted[i]) | grepl("nn", data$predicted[i])){
      nas <- 1
    }else if (grepl("n", data$UR[i]) & !grepl("N", data$predicted[i]) | grepl("n", data$UR[i]) & !grepl("mn", data$predicted[i]) | grepl("n", data$UR[i]) & !grepl("nn", data$predicted[i])){
      nas <- 0
    }else{
      nas <- NA
    }
    
    
    # lateralize 
    if(grepl("l", data$UR[i]) & grepl("ll", data$predicted[i])){
      lat <- 1
    }else if (grepl("l", data$UR[i]) & !grepl("ll", data$predicted[i])){
      lat <- 0
    }else{
      lat <- NA
    }
    
    
    # tensify 
    if(grepl("n", data$UR[i])){
      ten <- NA
    }else if(grepl("b", data$predicted[i]) | grepl("d", data$predicted[i]) | grepl("g", data$predicted[i])){
      ten <- 1
    }else{
      ten <- 0
    }
    
    
    vectors[i,1] <- sdo
    vectors[i,2] <- sdl
    vectors[i,3] <- nas
    vectors[i,4] <- lat
    vectors[i,5] <- ten
    
    names(vectors) <- c("simplify_delete_obstruent", "simplify_delete_lateral", 
                        "nasalize", "lateralize", "tensify")
    
  }
  
  result <- cbind(data, vectors)
  
  return(result)
}


vectors_p559474 <- get_vector2(data_train_NIKL_Ko)

data_train_NIKL_Ko_predictions <- vectors_p559474




