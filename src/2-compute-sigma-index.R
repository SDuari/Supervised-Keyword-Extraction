#############################################################################
#                               Sigma index                                 #
# (Creates a data frame of words with their respective sigma index values.) #
#############################################################################

# -------------LIBRARIES 
library(NLP)
library(tm)
library(openNLP)
library(foreign)
library(tools)


# -------------FUNCTIONS 

SplitText <- function(Phrase) { 
  unlist(strsplit(Phrase," "))
}

SigmaIndex <- function(df){
  words = df$words
  l = length(df$words)
  sigma = rep(0, each=l)
  
  for(j in 1:l){
    pos = df$positions[[j]]
    n = length(pos)-1
    if(n >= 3){
      N = as.numeric(pos[n+1]-1)
      avg = (N + 1)/(n + 1)
      sum = (pos[1] - avg)^2
      for(i in 1:n){
        sum = sum + ((pos[i+1] - pos[i]) - avg)^2
      }
      s = sqrt(sum/(n-1))
      sigma[j] = s/avg
    }
  }
  return(sigma)
}



# ---------- MAIN CODE
setwd("path/to/data/") # set working directory to the folder with your text documents

fileName <- "myDocument.txt" # the text document from where keywords are to be extracted

positions_file = "path/to/freq/myDocument.Rda" # the corresponding positions file created in step 1.
file_id = as.character(file_path_sans_ext(fileName))

df3 = readRDS(positions_file) # read contents of positional info file

######### Calculating sigma-index
sigma_index = SigmaIndex(df3)
sigma_index = sigma_index/max(sigma_index) #nrmalizing

######### Creating data frames
df_w <- data.frame(df3$words,sigma_index,file_id)
names(df_w) <- c("word", "sigma", "fileName")

df_sig <- df_w[order(df_w$sigma, decreasing = TRUE),] # sort in descending order of sigma-index values

# save data to csv file
write.table(df_sig,file = "path/to/freq/keywords_sigma.csv",sep=",",row.names=F,col.names=!file.exists("path/to/freq/keywords_sigma.csv"),append=T)
