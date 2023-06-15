## Finding the 'best' participant for predictions
#  last update: 07/05/2023

## set working directory
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))
rm(current_path)


# data ----
tdata <- read.csv("data/data_test_predictions_w_perplexity.csv")
tdata$allinoneT <- as.factor(paste(tdata$simplify_delete_obstruent, tdata$simplify_delete_lateral, tdata$nasalize, tdata$lateralize, tdata$tensify))

wdata <- read.csv("data/test_with_right_answers.csv")
wdata$allinoneW <- as.factor(paste(wdata$C_deletion, wdata$L_deletion, wdata$Nasalization, wdata$Lateralization, wdata$Tensification))


# overall ----
tdata$simplify_delete_obstruent <- ifelse(is.na(tdata$simplify_delete_obstruent), 3, tdata$simplify_delete_obstruent)
wdata$C_deletion <- ifelse(is.na(wdata$C_deletion), 3, wdata$C_deletion)

tdata$simplify_delete_lateral <- ifelse(is.na(tdata$simplify_delete_lateral), 3, tdata$simplify_delete_lateral)
wdata$L_deletion <- ifelse(is.na(wdata$L_deletion), 3, wdata$L_deletion)

tdata$nasalize <- ifelse(is.na(tdata$nasalize), 3, tdata$nasalize)
wdata$Nasalization <- ifelse(is.na(wdata$Nasalization), 3, wdata$Nasalization)

tdata$lateralize <- ifelse(is.na(tdata$lateralize), 3, tdata$lateralize)
wdata$Lateralization <- ifelse(is.na(wdata$Lateralization), 3, wdata$Lateralization)

tdata$tensify <- ifelse(is.na(tdata$tensify), 3, tdata$tensify)
wdata$Tensification <- ifelse(is.na(wdata$Tensification), 3, wdata$Tensification)

summary(tdata$simplify_delete_obstruent == wdata$C_deletion)
# 304     944 
944 / (304 + 944)
# 0.7564103

summary(tdata$simplify_delete_lateral == wdata$L_deletion)
# 176    1072 
1072 / (176 + 1072)
# 0.8589744

summary(tdata$nasalize == wdata$Nasalization)
# 117    1131 
1131 / (117 + 1131)
# 0.90625

summary(tdata$lateralize == wdata$Lateralization)
# 418     830 
830 / (418 + 830)
# 0.6650641

summary(tdata$tensify == wdata$Tensification)
# 24    1224 
1124 / (24 + 1124)
# 0.9790941

(0.7564103 + 0.8589744 + 0.90625 + 0.6650641 + 0.9790941) / 5
# 0.8331586


# high ----

summary(tdata$simplify_delete_obstruent[tdata$frequency == "high"] == wdata$C_deletion[wdata$Frequency == "high"])
# 98     321
321 / (98 + 321)
# 0.7661098

summary(tdata$simplify_delete_lateral[tdata$frequency == "high"] == wdata$L_deletion[wdata$Frequency == "high"])
# 58     361 
361 / (58 + 361)
# 0.8615752

summary(tdata$nasalize[tdata$frequency == "high"] == wdata$Nasalization[wdata$Frequency == "high"])
# 38     381 
381 / (38 + 381)
# 0.9093079

summary(tdata$lateralize[tdata$frequency == "high"] == wdata$Lateralization[wdata$Frequency == "high"])
# 140     279 
279 / (140 + 279)
# 0.6658711

summary(tdata$tensify[tdata$frequency == "high"] == wdata$Tensification[wdata$Frequency == "high"])
# 10     409 
409 / (10 + 409)
# 0.9761337

(0.7661098 + 0.8615752 + 0.9093079 + 0.6658711 + 0.9761337) / 5
# 0.8357995


# low ----

summary(tdata$simplify_delete_obstruent[tdata$frequency == "low"] == wdata$C_deletion[wdata$Frequency == "low"])
# 100     313 
313 / (100 + 313)
# 0.7578692

summary(tdata$simplify_delete_lateral[tdata$frequency == "low"] == wdata$L_deletion[wdata$Frequency == "low"])
# 53     360 
360 / (53 + 360)
# 0.8716707

summary(tdata$nasalize[tdata$frequency == "low"] == wdata$Nasalization[wdata$Frequency == "low"])
# 36     377 
377 / (36 + 377)
# 0.9128329

summary(tdata$lateralize[tdata$frequency == "low"] == wdata$Lateralization[wdata$Frequency == "low"])
# 139     274 
274 / (139 + 274)
# 0.6634383

summary(tdata$tensify[tdata$frequency == "low"] == wdata$Tensification[wdata$Frequency == "low"])
# 10     403 
403 / (10 + 403)
# 0.9757869

(0.7578692 + 0.8716707 + 0.9093079 + 0.6634383 + 0.9757869) / 5
# 0.8356146


# nonce ----

summary(tdata$simplify_delete_obstruent[tdata$frequency == "nonce"] == wdata$C_deletion[wdata$Frequency == "nonce"])
# 106     310 
310 / (106 + 310)
# 0.7451923

summary(tdata$simplify_delete_lateral[tdata$frequency == "nonce"] == wdata$L_deletion[wdata$Frequency == "nonce"])
# 65     351 
351 / (65 + 351)
# 0.84375

summary(tdata$nasalize[tdata$frequency == "nonce"] == wdata$Nasalization[wdata$Frequency == "nonce"])
# 43     373 
373 / (43 + 373)
# 0.8966346

summary(tdata$lateralize[tdata$frequency == "nonce"] == wdata$Lateralization[wdata$Frequency == "nonce"])
# 139     277 
277 / (139 + 277)
# 0.6658654

summary(tdata$tensify[tdata$frequency == "nonce"] == wdata$Tensification[wdata$Frequency == "nonce"])
# 4     412 
412 / (4 + 412)
# 0.9903846

(0.7451923 + 0.84375 + 0.8966346 + 0.6658654 + 0.9903846) / 5
# 0.8283654
