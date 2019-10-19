###########################################################
#                                                         #
#         Create Context-Aware Graphs for LAKE            #
#                                                         #
###########################################################

# -------------- MAIN CODE

# create directory, if doesn't exist already, to save graphs
if(!dir.exists(file.path(path, "graphs/"))){
  dir.create(file.path(path, "graphs/"))
}

save_path = paste0(path, "graphs/") # path to save graphs

#Sys.setlocale("LC_ALL", 'en_US.UTF-8') # uncomment if non-english texts are not read correctly

setwd(data_path) # set working directory to the folder where the input text data is present
files = list.files(data_path, pattern = pat)
for (f in files) { # iterating over all text files. Skip loop if running for single file
  file_id = as.character(file_path_sans_ext(f))
  
  # reads contents of the text document
  texts = readChar(f, file.info(f)$size)
  texts = gsub("[“”‘’]", "", texts)
  
  # Split the text into sentences
  if(eng == TRUE){
    sent1 = convert_text_to_sentences(texts)
  }else{
    sent1 = convert_text_to_sentences1(texts)
  }
  
  sent = NULL
  # join two consecutive sentences as one, e.g. - s1s2  s2s3  s3s4 ...
  if(length(sent1) < 2){
    sent = as.String(sent1)
  }else{
    for(i in 1:(length(sent1)-1)){
      s = paste(sent1[i], ". ", sent1[i+1])
      sent = c(sent, as.String(s))
    }
  }
  doc<-c(sent)
  
  
  # create corpus and pre-process text
  corp <- Corpus(VectorSource(doc))
  corp <- tm_map(corp, stripWhitespace)
  corp <- tm_map(corp, content_transformer(tolower))
  corp <- tm_map(corp, removePunctuation)
  corp <- tm_map(corp, removeNumbers)
  corp <- tm_map(corp, removeWords, my_stopwords)
  
  df_sigma = read.csv(paste0(path, "freq/candidates_sigma-", file_id, ".csv")) # read sigma-index file
  words = df_sigma$word
  if(apply_sigma == TRUE){ # apply when doc is long. Don't apply for short text with less that 100-150 words as it will not work properly.
    thres = ceiling(length(words) * .33) # set threshold to top 33% words
  }else{
    thres = length(words) # no threshold
  }
  selected_words = words[1:thres] # candidate keywords
  
  # create document-term matrix (DTM)
  dtm = DocumentTermMatrix(corp, control =  list(wordLengths=c(0, Inf)))
  dtm = dtm[, colnames(dtm) %in% selected_words] # keep only candidate keywords as terms in DTM
  dtm = as.matrix(dtm) # convert DTM to matrix
  dtm[dtm > 1] <- 1 # binary incidence matrix, so no tf
  ttm = t(dtm) %*% dtm # create term-term matrix
  diag(ttm) <- 0 # set diagonal to 0 as we do not consider link between the same word.
  
  # Following code is a sample to create graphs from ttm
  # g = graph.adjacency(ttm, mode = "undirected", weighted = TRUE) # create graph from ttm
  # g<- simplify(g, remove.multiple = T, remove.loops = T) # make g a simple graph without self loops and multiple edges
  # g_data = as_data_frame(g, what = "edges")
  
  # saving the data
  sfile1 = paste0(save_path, file_id, ".Rda")
  saveRDS(ttm, file = sfile1)
}
