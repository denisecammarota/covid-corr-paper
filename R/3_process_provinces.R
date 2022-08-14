# This is code to obtain time series of COVID cases in different
# provinces. Code developed by Denise Cammarota.

# Loading of necessary libraries ---------------------------------
library(dplyr)

# Loading cases and deaths data ----------------------------------

# cases input path
cases_file <- 'data/processed/Covid19Casos_processed.csv'
# deaths input path
deaths_file <- 'data/processed/Covid19Casos_deaths.csv'

cases <- read.csv(cases_file) # read cases
deaths <- read.csv(deaths_file) # read deaths

# Grouping cases by province -------------------------

cases_province <- cases %>% group_by(residencia_provincia_nombre,
                                     fecha_inicio_sintomas) %>%
                                     summarise(n = n())

provinces <- unique(cases_province$residencia_provincia_nombre)

max_date <- max(cases_province$fecha_inicio_sintomas)

min_date <- min(cases_province$fecha_inicio_sintomas)


