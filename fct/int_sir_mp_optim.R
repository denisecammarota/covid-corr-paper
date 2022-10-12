# Function that does numerical integration of SEIR metapopulation
# model for certain parameters.
# Code developed by Denise Cammarota.
source('fct/sir_mp_optim.R')
# Actual function that interests us ------------------------------
int_sir_mp_optim <- function(pars, time, tseries_2, state, matA, n_days, n_provs, gamma){
  # calculating the ode solving values
  out <- deSolve::ode(y=state,func = sir_mp_optim,parms=pars,
                      times = time, A = matA, n_days= n_days, n_provs = n_provs, gamma = gamma)
  out <- out[,-1]
  out <- as.matrix(out)
  out <- matrix(out,ncol=ncol(out),dimnames = NULL)
  out <- t(out)
  out <- out[25:48,]
  print(dim(out-tseries_2))
  # computing difference for fitting purposes
  diff <- sum((out - tseries_2)**2)
}
