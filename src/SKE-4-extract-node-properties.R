#############################################################################
#                              Graph properties                             #
#                                                                           #
#   (Creates full list of vertices with their respective attribute values   #
#   for the graph properties.)                                              #
#                                                                           #
#############################################################################

# ------------- MAIN CODE

#create directory, if doesn't exist, to save properties
if(!dir.exists(file.path(path, "Graph-properties/"))){
  dir.create(file.path(path, "Graph-properties/"))
}
save_path = paste0(path, "Graph-properties/")

setwd(graph_path) # set working directory to the path where the saved graphs are located.
files <-list.files(pattern = ".*.Rda")
####### Reading all graphs
for(fileName in files){ # skip loop if running for single file
  file_id=as.character(file_path_sans_ext(fileName))
  
  ############################################################################
  
  df1 = readRDS(fileName)   #### read .rda file, loads data frame
  gr = graph.adjacency(df1, mode = "undirected", weighted = TRUE)   # create graph from adjacency matrix
  
  
  ######### Calculating graph properties
  text_nodes <- get.vertex.attribute(gr)$name # getting node names. These are candidate keywords
  
  nodes_num <- vcount(gr) # number of nodes
  
  # Node Strength, i.e., Weighted Degree
  n_degree = strength(gr, mode = "all", loops = F)
  n_degree = range_Normalize(n_degree)
  
  #Coreness
  nodes_coreness = as.integer(coreness(gr, mode = "all"))
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
  
  score = PositionRank(norm_g_mat, weight, nodes_num, a = 0.15, thresh = 1e-4) # function is defined in SKE-0-helper-functions.R
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
  df_prop <- data.frame(text_nodes, n_degree, nodes_rank, cc, ei, score, nodes_coreness)
  names(df_prop) <- c("Word","Degree","Rank", "CC", "Eigen", "PositionRank", "Core")
  
  df_prop <- df_prop[order(df_prop$Word, decreasing=FALSE),]
  
  Labels = rep("?", times = length(df_prop$Word)) # set labels to unknown, i.e., '?'
  
  words <- data.frame(df_prop$Word, Labels, file_id)
  names(words) <- c("Word", "Label", "Filename")
  words <- words[order(words$Word, decreasing=FALSE),]
  
  ranked_words = merge(df_prop, words, by=c("Word"))
  names(ranked_words) = c("Word","Degree","Rank", "CC", "Eigen", "PositionRank", "Core", "Label", "Filename")
  
  # save the data as .csv file
  write.table(ranked_words,file = paste0(save_path, dataset, "_node_properties.csv"),sep=",",row.names=F,col.names=!file.exists(paste0(save_path, dataset, "_node_properties.csv")),append=T)
}
