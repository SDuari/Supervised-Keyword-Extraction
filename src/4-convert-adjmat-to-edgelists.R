#################################################################
#             Create edgelist from adjacency matrix             #
#################################################################

library(foreign)
library(igraph)
library(tools)

path = "path/to/directory/"
setwd(path) # set working directory to the folder

f = paste0(path, "graphs/", "myDocument.Rda") # graph file for the text document
file_id = as.character(file_path_sans_ext(f))

df1 = readRDS(f)   #### read .rda file, loads data frame
gr = graph.adjacency(df1, mode = "undirected", weighted = TRUE)  # create graph from stored adjacency matrix 
edgel = get.data.frame(gr, "edges") # create edgelist

if(!dir.exists(file.path(path, "edgelists/"))){ # creates directory to save edgelists
  dir.create(file.path(path, "edgelists/"))  
}

f_n = paste0(path, "edgelists/", file_id, ".csv") # output file

#save edgelist, contents separated by \t
write.table(edgel, file = f_n, sep="\t", row.names=F, col.names = F)