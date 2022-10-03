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

n_provs <- dim(tseries)[1] # number of provinces

# Defining initial parameters --------------------------------------------

# sequence of times
n_days <- dim(tseries)[2]
T <- seq(1,n_days,1)

# model parameters
alpha <- 1./5 # alpha for connectivity matrix
beta <- rep(2./14,n_provs) # beta factors for each province
gamma <- 1./14 # gamma inverse of recovery period

# parameters of the model
pars <- c(beta = beta, alpha = alpha, gamma = gamma)


# Sending for model fitting ----------------------------------------------
#int_seir_mp(time = times,state = state,pars = pars)

# residuals calculation
fcn <- function(p, T, N, fcall){
  (N - do.call("fcall", c(list(T = T), as.list(p))))
}

# fitting
out <- nls.lm(par = pars, fn = fcn,
              fcall = int_seir_mp,
              T = T, N = tseries, control = nls.lm.control(nprint=1))

