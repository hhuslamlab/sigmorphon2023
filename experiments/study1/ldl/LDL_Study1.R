## LDL - Study 1
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

## combined corpus data ----

NIKL_Ko <- rbind(NIKL, Ko)

NIKL_Ko <- subset(NIKL_Ko, !duplicated(NIKL_Ko))


# LDL ----

# We first showcase the stepwise LDL implementation by example of a single train participant, 556014.
# Then, a for-loop for automating the same type of implementation for all participants is given.

## Stepwise ----

train_556014 <- subset(train_sub, participant == "556014")


### combined corpus data ----

#### C matrix ----

C_mat <- make_cue_matrix(data = NIKL_Ko, formula = ~ lexome1 + lexome2, grams = 3, wordform = "form")

dim(C_mat$matrices$C)
# 585 826

#### S matrix ----

# this S matrix is binary coded, based on the UR

# Extract the segments from the original column using strsplit() function
segments_list <- strsplit(NIKL_Ko$Morphology_R, "-")

# Get all unique segments across all rows
all_segments <- unique(unlist(segments_list))

# Create an empty binary coded matrix with rows and columns equal to the number of unique segments
binary_matrix <- matrix(0, nrow = nrow(NIKL_Ko), ncol = length(all_segments), dimnames = list(NULL, all_segments))

# Loop through each row and update the binary matrix
for (i in 1:nrow(NIKL_Ko)) {
  segments <- segments_list[[i]]
  binary_matrix[i, segments] <- 1
}

# Convert the binary matrix to a data frame
S_mat <- binary_matrix

dim(S_mat) 
# 585 211

unique_row_names <- make.unique(NIKL_Ko$Morphology_R)

rownames(C_mat$matrices$C) <- unique_row_names
rownames(S_mat) <- unique_row_names


#### comprehension ----

comp <- learn_comprehension(cue_obj = C_mat, S = S_mat)


#### production ----

prod <- learn_production(cue_obj = C_mat, S = S_mat, comp = comp)

prod_acc <- accuracy_production(m = prod, data = NIKL_Ko, grams = 3, full_results = T, wordform = "form", return_triphone_supports = T)
prod_acc$acc # 0.6044304


### participant 556014 ----

#### C matrix ----

C_mat_556014 <- make_cue_matrix(data = train_556014, formula = ~ lexome1 + lexome2, grams = 3, wordform = "form")

dim(C_mat_556014$matrices$C)
# 180 237


#### S matrix ----

# extract the segments from the original column using strsplit() function
segments_list <- strsplit(train_556014$Morphology_R, "-")

# get all unique segments across all rows
all_segments <- unique(unlist(segments_list))

# create an empty binary coded matrix with rows and columns equal to the number of unique segments
binary_matrix <- matrix(0, nrow = nrow(train_556014), ncol = length(all_segments), dimnames = list(NULL, all_segments))

# loop through each row and update the binary matrix
for (i in 1:nrow(train_556014)) {
  segments <- segments_list[[i]]
  binary_matrix[i, segments] <- 1
}

S_mat_556014 <- binary_matrix

dim(S_mat_556014) 
# 180  64

unique_row_names <- make.unique(train_556014$Morphology_R)

rownames(C_mat_556014$matrices$C) <- unique_row_names
rownames(S_mat_556014) <- unique_row_names

#### combine S matrices ----

common_cols <- intersect(colnames(S_mat), colnames(S_mat_556014))

# Add new columns with zeros for non-matching column names in S_mat
for (colname in setdiff(colnames(S_mat_556014), colnames(S_mat))) {
  S_mat <- cbind(S_mat, 0)
  colnames(S_mat)[ncol(S_mat)] <- colname
}

# Add new columns with zeros for non-matching column names in S_mat_556014
for (colname in setdiff(colnames(S_mat), colnames(S_mat_556014))) {
  S_mat_556014 <- cbind(S_mat_556014, 0)
  colnames(S_mat_556014)[ncol(S_mat_556014)] <- colname
}

# Merge the matrices using rbind()
merged_mat <- rbind(S_mat, S_mat_556014)

dim(merged_mat) 
# 765 252


#### comprehension ----

# quickly build a C matrix for corpus + experimental words
NIKL_Ko_556014 <- rbind(NIKL_Ko[1:12], train_556014[1:12])
C_comb_556014 <- make_cue_matrix(data = NIKL_Ko_556014, formula = ~ lexome1 + lexome2, grams = 3, wordform = "form")

rownames(merged_mat) <- rownames(C_comb_556014$matrices$C)

comp_556014 <- learn_comprehension(cue_obj = C_comb_556014, S = merged_mat)


#### production ----

X = MASS::ginv(t(merged_mat) %*% merged_mat) %*% t(merged_mat)
Hprod = merged_mat %*% X
G = X %*% C_comb_556014$matrices$C
Chat = Hprod %*% C_comb_556014$matrices$C
rm(X, Hprod)

dim(G)
# 252 948


## Automated ----

train_list <- list()

for(i in 1:12){
  
  # C corpus
  C_mat <- make_cue_matrix(data = NIKL_Ko, formula = ~ lexome1 + lexome2, grams = 3, wordform = "form")
  
  # S corpus
  segments_list <- strsplit(NIKL_Ko$Morphology_R, "-")
  all_segments <- unique(unlist(segments_list))
  binary_matrix <- matrix(0, nrow = nrow(NIKL_Ko), ncol = length(all_segments), dimnames = list(NULL, all_segments))
  for (m in 1:nrow(NIKL_Ko)) {
    segments <- segments_list[[m]]
    binary_matrix[m, segments] <- 1
  }
  S_mat <- binary_matrix
  unique_row_names <- make.unique(NIKL_Ko$Morphology_R)
  rownames(C_mat$matrices$C) <- unique_row_names
  rownames(S_mat) <- unique_row_names
  
  # comp corpus
  comp <- learn_comprehension(cue_obj = C_mat, S = S_mat)
  
  run <- list()
  
  train_part <- subset(train_sub, participant == levels(as.factor(train_sub$participant))[i])
  
  # C
  C_mat_part <- make_cue_matrix(data = train_part, formula = ~ lexome1 + lexome2, grams = 3, wordform = "form")
  
  found_triphones_part <- find_triphones(pseudo_C_matrix = C_mat_part, real_C_matrix = C_mat)
  
  target_C_new_part <- reorder_pseudo_C_matrix(pseudo_C_matrix = C_mat_part, real_C_matrix = C_mat, found_triphones = found_triphones_part)
  
  NIKL_Ko_part <- rbind(NIKL_Ko[1:12], train_part[1:12])
  C_comb_part <- make_cue_matrix(data = NIKL_Ko_part, formula = ~ lexome1 + lexome2, grams = 3, wordform = "form")
  
  # S
  S_mat_part = target_C_new_part %*% comp$F
  
  rownames(S_mat_part) <- train_part$SR
  
  S_comb_part <- rbind(S_mat, S_mat_part)
  
  rownames(S_comb_part) <- rownames(C_comb_part$matrices$C)
  
  # comprehension
  comp_part <- learn_comprehension(cue_obj = C_comb_part, S = S_comb_part)
  
  # production
  prod_part <- learn_production(cue_obj = C_comb_part, S = S_comb_part, comp = comp_part)
  
  prod_acc_part <- accuracy_production(m = prod_part, data = NIKL_Ko_part, grams = 3, full_results = T, wordform = "form", return_triphone_supports = T)
  prod_acc_part$acc
  
  run[[1]] <- levels(as.factor(train$Exp_Subject_Id))[i]
  run[[2]] <- train_part
  run[[3]] <- C_mat_part
  run[[4]] <- found_triphones_part
  run[[5]] <- target_C_new_part
  run[[6]] <- NIKL_Ko_part
  run[[7]] <- C_comb_part
  run[[8]] <- S_mat_part
  run[[9]] <- S_comb_part
  run[[10]] <- comp_part
  run[[11]] <- prod_part
  run[[12]] <- prod_acc_part
  run[[13]] <- prod_acc_part$acc
  
  names(run) <- c("part", "train_part", "C_mat_part", "found_triphones_part", "target_C_new_part", "NIKL_Ko_part", "C_comb_part", 
                  "S_mat_part", "S_comb_part", "comp_part", "prod_part", "prod_acc_part", "prod_accuracy_part")
  
  train_list[[i]] <- run
}

names(train_list) <- levels(as.factor(train_sub$participant))

### predictions ----

# what we find is that there are predictions missing - this is due to the missing triphones in the corpus data C matrix

summary(train_list[["556014"]][["prod_acc_part"]][["forms"]][["preds"]] == "")
# Mode      FALSE    TRUE 
# logical     719      46

summary(train_list[["565631"]][["prod_acc_part"]][["forms"]][["preds"]] == "")
# Mode      FALSE    TRUE 
# logical     740      25

summary(train_list[["594939"]][["prod_acc_part"]][["forms"]][["preds"]] == "")
# Mode      FALSE    TRUE 
# logical     727      38
