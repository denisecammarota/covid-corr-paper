# This is code to obtain lagged correlations of any number of
# columns of a matrix type object.
# Code developed by Denise Cammarota.

lagged_correlations <- function(m){
  # m matrix where each row is a time series
  nr <- nrow(m)
  corrs <- matrix(0,nr,nr) # correlation matrix
  lags <- matrix(0,nr,nr) # lags matrix
  for(i in seq(1,nr,1)){
    for(j in seq(i,nr,1)){
      tmp_corrs <- ccf(m[i, ],m[j, ])
      corrs[i,j] <-
      corrs[j,i] <- corrs[i,j]
      lags[i,j] <-
      lags[j,i] <- -lags[i,i]
    }
  }
}
