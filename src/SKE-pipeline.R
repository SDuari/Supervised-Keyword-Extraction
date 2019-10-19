# ------------- LIBRARIES

# for text processing
library(NLP)
library(tm)
library(openNLP)

# for extracting node properties from graphs
library(igraph)

# for applying model to predict keywords
library(xgboost)

# miscellaneous utility packages 
library(tools)


# ------------- SOURCE HELPER FUNCTIONS
source("/path/to/R/scripts/SKE-0-helper-functions.R")


# ------------- SETTING UP SOME GLOBAL VARIABLES

dataset = "myDataset" # The name of dataset, e.g., Hulth2003
path = "/path/to/main/folder/" # path to main folder where all subsequent results are stored
model_path = "/path/to/preTrained/Models/" # path where the models are located

# user can compile customized stopwords list and set the appropriate filename here
my_stopwords <- readLines("/path/to/stopwords/file/stopwords.txt") # reads the list of stopwords. Update the path where stopwords list is located

pat = ".*.txt" # .txt is the extension of input documents. Replace, if necessary, with correct extension
stem = FALSE # whether to apply stemming. FALSE for Supervised KE algo.
eng = TRUE # Is this English language text? Set FALSE for non-english texts.
apply_sigma = FALSE # Set to FALSE if text length is less that 100-150 words 

# ------------- SETTING UP PATHS TO STORE AND LOAD DATA
data_path = paste0(path, "data/") # path to text files
graph_path = paste0(path, "graphs/") # path to graphs
pos_path = paste0(path, "freq/") # path to positional info


print("Computing positional info...")
source("/path/to/R/scripts/SKE-1-create-position-info-LAKE.R")

print("Computing sigma index...")
source("/path/to/R/scripts/SKE-2-compute-sigma-index-LAKE.R")

print("Creating graphs...")
source("/path/to/R/scripts/SKE-3-Create-graph-LAKE.R")

print("Extracting node properties...")
source("/path/to/R/scripts/SKE-4-extract-node-properties.R")

print("Predicting keywords...")
source("/path/to/R/scripts/SKE-5-XGB-predict-keywords.R")

