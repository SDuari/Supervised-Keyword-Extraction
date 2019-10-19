############################################################################
#               Predicting keywords using pre-trained model                #
#                     (XGBOOST with SMOTE-balancing)                       #
############################################################################

# ------------- MAIN CODE

# create directory, if not exist,  to store prediction data
if(!dir.exists(file.path(path, "Predictions/"))){
  dir.create(file.path(path, "Predictions/"))
}

save_path = paste0(path, "Predictions/") # path to save predicted keywords


xgb2 = xgb.load(paste0(model_path, "xgboost2.model")) # load XGB model
model_name = "xgb2" # (please refer to paper on details about the pre-trained model)

setwd(data_path) # set working directory to the path where input text documents are located
files = list.files(data_path, pattern = ".*.txt")
for(f in files){ # iterate through all text docs
  file_id = as.character(file_path_sans_ext(f))
  
  # read the feature set
  # feature set format is: "Word", "Degree", "Rank", "CC", "Eigen", "PositionRank", "Core", "Label", "Filename"
  df_test_full = read.csv(paste0(path, "Graph-properties/", dataset, "_node_properties.csv"))
  
  # Predict using model
  df_test = subset(df_test_full, df_test_full$Filename == file_id) # feature set for individual files
  
  xTest = df_test[2:7] # attributes
  yTest = df_test$Label # label
  dtrain <- xgb.DMatrix(data = as.matrix(xTest), label = yTest)
  xgbpred <- predict (xgb2,dtrain) # predicting keywords using pre-trained model
  xgbpred <- ifelse (xgbpred > 0.5,1,0) # converts predicted labels to 0 (not a keyword) and 1 (keyword)
  
  class1 = xgbpred
  words_TP = df_test$Word[which(class1 == 1)] # positives, words with class label 1
  
  
  # save predicted keywords per document
  df_pred_keys = data.frame(words_TP)
  names(df_pred_keys) = c("Predicted_keywords")
  write.table(df_pred_keys, paste0(save_path, file_id, "-testResults.csv"), sep = ",", row.names = FALSE, col.names = !file.exists(paste0(save_path, file_id, "-testResults.csv")), append = FALSE)
}
