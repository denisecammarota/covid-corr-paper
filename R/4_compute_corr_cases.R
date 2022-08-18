# This is code to obtain correlations of COVID-19 cases between
# provinces. Code developed by Denise Cammarota.

# Loading necessary functions --------------------------------
source('fct/lagged_correlations.R')

# Loading provinces time series data -------------------------
tseries_file <- 'outputs/cases_provs.csv'
cases <- read.csv(tseries_file) # read data
names(cases) <- NULL # remove column names
cases <- cases[ ,-1] # remove first index row
cases <- data.matrix(cases) # cast to matrix

# Computing lagged correlations ------------------------------
results <- lagged_correlations(cases)
corrs <- results[1]
lags <- results[2]

# Saving the results -----------------------------------------
write.csv(corrs,'outputs/cases_corrs_provs.csv')
write.csv(lags,'outputs/cases_lags_provs.csv')


