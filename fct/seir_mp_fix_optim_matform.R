# This is code for a metapopulation density-dependent SEIR model
# with a connectivity matrix calculated elsewhere
# Code developed by Denise Cammarota

seir_mp_fix_optim_matform <- function(time, state, pars, A, n_days, n_provs, gamma){
  # loading the connectivity matrix
  with(as.list(c(state,pars)),{
    # separating S E I and R
    S <- matrix(state[1:n_provs], ncol = 1)
    E <- matrix(state[(n_provs+1):(2*n_provs)], ncol = 1)
    I <- matrix(state[((2*n_provs)+1):(3*n_provs)], ncol = 1)
    R <- matrix(state[((3*n_provs)+1):(4*n_provs)], ncol = 1)
    # population of each province
    N <- S + E + I + R
    # calculating derivatives
    dS = -(beta*S*I)/(N) + g*A%*%S
    dE = (beta*S*I)/(N) - alpha*E + g*A%*%E
    dI = alpha*E - gamma*I + g*A%*%I
    dR = gamma*I + g*A%*%R
    return(list(c(dS,dE,dI,dR)))
  }
  )
}
