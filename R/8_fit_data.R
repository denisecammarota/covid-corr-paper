# Fits the model of SEIR metapopulation dependent on population and
# distance to the time series data of provinces
# Code developed by Denise Cammarota
library(deSolve)
library(minpack.lm)
source('fct/seir_mp.R')
source('fct/int_seir_mp.R')

# Reading data ------------------------------------------------------------
tseries_file <- 'outputs/cases_provs.csv' # time series data
tseries <- read.csv(tseries_file)
tseries_2 <- as.matrix(tseries)
tseries_2 <- matrix(tseries_2,ncol=ncol(tseries_2),dimnames = NULL)
n_provs <- dim(tseries)[1] # number of provinces
# Defining initial parameters --------------------------------------------

# sequence of times
n_days <- dim(tseries)[2]
times <- seq(1,n_days,1)

# model parameters
alpha <- 1./5 # alpha for connectivity matrix
beta <- 2./14 # beta factors for each province
gamma <- 1./14 # gamma inverse of recovery period

# parameters of the model
pars <- c(beta = beta, alpha = alpha, gamma = gamma)


# Sending for model fitting ----------------------------------------------
fitval=nls.lm(par=pars,fn=int_seir_mp)

