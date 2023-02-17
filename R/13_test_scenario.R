# Comparing possible scenarios given the parameters from the
# best fitted model to the data. Scenario here is Northwestern
# provinces with no initial cases to test border relevance.
# Code developed by Denise Cammarota

library(ggplot2)
library(latex2exp)
library(patchwork)
source('fct/sir_mp_optim_matform.R')
source('fct/int_sir_mp_optim.R')

# Loading data -------------------------------------------------

# real data
tseries_file <- 'outputs/cases_provs.csv' # time series data
tseries <- read.csv(tseries_file)
tseries_2 <- as.matrix(tseries)
tseries_2 <- matrix(tseries_2,ncol=ncol(tseries_2),dimnames = NULL)
tseries_2 <- tseries_2[,-1]
tseries_2 <- tseries_2[-9,] # removing Formosa

# parameters from best fit data
coeffs_file <- 'outputs/bestfit_parameters.csv'
coeffs <- read.csv(coeffs_file)
coeffs

# connectivity matrix with distances
file_A <- './outputs/mat_dist_matform.csv'
A <- as.matrix(read.csv(file_A))
A <- A[,-1] # 23 x 23 matrix

# initial conditions
state_file <- 'outputs/initial_conditions_sir.csv'
state <- read.csv(state_file)
state <- as.numeric(state[,2])
state <- state[-c(9,33,57)] # removing Formosa
provs_to_zero <- 23 + seq(3,23,1)
state[provs_to_zero] <- 0 # modifying initial conditions

# Simulating data -----------------------------------------------
prov_names <- coeffs$prov_names
n_days <- dim(tseries_2)[2]
n_provs <- dim(tseries_2)[1]
times <- seq(1,n_days,1)

coeffs_values <- coeffs$coeff_sc
beta <- coeffs_values[1:23]
g <- coeffs_values[24]
pars <- c(beta = beta, g = g)
gamma <- 1./14

fit_results <- deSolve::ode(y=state,func = sir_mp_optim_matform,parms=pars,
                            times = times, A = A, n_days= n_days, n_provs = n_provs, gamma = gamma)
infected_results <- fit_results[,25:47]
infected_results <- data.frame(infected_results)


# Plotting simulation results and data --------------------------
tseries_2 <- t(tseries_2)
tseries_2 <- data.frame(tseries_2)
tseries_2<- cbind(times,tseries_2)
infected_results <- cbind(times,infected_results)

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
#plot(p)

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
plot(p)

print(sum((infected_results - tseries_2)**2))
