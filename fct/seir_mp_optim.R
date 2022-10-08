# This is code for a metapopulation density-dependent SEIR model
# with a connectivity matrix calculated elsewhere
# Code developed by Denise Cammarota

seir_mp_optim <- function(time, state, pars, A, n_days, n_provs){
  # loading the connectivity matrix
  with(as.list(c(state,pars)),{
    # defining important parameters
    #beta <- pars[1:n_provs]
    # separating S E I and R
    S <- matrix(state[1:n_provs], nrow = 1)
    E <- matrix(state[(n_provs+1):(2*n_provs)], nrow = 1)
    I <- matrix(state[((2*n_provs)+1):(3*n_provs)], nrow = 1)
    R <- matrix(state[((3*n_provs)+1):(4*n_provs)], nrow = 1)
    # population of each province
    N <- S + E + I + R
    # auxiliary quantities
    aux_S <- matrix(0.0,1,n_provs)
    aux_E <- matrix(0.0,1,n_provs)
    aux_I <- matrix(0.0,1,n_provs)
    aux_R <- matrix(0.0,1,n_provs)
    # calculating the diffusion term
    for(i in seq(1,n_provs,1)){
      aux_S_2 <- 0.0
      aux_E_2 <- 0.0
      aux_I_2 <- 0.0
      aux_R_2 <- 0.0
      for(j in seq(1,n_provs,1)){
        aux_S_2 <- aux_S_2 + A[i,j]*S[j]*(N[i]/N[j])
        aux_E_2 <- aux_E_2 + A[i,j]*E[j]*(N[i]/N[j])
        aux_I_2 <- aux_I_2 + A[i,j]*I[j]*(N[i]/N[j])
        aux_R_2 <- aux_R_2 + A[i,j]*R[j]*(N[i]/N[j])
      }
      aux_S[i] <- aux_S_2
      aux_E[i] <- aux_E_2
      aux_I[i] <- aux_I_2
      aux_R[i] <- aux_R_2
    }
    # calculating derivatives
    dS = -(beta*S*I)/(N) + aux_S
    dE = (beta*S*I)/(N) - alpha*E + aux_E
    dI = alpha*E - gamma*I + aux_I
    dR = gamma*I + aux_R
    return(list(c(dS,dE,dI,dR)))
  }
  )
}
