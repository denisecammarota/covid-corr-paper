# Fits the model of SEIR metapopulation dependent on population and
# distance to the time series data of provinces with optim function
#
# Code developed by Denise Cammarota

library(minpack.lm)
library(patchwork)
library(ggplot2)
library(reshape2)
library(latex2exp)
source('fct/seir_mp_optim.R')
source('fct/int_seir_mp_optim.R')
source('fct/sir_mp_optim.R')
source('fct/int_sir_mp_optim.R')
source('fct/seir_mp_optim_matform.R')
source('fct/sir_mp_optim_matform.R')


# Reading data ----------------------------------------------------

## Time series data -----------------------------------------------
tseries_file <- 'outputs/cases_provs.csv' # time series data
tseries <- read.csv(tseries_file)
tseries_2 <- as.matrix(tseries)
tseries_2 <- matrix(tseries_2,ncol=ncol(tseries_2),dimnames = NULL)
tseries_2 <- tseries_2[,-1]

# removing Formosa
tseries_2 <- tseries_2[-9,]

# time series of 24 x 367 provinces x days
n_provs <- dim(tseries_2)[1] # number of provinces 24

## Initial conditions data ----------------------------------------
state <- read.csv("outputs/initial_conditions_sir.csv")
state <- as.numeric(state[,2]) # 72 length vector

# removing Formosa
state <- state[-c(9,33,57)]

## Connectivity matrix data ---------------------------------------
file_A <- './outputs/mat_dist_matform.csv'
A <- as.matrix(read.csv(file_A))
A <- A[,-1] # 23 x 23 matrix

# Preparing for fit -----------------------------------------------
n_days <- dim(tseries_2)[2]
times <- seq(1,n_days,1)

alpha <- 1./5 # alpha for connectivity matrix
beta <- rep(2./14,n_provs) # beta factors for each province
gamma <- 1./14 # gamma inverse of recovery period
g <- 0.1 # proportionality constant g
pars <- c(beta = beta, g = g)

pars_lower <- rep(0,24)

# Doing the fit ---------------------------------------------------
fitoptim <- nls.lm(par = pars, fn = int_sir_mp_optim,
                     lower =  pars_lower, control = nls.lm.control(maxiter = 300),
                     time = times, tseries_2 = tseries_2,
                     state = state, matA = A, n_days = n_days,
                     n_provs = n_provs, gamma = gamma)

fit_values <- fitoptim$par


# Saving fit results ------------------------------------------------
fit_results <- deSolve::ode(y=state,func = sir_mp_optim_matform,parms=fit_values,
                            times = times, A = A, n_days= n_days, n_provs = n_provs, gamma = gamma)
infected_results <- fit_results[,25:47]

infected_results <- data.frame(infected_results)
write.csv(infected_results, "outputs/fit_res_sir_mp.csv")

# Preparing for plot of results ----------------------------------------
# transpose the data
tseries_2 <- t(tseries_2)
tseries_2 <- data.frame(tseries_2)


# adding time to data and infected results
# first to the data
n_days <- dim(tseries_2)[1]
times <- seq(1,n_days,1)
tseries_2<- cbind(times,tseries_2)
infected_results <- cbind(times,infected_results)

# extracting province names
prov_names <- read.csv('outputs/cases_names_provs.csv')
prov_names <- prov_names[-1]
rownames(prov_names) <- NULL
prov_names <- prov_names$x
prov_names <- prov_names[-9]

# Plotting fit and original data -------------------------------

# we plot the first one
tseries_tmp <- cbind(tseries_2[,1],tseries_2[,2])
infected_tmp <- cbind(infected_results[,1],infected_results[,2])

names <- rbind('Time','Prov')
colnames(tseries_tmp) <- names
colnames(infected_tmp) <- names
tseries_tmp <- data.frame(tseries_tmp)
infected_tmp <- data.frame(infected_tmp)
p <- ggplot() + ggtitle(prov_names[1]) +
  geom_line(data = tseries_tmp, aes(x = Time, y = Prov),size = 1.25) +
  geom_line(data = infected_tmp, aes(x = Time, y = Prov),size = 1.25, color = 'red')+
  theme_bw() + xlab("t (days)") +
  ylab(TeX("$I_{i}(t)$")) +
  theme(legend.key.height = unit(0.2, 'cm'),
        legend.key.width = unit(0.2, 'cm'),
        text = element_text(size=8), plot.title = element_text(hjust = 0.5)) +
  guides(fill=guide_legend(ncol = 1))
plot(p)

# and now we loop for the rest of them
for(i in seq(3,n_provs+1,1)){
  tseries_tmp <- cbind(tseries_2[,1],tseries_2[,i])
  infected_tmp <- cbind(infected_results[,1], infected_results[,i])
  names <- rbind('Time','Prov')
  colnames(tseries_tmp) <- names
  colnames(infected_tmp) <- names
  tseries_tmp <- data.frame(tseries_tmp)
  infected_tmp <- data.frame(infected_tmp)
  q <-  ggplot() + ggtitle(prov_names[i-1]) +
    geom_line(data = tseries_tmp, aes(x = Time, y = Prov),size = 1.25) +
    geom_line(data = infected_tmp, aes(x = Time, y = Prov),size = 1.25, color = 'red') +
    theme_bw() + xlab("t (days)") +
    ylab(TeX("$I_{i}(t)$")) +
    theme(legend.key.height = unit(0.2, 'cm'),
          legend.key.width = unit(0.2, 'cm'),
          text = element_text(size = 8), plot.title = element_text(hjust = 0.5)) +
    guides(fill=guide_legend(ncol = 1))
  p <- p + q
}

p <- p +  plot_layout(ncol = 4)

# saved as pdf since it is a huge image

# Plotting beta for each province --------------------------------

# summary of fit with coefficients and std
s <- summary(fitoptim)
sc <- s$coefficients
sc <- data.frame(sc)

# coefficient and std
coeff_sc <- sc['Estimate']
std_sc <- sc['Std..Error']

# saving g value
g_sc <- coeff_sc[24,]
g_std_sc <- std_sc[24,]

# beta for each province
coeff_sc <- coeff_sc[-24,]
std_sc <- std_sc[-24,]


# preparing for plot
pars_sc <- data.frame(coeff_sc,std_sc)
pars_sc <- cbind(prov_names,pars_sc)

# plotting beta for each province
ggplot(pars_sc, aes(x = prov_names, y=coeff_sc, group = 1)) +
  geom_line(size=1) +
  geom_point(size = 2) +
  geom_errorbar(aes(ymin = coeff_sc - std_sc,
                    ymax = coeff_sc + std_sc),
                width=0.5, size = 1) +
  theme_bw() +
  xlab(TeX("Province")) +
  ylab(TeX('$\\beta_{i}$', italic = TRUE)) +
  theme(axis.text.x = element_text(size = 14, angle = 90,
                                   vjust = 0.7, hjust = 0.7),
        axis.text.y = element_text(size = 14),
        axis.title=element_text(size=18))

ggsave('figs/beta_provs.pdf', height = 6.0, width = 10.0,
       units = "in")

# Saving coefficients from fitting -----------------------------
g_tmp <- data.frame(cbind('All',g_sc,g_std_sc))
names(g_tmp) <- names(pars_sc)
pars_sc <- rbind(pars_sc,g_tmp)

write.csv(pars_sc, "outputs/bestfit_parameters.csv",
          row.names=FALSE, quote=FALSE)
