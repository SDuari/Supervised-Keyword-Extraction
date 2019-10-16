############################################################################
#               Predicting keywords using pre-trained model                #
#                     (XGBOOST with SMOTE-balancing)                       #
############################################################################

# ------------- LIBRARIES
library(caret)
library(ROCR)
library(e1071)
library(RWeka)
library(xgboost)


# ------------- MAIN CODE
path = "/path/to/directory/" # path to the main directory
paper_id = "myDocument" # set paper_id as corresponding filename

xgb2 = xgb.load("/path/to/directory/model/xgboost2.model")
model_name = "xgb2"

df_test = read.csv(paste0("/path/to/directory/Graph-properties/", paper_id, "_node_properties.csv"))
dataset = paper_id

# Predict using model
df_test_sub = df_test
f = paste0(path, "data/", "myDocument.txt") # path to the text document
df_test = subset(df_test_sub, df_test_sub$Filename == f) # testset for individual files

xTest = df_test[2:7] # attributes
yTest = df_test$Label
dtrain <- xgb.DMatrix(data = as.matrix(xTest), label = yTest)
xgbpred <- predict (xgb2,dtrain)
xgbpred <- ifelse (xgbpred > 0.5,1,0)

class1 = xgbpred
words_TP = df_test$Word[which(class1 == 1)] # true positives, words with class label 1

if(!dir.exists(file.path(path, "Predictions/"))){
  dir.create(file.path(path, "Predictions/"))
  save_path = "/path/to/directory/Predictions/" # path to save predicted keywords
}

# save predicted keywords per document
df_pred_keys = data.frame(words_TP)
names(df_pred_keys) = c("Predicted_keywords")
write.table(df_pred_keys, paste0(save_path, "/", paper_id, "-testResults.csv"), sep = ",", row.names = FALSE, col.names = !file.exists(paste0(save_path, "/", paper_id, "-testResults.csv")), append = FALSE)
