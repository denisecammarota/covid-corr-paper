# Fits the model of SEIR metapopulation dependent on population and
# distance to the time series data of provinces
# Code developed by Denise Cammarota

library(deSolve)
source('fct/seir_mp.R')

# Reading data ------------------------------------------------------------
tseries_file <- 'outputs/cases_provs.csv' # time series data
pop_file <- 'data/raw/provs_pop.csv' # provinces populations
condin_file <- 'data/raw/provs_condinit.csv' # provinces initial conditions

tseries <- read.csv(tseries_file)
pop <- read.csv(pop_file)
condin <- read.csv(condin_file)

# Computing connectivity matrix -------------------------------------------
pop <- as.matrix(pop[-1]) # remove first column of indexes
dist <- as.matrix(dist[,-1]) # remove first column of indexes
n_provs <- length(pop) # number of provinces


# Defining initial parameters --------------------------------------------

# sequence of times
n_days <- dim(tseries)[2]
times <- seq(1,2,1)

# model parameters
alpha <- 1./5 # alpha for connectivity matrix
beta <- rep(2./14,n_provs) # beta factors for each province
gamma <- 1./14 # gamma inverse of recovery period

# parameters of the model
pars <- c(alpha = alpha, beta = beta, gamma = gamma)

# Defining initial conditions ---------------------------------------------
S <- t(pop)
E <- matrix(0,nrow = 1, ncol = n_provs)
I <- t(as.matrix(condin[-1]))
R <- matrix(0,nrow = 1, ncol = n_provs)
state <- c(S = S, E = E, I = I, R = R)

# Integrating the model for these parameters -----------------------------
a <- seir_mp(times,state,pars)
output<-as.data.frame(ode(y=state,func = seir_mp,parms=pars,times = times))

