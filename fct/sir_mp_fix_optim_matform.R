# This is code for a metapopulation density-dependent SEIR model
# with a connectivity matrix calculated elsewhere
# Code developed by Denise Cammarota

sir_mp_fix_optim_matform <- function(time, state, pars, A, n_days, n_provs, gamma){
  # loading the connectivity matrix
  with(as.list(c(state,pars)),{
    # separating S E I and R
    S <- matrix(state[1:n_provs], ncol = 1)
    I <- matrix(state[((n_provs)+1):(2*n_provs)], ncol = 1)
    R <- matrix(state[((2*n_provs)+1):(3*n_provs)], ncol = 1)
    # population of each province
    N <- S + I + R
    # calculating derivatives
    dS = -(beta*S*I)/(N) + g*A%*%S
    dI = (beta*S*I)/(N) - gamma*I + g*A%*%I
    dR = gamma*I + g*A%*%R
    return(list(c(dS,dI,dR)))
  }
  )
}
