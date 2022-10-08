# Function that does numerical integration of SEIR metapopulation
# model for certain parameters.
# Code developed by Denise Cammarota.

# Actual function that interests us ------------------------------
int_seir_mp_optim <- function(pars, time, tseries_2, state, matA, n_days, n_provs){
  # calculating the ode solving values
  out <- ode(y=state,func = seir_mp_optim,parms=pars,
             times = time)
  out <- out[,-1]
  out <- as.matrix(out)
  out <- matrix(out,ncol=ncol(out),dimnames = NULL)
  out <- t(out)
  out <- out[25:48,]
  print(dim(out))
  print(dim(tseries_2))
  # computing difference for fitting purposes
  diff <- out - tseries_2
}
