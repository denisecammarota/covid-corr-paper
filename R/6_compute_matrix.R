# Reads data, computes and saves connectivity matrix depending on
# distance and population (the best fitted one)
# Code developed by Denise Cammarota

# Reading data ------------------------------------------------------------
dist_file <- 'data/raw/provs_dist.csv' # provinces distances
pop_file <- 'data/raw/provs_pop.csv' # provinces populations

dist <- read.csv(dist_file)
pop <- read.csv(pop_file)

# Computing connectivity matrix -------------------------------------------
pop <- as.matrix(pop[-1]) # remove first column of indexes
dist <- as.matrix(dist[,-1]) # remove first column of indexes
n_provs <- length(pop) # number of provinces
total_pop <- as.numeric(colSums(pop)) # total argentinian population
mat_A <- matrix(0, n_provs, n_provs) # matrix of connectivity

# cycling and computing each element
for(i in seq(1, n_provs, 1)){
  for(j in seq(1, n_provs, 1)){
    mat_A[i,j] <- 1
  }
}

# computing correct diagonal elements
for(i in seq(1, n_provs, 1)){
  mat_A[i,i] <- 0
  mat_A[i,i] <- -sum(mat_A[,i])
}

# dividing by population to create new matrix
for(i in seq(1, n_provs, 1)){
  for(j in seq(1, n_provs, 1)){
    mat_A[i,j] <- mat_A[i,j]*(pop[i]/pop[j])
  }
}

# Saving the corresponding matrix --------------------------------------
write.csv(mat_A,'outputs/mat_neutral_matform.csv')

