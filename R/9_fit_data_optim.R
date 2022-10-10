# Fits the model of SEIR metapopulation dependent on population and
# distance to the time series data of provinces with optim function
# Code developed by Denise Cammarota
library(deSolve)
library(optimParallel)
library(parallel)
source('fct/seir_mp_optim.R')
source('fct/int_seir_mp_optim.R')

# Reading data ----------------------------------------------------

## Time series data -----------------------------------------------
tseries_file <- 'outputs/cases_provs.csv' # time series data
tseries <- read.csv(tseries_file)
tseries_2 <- as.matrix(tseries)
tseries_2 <- matrix(tseries_2,ncol=ncol(tseries_2),dimnames = NULL)
# time series of 24 x 367 provinces x days
n_provs <- dim(tseries)[1] # number of provinces 24

## Initial conditions data ----------------------------------------
state <- read.csv("outputs/initial_conditions.csv")
state <- as.numeric(state[,2]) # 96 length vector

## Connectivity matrix data ---------------------------------------
file_A <- './outputs/mat_dist_pop.csv'
A <- as.matrix(read.csv(file_A))
A <- A[,-1] # 24 x 24 matrix

# Preparing for fit -----------------------------------------------
n_days <- dim(tseries_2)[2]
times <- seq(1,n_days,1)
alpha <- 1./5 # alpha for connectivity matrix
beta <- 2./14 # beta factors for each province
gamma <- 1./14 # gamma inverse of recovery period
g <- 0.001 # proportionality constant g
pars <- c(beta = beta, alpha = alpha, g = g)



cl <- makeCluster(detectCores()) # set the number of processor cores
clusterExport(cl=cl, c('seir_mp_optim', 'int_seir_mp_optim',
                       'times', 'tseries_2', 'state', 'A',
                       'n_days','n_provs'))
setDefaultCluster(cl=cl) # set 'cl' as default cluster

# Doing the fit ---------------------------------------------------
fitoptim <- optim(par = pars, fn = int_seir_mp_optim,
                  time = times, tseries_2 = tseries_2,
                  state = state, matA = A, n_days = n_days,
                  n_provs = n_provs, gamma = gamma)


