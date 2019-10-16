##############################################################################
#               Create data frame for positions of word occurrence           #
#                               For LAKE method                              #
#                     (Taken help from online repositories)                  #
##############################################################################


# ------------- LIBRARIES
library(NLP)
library(tm)
library(openNLP)
library(foreign)
library(stringr)
library(tools)



# ------------- FUNCTIONS
SplitText <- function(Phrase, pattern) { 
  unlist(strsplit(Phrase,pattern))
}



# ------------- MAIN CODE

path = "/path/to/directory/" # path to the main directory
setwd(paste0(path,"data/"))  # set path to data directory where the text documents are available
my_stopwords <- readLines("/path/to/directory/stopwords.txt") # set the path to corresponding stopwords file.
f = paste0(path, "data/", "myDocument.txt") # the text document from where keywords are to be extracted
  
file_id <- as.character(file_path_sans_ext(f)) # returns filename sans extension
file_ids = unlist(strsplit(file_id,"/"))
file_id = file_ids[length(file_ids)]
  
# reads contents of the text document
  
###### Run below lines if reading non-english texts
#texts = read.delim(f, header = F, sep = "\t", quote = "", stringsAsFactors = FALSE)#, fileEncoding = "UTF-8") 
#texts <- as.character(texts)
#texts = gsub("\\?|।", ".", texts, perl = T) # convert sentence terminating marks to .
  
  
###### Run below line if reading english texts
texts = readChar(f, file.info(f)$size)
  
# Document pre-processing and text cleaning
doc<-c(texts)
corp <- Corpus(VectorSource(doc)) # creates the corpus
corp <- tm_map(corp, stripWhitespace)
corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, removeNumbers)
corp <- tm_map(corp, removeWords, my_stopwords) # uncomment to remove stopwords for english text

words <- SplitText(as.character(corp[[1]]), " ")
words = gsub("\\b[i|v|x|l|c|d|m]{1,3}\\b", "", words)
#words = gsub("[a-zA-Z0-9]*","",words) # uncomment only for non-english texts
#words = gsub("१६१३", "", words)# uncomment only for non-english texts. Replace the characters by any non-english chars that you want to remove.

# uncomment below block to remove stopwords from non-english texts
#################
#ind = which(words %in% my_stopwords)
#if(length(ind) > 0)
#  words = words[-ind]
#words = words[-which(words == "")]
#################

selected_words = unique(words) # candidates
# compute and extract positional infomation
N = length(words) + 1 # Document length
t = NULL
posi = list() # contains lists of positions of occurrences
tf = NULL # term frequency
i = 1
pos_w = NULL # contains lists of positions of occurrences of all words in the document

for (w in selected_words) {
  posw <- which(w==words) # extracts positions of occurrences for word w
  w_freq <- length(posw) # term frequency of w
  posw = c(posw,N) # appends N at the end of list for each w
  
  t = c(t, w) # vector of terms
  tf = c(tf, w_freq) # vector of tf
  posi[[i]] = posw # lists of positions of occurrences of word w_i
  i=i+1
}

pos_w = as.array(posi) # vector of lists of positions of occurrences for all words

term_freq = data.frame(t,tf,pos_w) # data frame containing words, their tf, and lists of positions of occurrences.
names(term_freq) = c("words","tf","positions")

if(!dir.exists(file.path(path, "freq/"))){ # creates directory to save positional information
  dir.create(file.path(path, "freq/"))  
}
  
c = paste0(path, "freq/")
sfile1 = paste(c, file_id, sep = "")
sfile1 = paste(sfile1,"Rda",sep=".")
  
saveRDS(term_freq,file = sfile1) # save data as Rdata file.