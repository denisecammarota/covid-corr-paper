# This is code to obtain lagged correlations of any number of
# columns of a matrix type object.
# Code developed by Denise Cammarota.

lagged_correlations <- function(m){
  # m matrix where each row is a time series
  # returns matrices of correlations and lags
  nr <- nrow(m)
  corrs <- matrix(0,nr,nr) # correlation matrix
  lags <- matrix(0,nr,nr) # lags matrix
  for(i in seq(1,nr,1)){
    for(j in seq(i,nr,1)){
      tmp_corr <- ccf(m[i, ], m[j, ], plot = FALSE)
      max_index <- which.max(tmp_corr$acf) # max lag index
      corrs[i,j] <- tmp_corr$acf[max_index] # max correlation
      corrs[j,i] <- corrs[i,j] # transpose correlation
      lags[i,j] <- tmp_corr$lag[max_index]  # lag at max correlation
      lags[j,i] <- -lags[i,i] # transpose lag
    }
  }
  return(list(corrs, lags))
}
