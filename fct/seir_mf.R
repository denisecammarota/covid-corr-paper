# This is code for a simple mean-field density-dependent SEIR model
# Code developed by Denise Cammarota

seir_mf <- function(time,state,pars){
  with(as.list(c(state,parameters)),{
    N <- S+E+I+R
    dS <- -(beta*S*I)/(N)
    dE <- (beta*S*I)/(N) - alpha*E
    dI <- alpha*E - gamma*I
    dR <- gamma*I
    return(list(c(dS,dE,dI,dR)))
  }
  )
}

