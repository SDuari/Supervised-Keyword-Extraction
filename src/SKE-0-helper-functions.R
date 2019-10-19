###########################################################################
#       HELPER FUNCTION FOR SUPERVISED KEYWORD EXTRACTION ALGORITHM       #
###########################################################################

# split text on pattern
SplitText <- function(Phrase, pattern) { 
  unlist(strsplit(Phrase, pattern))
}

# compute sigma index
SigmaIndex <- function(df){
  words = df$words
  l = length(df$words)
  sigma = rep(0, each=l)
  
  for(j in 1:l){
    pos = df$positions[[j]]
    n = length(pos)-1
    if(n >= 2){
      N = as.numeric(pos[n+1])
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

# for i, returns 1/i
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


