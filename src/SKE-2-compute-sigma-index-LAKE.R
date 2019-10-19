#############################################################################
#                               Sigma index                                 #
# (Creates a data frame of words with their respective sigma index values.) #
#############################################################################

# ---------- Main Code

# create a directory, if not already available, for saving the positional info
if(!dir.exists(file.path(path, "freq/"))){
  dir.create(file.path(path, "freq/"))
}
save_path = paste0(path, "freq/") # setting the path where to save data

setwd(data_path) # set working directory to the folder where the input data is present
files = list.files(data_path, pattern = pat) # list files with given extension pattern 'pat' (".*.txt")

for (myFile in files) { # process all files present in data_path. Skip loop if running for single file
  file_id = as.character(file_path_sans_ext(myFile))
  
  positions_file = paste0(save_path, file_id,".Rda") # the corresponding positions file
  
  df3 = readRDS(positions_file) # read data from positions file
  
  ######### Calculating sigma-index
  sigma_index = SigmaIndex(df3) # function defined in SKE-0-helper-functions.R
  sigma_index = sigma_index/max(sigma_index) #normalizing the sigma-indexes, range (0, 1) both inclusive
    
  ######### Creating data frames of word, their respective sigma-index, and filename 
  df_w <- data.frame(df3$words,sigma_index,file_id)
  names(df_w) <- c("word", "sigma", "fileName")
  
  df_sig <- df_w[order(df_w$sigma, decreasing = TRUE),] # sort in descending order of sigma-index values
  
  # saving the data as .csv file for easier inspection. No row names, and col names are written only when there are no existing files
  write.table(df_sig, file = paste0(save_path, "/candidates_sigma-", file_id, ".csv"), sep = ",", row.names = FALSE, col.names = !file.exists(paste0(save_path, "/candidates_sigma-", file_id, ".csv")), append = FALSE)
}