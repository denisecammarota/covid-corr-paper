# Plots the time series, figures to put in the paper
# Code developed by Denise Cammarota

# Libraries ----------------------------------------------------
library(ggplot2)
library(reshape2)
library(tidyverse)
library(latex2exp)

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

# plotting not normaized time series
tseries_total = as.data.frame(tseries_total)

df <- melt(tseries_total ,  id.vars = 'Time', variable.name = 'Provinces')

ggplot(df, aes(Time,value)) +
  geom_line(aes(colour = Provinces), size = 1.5) +
  theme_bw() + xlab(TeX("$t$ (days)",italic = TRUE)) +
  ylab(TeX("$I_{i}(t)$", italic = TRUE)) +
  theme(legend.key.height = unit(0.2, 'cm'),
        legend.key.width = unit(0.2, 'cm'),
        text = element_text(size=20)) +
  guides(fill=guide_legend(ncol = 1)) + scale_y_continuous(trans='log2')

ggsave('figs/tseries.pdf', width = 11.73, height = 4.79)

# plotting normalized time series
tseries_total_norm <- tseries_total
aux_nprovs <- dim(tseries_total)[2]
for(i in seq(2,25,1)){
  aux_max <- max(tseries_total_norm[i])
  tseries_total_norm[i] <- tseries_total_norm[i]/aux_max
}

df_norm <- melt(tseries_total_norm, id.vars = 'Time', variable.name = 'Provinces')

ggplot(df_norm, aes(Time,value)) +
  geom_line(aes(colour = Provinces), size = 1.25) +
  theme_bw() + xlab(TeX("t (days)", italic = TRUE)) +
  ylab(TeX("$I_{i}(t)$ (normalized)", italic = TRUE)) +
  theme(legend.key.height = unit(0.2, 'cm'),
        legend.key.width = unit(0.2, 'cm'),
        text = element_text(size = 20)) +
  guides(fill=guide_legend(ncol = 1))

ggsave('figs/tseries_norm.pdf', width = 11.73, height = 4.79)

# Plotting peaks -----------------------------------------------

# searching and extracting the max indeces
tseries_maxind <- apply(tseries_total, 2, which.max)
tseries_maxind <- data.frame(tseries_maxind)
tseries_maxind <- tseries_maxind$tseries_maxind
tseries_maxind <- tseries_maxind[-1]
tseries_maxind <- data.frame(tseries_maxind)

# create total dataframe
total_ind <- cbind(prov_name,tseries_maxind)
