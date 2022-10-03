# Gets initial condtions to fit the model
# Code developed by Denise Cammarota

# Reading necessary files --------------------------------------------------
pop_file <- 'data/raw/provs_pop.csv' # provinces populations
condin_file <- 'data/raw/provs_condinit.csv' # provinces initial conditions

pop <- read.csv(pop_file)
condin <- read.csv(condin_file)

# Defining initial conditions ---------------------------------------------
pop <- as.matrix(pop[-1]) # remove first column of indexes
S <- t(pop)
E <- matrix(0,nrow = 1, ncol = n_provs)
I <- t(as.matrix(condin[-1]))
R <- matrix(0,nrow = 1, ncol = n_provs)
state <- c(S = S, E = E, I = I, R = R)

# Saving initial conditions data ------------------------------------------
write.csv(state,'outputs/initial_conditions.csv')


