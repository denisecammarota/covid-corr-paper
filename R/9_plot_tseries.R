# Plots the time series, figures to put in the paper
# Code developed by Denise Cammarota

# Libraries ----------------------------------------------------
library(ggplot2)
library(reshape2)
library(tidyverse)

# Reading time series data --------------------------------------
tseries_file <- 'outputs/cases_provs.csv'
cases <- read.csv(tseries_file) # read data
cases <- cases[ ,-1] # remove first index row
cases <- t(cases)
rownames(cases) <- seq(1,366,1)

# reading names of the provinces
prov_name_file <- 'outputs/cases_names_provs.csv'
prov_name <- read.csv(prov_name_file)
prov_name <- prov_name[-1]
rownames(prov_name) <- NULL

# adding time to time series data
n_days <- dim(cases)[1]
times <- seq(1,n_days,1)

# formatting the time series to plot
tseries_total <- cbind(times,cases)
names <- rbind('Time', prov_name)
colnames(tseries_total) <- names$x

# Plotting time series ------------------------------------------
tseries_total = as.data.frame(tseries_total)
df <- melt(tseries_total ,  id.vars = 'Time', variable.name = 'series')
ggplot(df, aes(Time,value)) + geom_line(aes(colour = series))
