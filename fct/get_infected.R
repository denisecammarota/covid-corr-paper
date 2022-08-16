# This is code to get the total number of infected by
# summing over the last n days, where n is the infectious
# period. Code developed by Denise Cammarota.

get_infected <- function(m,d){
  # m is a matrix of time series of provinces x days
  # d is duration of infectious period in days
  # returns matrix of same dimensions as m
  nr <- nrow(m) # number of rows or provinces
  nc <- ncol(m) # number of cols or days in time series
  m_res <- matrix(0,nr,nc) # result matrix
  for(i in seq(1,nr,1)){
    # looping through provinces
    for(j in seq(1,nc,1)){
      # looping through dates in time series
      begin_index <- j-d # begin index to sum
      if(j-d < 0){ # if index is negative
        begin_index <- 1
      }
      m_res[i,j] <- sum(m[i,begin_index:j])
    }
  }
  return(m_res)
}

