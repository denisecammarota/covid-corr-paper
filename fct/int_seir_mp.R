# Function that does numerical integration of SEIR metapopulation
# model for certain parameters.
# Code developed by Denise Cammarota.

# Actual function that interests us ------------------------------
int_seir_mp <- function(pars){
  # experimental time series loading
  tseries_file <- 'outputs/cases_provs.csv' # time series data
  tseries <- read.csv(tseries_file)
  tseries_2 <- as.matrix(tseries)
  tseries_2 <- matrix(tseries_2,ncol=ncol(tseries_2),dimnames = NULL)
  # calculating time
  n_days <- dim(tseries_2)[2]
  time <- seq(1,n_days,1)
  # loading initial conditions
  state <- read.csv("outputs/initial_conditions.csv")
  state <- as.numeric(state[,2])
  # calculating the ode solving values
  out <- ode(y=state,func = seir_mp,parms=pars,
                           times = time)
  out <- out[,-1]
  out <- as.matrix(out)
  out <- matrix(out,ncol=ncol(out),dimnames = NULL)
  out <- t(out)
  out <- out[25:48,]
  # computing difference for fitting purposes
  diff <- out - tseries_2
}
