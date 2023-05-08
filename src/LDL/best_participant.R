## Finding the 'best' participant for predictions
#  last update: 07/05/2023

## set working directory
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))
rm(current_path)

# packages
library(visreg)

# data ----

load("C:/Users/Adomo/ownCloud/SIGMORPHON-2023-Task2/data/part_data.RData")

load("../data/train.RData")
load("../data/part_dev.RData")

data_td <- rbind(train, part_dev)

part_data <- part_data[part_data$part %in% as.factor(data_td$Exp_Subject_Id), ]

# low ----

yes_ratios_low <- read.csv("../data/yes_ratios_low.csv", header = T)[2:17]
colnames(yes_ratios_low) <- gsub("X", "", colnames(yes_ratios_low))

data_td_low <- subset(data_td, Frequency == "low")

low_bio_preds <- list()

for(i in 1:ncol(yes_ratios_low)){
  
  run_list <- list()
  
  parti <- colnames(yes_ratios_low)[i]
  
  predictions_low_run <- yes_ratios_low[,i]
  predictions_low_run <- predictions_low_run[-i]
  
  langpref <- ifelse(part_data$LanguagePreference == part_data$LanguagePreference[i], "match", "mismatch")
  langpref <- langpref[-i]
  
  agespeak <- ifelse(part_data$AgeStartedSpeaking == part_data$AgeStartedSpeaking[i], "match", "mismatch")
  agespeak <- agespeak[-i]
  
  part <- part_data$part
  part <- part[-i]
  
  means <- tapply(data_td$knowledge, data_td$Exp_Subject_Id, mean)
  mean_knowledge <- means[-i]
  
  df_run <- data.frame(cbind(predictions_low_run, langpref, agespeak, part, mean_knowledge))
  
  df_run$predictions_low_run <- as.numeric(df_run$predictions_low_run)
  df_run$langpref <- as.factor(df_run$langpref)
  df_run$agespeak <- as.factor(df_run$agespeak)
  df_run$part <- as.factor(df_run$part)
  df_run$mean_knowledge <- as.numeric(df_run$mean_knowledge)
  
  run_list[[1]] <-df_run
  
  if(nlevels(df_run$langpref) >= 2 & nlevels(df_run$agespeak) >= 2){
    
    mdl <- lm(predictions_low_run ~ langpref + agespeak + mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }else if(nlevels(df_run$langpref) >= 2 & nlevels(df_run$agespeak) < 2){
    
    mdl <- lm(predictions_low_run ~ langpref + mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }else if(nlevels(df_run$langpref) < 2 & nlevels(df_run$agespeak) >= 2){
    
    mdl <- lm(predictions_low_run ~ agespeak + mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }else if(nlevels(df_run$langpref) < 2 & nlevels(df_run$agespeak) < 2){
    
    mdl <- lm(predictions_low_run ~ mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }
  
  run_list[[5]] <- parti
  
  low_bio_preds[[i]] <- run_list
  
}

low_bio_preds[[1]][[3]]
low_bio_preds[[2]][[3]]
low_bio_preds[[3]][[3]]
low_bio_preds[[4]][[3]]
low_bio_preds[[5]][[3]]
low_bio_preds[[6]][[3]]
low_bio_preds[[7]][[3]] # langpref * --- only 2 participants with langpref = 3

low_7_data <- low_bio_preds[[7]][[1]]
low_7_mdl <- lm(predictions_low_run ~ langpref + mean_knowledge, low_7_data)
visreg::visreg(low_7_mdl)

low_bio_preds[[8]][[3]]
low_bio_preds[[9]][[3]]
low_bio_preds[[10]][[3]]
low_bio_preds[[11]][[3]]
low_bio_preds[[12]][[3]]
low_bio_preds[[13]][[3]]
low_bio_preds[[14]][[3]]
low_bio_preds[[15]][[3]]
low_bio_preds[[16]][[3]]


# high ----

yes_ratios_high <- read.csv("../data/yes_ratios_high.csv", header = T)[2:17]
colnames(yes_ratios_high) <- gsub("X", "", colnames(yes_ratios_high))

data_td_high <- subset(data_td, Frequency == "high")

high_bio_preds <- list()

for(i in 1:ncol(yes_ratios_high)){
  
  run_list <- list()
  
  parti <- colnames(yes_ratios_high)[i]
  
  predictions_high_run <- yes_ratios_high[,i]
  predictions_high_run <- predictions_high_run[-i]
  
  langpref <- ifelse(part_data$LanguagePreference == part_data$LanguagePreference[i], "match", "mismatch")
  langpref <- langpref[-i]
  
  agespeak <- ifelse(part_data$AgeStartedSpeaking == part_data$AgeStartedSpeaking[i], "match", "mismatch")
  agespeak <- agespeak[-i]
  
  part <- part_data$part
  part <- part[-i]
  
  means <- tapply(data_td$knowledge, data_td$Exp_Subject_Id, mean)
  mean_knowledge <- means[-i]
  
  df_run <- data.frame(cbind(predictions_high_run, langpref, agespeak, part, mean_knowledge))
  
  df_run$predictions_high_run <- as.numeric(df_run$predictions_high_run)
  df_run$langpref <- as.factor(df_run$langpref)
  df_run$agespeak <- as.factor(df_run$agespeak)
  df_run$part <- as.factor(df_run$part)
  df_run$mean_knowledge <- as.numeric(df_run$mean_knowledge)
  
  run_list[[1]] <-df_run
  
  if(nlevels(df_run$langpref) >= 2 & nlevels(df_run$agespeak) >= 2){
    
    mdl <- lm(predictions_high_run ~ langpref + agespeak + mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }else if(nlevels(df_run$langpref) >= 2 & nlevels(df_run$agespeak) < 2){
    
    mdl <- lm(predictions_high_run ~ langpref + mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }else if(nlevels(df_run$langpref) < 2 & nlevels(df_run$agespeak) >= 2){
    
    mdl <- lm(predictions_high_run ~ agespeak + mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }else if(nlevels(df_run$langpref) < 2 & nlevels(df_run$agespeak) < 2){
    
    mdl <- lm(predictions_high_run ~ mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }
  
  run_list[[5]] <- parti
  
  high_bio_preds[[i]] <- run_list
  
}

high_bio_preds[[1]][[3]]
high_bio_preds[[2]][[3]]
high_bio_preds[[3]][[3]]
high_bio_preds[[4]][[3]]
high_bio_preds[[5]][[3]]
high_bio_preds[[6]][[3]]
high_bio_preds[[7]][[3]] # langpref * --- only 2 participants with langpref = 3

high_7_data <- high_bio_preds[[7]][[1]]
high_7_mdl <- lm(predictions_high_run ~ langpref + mean_knowledge, high_7_data)
visreg::visreg(high_7_mdl)

high_bio_preds[[8]][[3]]
high_bio_preds[[9]][[3]]
high_bio_preds[[10]][[3]]
high_bio_preds[[11]][[3]] # langpref *** --- only 2 participants with langpref = 3

high_11_data <- high_bio_preds[[11]][[1]]
high_11_mdl <- lm(predictions_high_run ~ langpref + mean_knowledge, high_11_data)
visreg::visreg(high_11_mdl)

high_bio_preds[[12]][[3]] # langpref * --- 7 - as many others, too

high_12_data <- high_bio_preds[[12]][[1]]
high_12_mdl <- lm(predictions_high_run ~ langpref + mean_knowledge, high_12_data)
visreg::visreg(high_12_mdl)

high_bio_preds[[13]][[3]] # mean_knowledge * --- no idea

high_13_data <- high_bio_preds[[13]][[1]]
high_13_mdl <- lm(predictions_high_run ~ langpref + mean_knowledge, high_13_data)
visreg::visreg(high_13_mdl)

high_bio_preds[[14]][[3]]
high_bio_preds[[15]][[3]]
high_bio_preds[[16]][[3]]


# nonce ----

yes_ratios_nonce <- read.csv("../data/yes_ratios_nonce.csv", header = T)[2:17]
colnames(yes_ratios_nonce) <- gsub("X", "", colnames(yes_ratios_nonce))

data_td_nonce <- subset(data_td, Frequency == "nonce")

nonce_bio_preds <- list()

for(i in 1:ncol(yes_ratios_nonce)){
  
  run_list <- list()
  
  parti <- colnames(yes_ratios_nonce)[i]
  
  predictions_nonce_run <- yes_ratios_nonce[,i]
  predictions_nonce_run <- predictions_nonce_run[-i]
  
  langpref <- ifelse(part_data$LanguagePreference == part_data$LanguagePreference[i], "match", "mismatch")
  langpref <- langpref[-i]
  
  agespeak <- ifelse(part_data$AgeStartedSpeaking == part_data$AgeStartedSpeaking[i], "match", "mismatch")
  agespeak <- agespeak[-i]
  
  part <- part_data$part
  part <- part[-i]
  
  means <- tapply(data_td$knowledge, data_td$Exp_Subject_Id, mean)
  mean_knowledge <- means[-i]
  
  df_run <- data.frame(cbind(predictions_nonce_run, langpref, agespeak, part, mean_knowledge))
  
  df_run$predictions_nonce_run <- as.numeric(df_run$predictions_nonce_run)
  df_run$langpref <- as.factor(df_run$langpref)
  df_run$agespeak <- as.factor(df_run$agespeak)
  df_run$part <- as.factor(df_run$part)
  df_run$mean_knowledge <- as.numeric(df_run$mean_knowledge)
  
  run_list[[1]] <-df_run
  
  if(nlevels(df_run$langpref) >= 2 & nlevels(df_run$agespeak) >= 2){
    
    mdl <- lm(predictions_nonce_run ~ langpref + agespeak + mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }else if(nlevels(df_run$langpref) >= 2 & nlevels(df_run$agespeak) < 2){
    
    mdl <- lm(predictions_nonce_run ~ langpref + mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }else if(nlevels(df_run$langpref) < 2 & nlevels(df_run$agespeak) >= 2){
    
    mdl <- lm(predictions_nonce_run ~ agespeak + mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }else if(nlevels(df_run$langpref) < 2 & nlevels(df_run$agespeak) < 2){
    
    mdl <- lm(predictions_nonce_run ~ mean_knowledge, df_run)
    
    mdl_a <- anova(mdl)
    mdl_s <- summary(mdl)
    
    run_list[[2]] <- mdl
    run_list[[3]] <- mdl_a
    run_list[[4]] <- mdl_s
    
  }
  
  run_list[[5]] <- parti
  
  nonce_bio_preds[[i]] <- run_list
  
}

nonce_bio_preds[[1]][[3]]
nonce_bio_preds[[2]][[3]]
nonce_bio_preds[[3]][[3]]
nonce_bio_preds[[4]][[3]]
nonce_bio_preds[[5]][[3]]
nonce_bio_preds[[6]][[3]]
nonce_bio_preds[[7]][[3]] 
nonce_bio_preds[[8]][[3]]
nonce_bio_preds[[9]][[3]]
nonce_bio_preds[[10]][[3]]
nonce_bio_preds[[11]][[3]] 
nonce_bio_preds[[12]][[3]] 
nonce_bio_preds[[13]][[3]] 
nonce_bio_preds[[14]][[3]]
nonce_bio_preds[[15]][[3]]
nonce_bio_preds[[16]][[3]]