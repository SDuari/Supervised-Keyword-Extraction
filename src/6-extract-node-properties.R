#############################################################################
#                              Graph properties                             #
#                                                                           #
#   (Creates full list of vertices with their respective attribute values   #
#   for the graph properties.)                                              #
#                                                                           #
#############################################################################

# ------------- LIBRARIES

###source("https://bioconductor.org/biocLite.R")
###biocLite("graph")

library(NLP)
library(tm)
library(openNLP)
library(graph)
library(foreign)
library(igraph)
library(tools)
library(stringi)



# ------------- FUNCTIONS
SplitText <- function(Phrase, pattern) { 
  unlist(strsplit(Phrase, pattern))
}

invertNum <- function(x){
  return(as.numeric(1/x))
}


# Computes node weight using position of occurrences
getNodeWeight <- function(w){
  w_weight = 0
  pos_df = readRDS(paste0(pos_path,file_id,".Rda"))
  
  pos_w = subset(pos_df, pos_df$words == w)
  #pos_w = subset(pos_df, pos_df$words == w)
  
  if(length(pos_w$words) > 0){
    posi = pos_w$positions[[1]]
    posi = posi[-length(posi)]
    if(length(posi) > 0){
      w_weight = sum(invertNum(posi))
    }
  }
  return(w_weight)
}

# Computes PositionRank
PositionRank <- function(norm_g_mat, weight, nodes_num, a, threshold){
  nodes_rank <- matrix(1,nodes_num,2)
  iter <- 0                                  # iterations
  convergence_reached <- FALSE
  repeat {
    nodes_rank[,1] = a * t(norm_g_mat %*% nodes_rank[,2]) + (1-a) * weight
    iter <- iter+1
    if (iter >= 100) break
    #for (i in 1:nodes_num) {
    #if (abs(nodes_rank[i,1] - nodes_rank[i,2])<threshold) convergence_reached <- TRUE
    #}
    diff_rank = abs(nodes_rank[,1] - nodes_rank[,2])
    diff_rank = replace(diff_rank, is.na(diff_rank), 0)
    if(max(diff_rank) <= threshold) convergence_reached = TRUE
    if (convergence_reached) break
    nodes_rank[,2] <- nodes_rank[,1]
  }
  return(nodes_rank[,1])
}


# Function for range normalization
range_Normalize <- function(vector){
  min = min(vector)
  max = max(vector)
  if(max == min)
    norm_vals = rep(1, length(vector))
  else
    norm_vals = (vector-min)/(max-min)
  return(norm_vals)
}




# ------------- MAIN CODE

data_path = "/path/to/directory/data/"
graph_path = '/path/to/directory//graphs/'
fpat = ".*.txt"
keypat = ".*.key"
keyext = ".key"
fext = ".txt"
save_to_path = "/path/to/directory/Graph-properties/"
dataset = "myDocument"
wcore_csv = "/path/to/directory/WtCoreness/"
pos_path = "/path/to/directory/freq/"


setwd(graph_path)
files <-list.files(pattern = ".*.Rda")
####### Reading all graphs
for(fileName in files){ # skip loop if running for single file
  file_id=as.character(file_path_sans_ext(fileName))
  
  path = data_path
  id2 = paste(path, file_id, sep = "")
  fn = paste0(file_id, fext)
  file_uncontr = paste0(id2,keyext)
  
  wcore_f = paste0(wcore_csv, file_id, ".sortedranked.KC.txt")
  
  #### WTCORENESS
  t <- readChar(wcore_f, file.info(wcore_f)$size)
  t = unlist(strsplit(as.character(t),"\n"))
  t = t[-1]
  
  cw = sapply(strsplit(t, split=',', fixed=TRUE), function(x) (x[1]))
  cw = sapply(stri_sub(cw, 4, stri_length(cw)-3), function(x) (x[1]))
  
  wcore = sapply(strsplit(t, split=',', fixed=TRUE), function(x) (x[2]))
  wcore = as.numeric(wcore)
  wcore = range_Normalize(wcore)
  
  wcore_df = data.frame(cw, wcore)
  wcore_df = truss_df[order(wcore_df$cw, decreasing = FALSE),]
  names(wcore_df) = c("Word", "WCoreness")
  
  
  ############################################################################
  
  df1 = readRDS(fileName)   #### read .rda file, loads data frame
  gr = graph.adjacency(df1, mode = "undirected", weighted = TRUE)   
  
  
  ######### Calculating graph properties
  text_nodes <- get.vertex.attribute(gr)$name
  
  nodes_num <- vcount(gr)
  
  #Degree
  n_degree = strength(gr, mode = "all", loops = F)
  n_degree = range_Normalize(n_degree)
  
  #Weighted coreness
  nodes_coreness = wcore_df$WCoreness
  nodes_coreness = range_Normalize(nodes_coreness)
  
  #PageRank
  nodes_rank = page.rank(gr, algo = "prpack", directed = FALSE)$vector
  nodes_rank = range_Normalize(nodes_rank)
  
  #PositionRank
  weight = NULL
  for(myindex in 1:nodes_num){
    weight[myindex] = getNodeWeight(text_nodes[myindex])
  }
  weight = replace(weight, is.na(weight), 0)
  sum_weight = sum(weight)
  if(sum_weight > 0){
    weight = weight/sum_weight # normalized bias score for the nodes
  }else{
    weight = weight/1 # normalized bias score for the nodes
  }
  
  score = NULL
  g_adj_mat = get.adjacency(gr, attr = "weight", sparse = FALSE) # adjacency matrix
  norm_fact = rowSums(g_adj_mat)
  norm_fact = replace(norm_fact, is.na(norm_fact), 0)
  norm_fact = replace(norm_fact, norm_fact == 0, 1)
  norm_g_mat = t(t(g_adj_mat)/norm_fact) # normalized adjacency matrix
  
  score = PositionRank(norm_g_mat, weight, nodes_num, a = 0.15, thresh = 1e-4)
  score = range_Normalize(score)
  
  #Clustering coefficient
  cc = transitivity(gr, type = "local")
  cc[is.na(cc)] <- 0
  cc = range_Normalize(cc)
  
  #Eigenvector centrality
  ei = eigen_centrality(gr, directed = FALSE)
  ei = ei$vector
  ei = range_Normalize(ei)
  
  ######### Creating data frames
  df_prop <- data.frame(text_nodes, n_degree, nodes_rank, cc, ei, score)
  names(df_prop) <- c("Word","Degree","Rank", "CC", "Eigen", "PositionRank")
  
  df_prop <- df_prop[order(df_prop$Word, decreasing=FALSE),]
  
  df_withCore <- merge(df_prop, wcore_df, by.x = "Word", by.y = "Word")
  names(df_withCore) <- c("Word","Degree","Rank", "CC", "Eigen", "PositionRank", "Core")
  
  #Labels = SeeLabels(df_withTrussCore$Word, file_uncontr)
  Labels = rep("?", times = length(df_withCore$Word))
  
  words <- data.frame(df_withCore$Word, Labels, fn)
  names(words) <- c("Word", "Label", "Filename")
  words <- words[order(words$Word, decreasing=FALSE),]
  
  ranked_words = merge(df_withCore, words, by=c("Word"))
  names(ranked_words) = c("Word","Degree","Rank", "CC", "Eigen", "PositionRank", "Core", "Label", "Filename")
  
  write.table(ranked_words,file = paste0(save_to_path, dataset, "_node_properties.csv"),sep=",",row.names=F,col.names=!file.exists(paste0(save_to_path, dataset, "_node_properties.csv")),append=T)
}
