# Function that does numerical integration of SEIR metapopulation
# model for certain parameters.
# Code developed by Denise Cammarota.

# Actual function that interests us ------------------------------
int_seir_mp <- function(time,state,pars){
  return(as.data.frame(ode(y=state,func = seir_mp,parms=pars,
                           times = times)))
}
