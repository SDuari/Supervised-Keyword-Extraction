##############################################################################
#               Create data frame for positions of word occurrence           #
#                               For LAKE method                              #
#                     (Taken help from online repositories)                  #
##############################################################################


# ------------ Main Code

# create a directory, if not already available, for saving the positional info
if(!dir.exists(file.path(path, "freq/"))){
  dir.create(file.path(path, "freq/"))
}
save_path = paste0(path, "freq/") # setting the path where to save data

setwd(data_path) # set working directory to the folder where the input data is present
files = list.files(data_path, pattern = pat) # list files with given extension pattern 'pat' (".*.txt")

for (f in files) { # process all files present in data_path. Skip loop if running for single file and set filename to f
  file_id <- as.character(file_path_sans_ext(f)) # extract file_id
  
  # reads contents of the text document
  texts = read.delim(f, header = F, sep = "\t", quote = "", stringsAsFactors = FALSE)#, fileEncoding = "UTF-8") # this line is recommended for non-english texts
  texts <- as.character(texts)
  
  #texts = readChar(f, file.info(f)$size) # this line can be used for english text. In such cases, uncomment this line and comment previous two lines
  
  texts = gsub("\\?|।", ".", texts, perl = T) # convert sentence terminating marks to '.'. Can omit for english.
  
  # Creating the corpus and pre-processing the text
  doc<-c(texts)
  corp <- Corpus(VectorSource(doc))
  corp <- tm_map(corp, stripWhitespace)               # remove whitespaces
  corp <- tm_map(corp, content_transformer(tolower))  # convert to lowercase
  corp <- tm_map(corp, removePunctuation)             # remove punctuations
  corp <- tm_map(corp, removeNumbers)                 # remove numbers
  corp <- tm_map(corp, removeWords, my_stopwords)     # remove stopwords using a prepared list
  
  words <- SplitText(as.character(corp[[1]]), " ")    # tokenizing the corpus content. Only one document is there in corpus, so we use corp[[1]].
  words = gsub("\\b[i|v|x|l|c|d|m]{1,3}\\b", "", words) # remove occurrences of roman numbers like ii, iv, x, etc.
  
  # This part is important for non-english texts. When we run the code for Indian languages,
  # the stopwords were not removed using the removeWords function above. So we did it here.
  ind = which(words %in% my_stopwords)
  if(length(ind) > 0)
    words = words[-ind]
  
  words = words[-which(words == "")]                  # remove "" values from the vector
  
  selected_words = unique(words) # words after pre-processing
  
  
  N = length(words) + 1 # need this number for step 2, i.e. sigma index computation
  
  t = NULL # terms
  posi = list() # list containing vectors of positions of occurrence of terms
  tf = NULL # term frequency of term t
  i = 1 # index for iteration
  pos_w = NULL # array, contains positions of occurrence for all terms
  
  for (w in selected_words) {
    posw <- which(w==words) # gets positions of occurrence
    w_freq <- length(posw) # gets frequency
    posw = c(posw,N) # appends N to the end of vector
    
    t = c(t, w) # appending words to the vector of terms
    tf = c(tf, w_freq) # appending frequency to vector of tf
    posi[[i]] = posw # i-th element contains the positions of occurrence of i-th term 
    i=i+1 
  }
  
  pos_w = as.array(posi) # converts list posi to array
  
  term_freq = data.frame(t,tf,pos_w) # creating data frame
  names(term_freq) = c("words","tf","positions") # assigning names to columns in data frame
  
  sfile1 = paste0(save_path, file_id,".Rda") # setting up file name by pasting appropriate path, file_id, and extension together
  
  saveRDS(term_freq,file = sfile1) # save the data as RData file (binary format, takes less space)
}
