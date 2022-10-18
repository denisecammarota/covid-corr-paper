# This is code to obtain time series of COVID cases in different
# provinces. Code developed by Denise Cammarota.

# Loading of necessary libraries ---------------------------------
library(dplyr)
library(ggplot2)

# Loading of necessary functions ---------------------------------
source('fct/get_infected.R')

# Loading cases data ---------------------------------------------

# cases input path
cases_file <- 'data/processed/cases_processed.csv'

cases <- read.csv(cases_file) # read cases

# casting to date, read.csv reads as characters
cases$fecha_inicio_sintomas <- as.Date(cases$fecha_inicio_sintomas)

# Calculate time series per province ----------------------------
cases_province <- cases %>% group_by(residencia_provincia_nombre,
                                     fecha_inicio_sintomas) %>%
                                     summarise(n = n())

# get list of provinces
provinces <- unique(cases_province$residencia_provincia_nombre)

# filter registers with 'SIN ESPECIFICAR' as province
cases_province <- filter(cases_province,
                         residencia_provincia_nombre != 'SIN ESPECIFICAR')

provinces <- provinces[provinces != 'SIN ESPECIFICAR']

# get last date of reporting in 2020
max_date <- max(cases_province$fecha_inicio_sintomas)

# get first date of reporting in 2020
min_date <- min(cases_province$fecha_inicio_sintomas)

# get a complete vector of dates
dates <- seq(min_date,max_date,by='days')

# matrix to have our time series of new cases
nr <- length(provinces) # number of rows
nc <- length(dates) # number of columns
m <- matrix(0,nr,nc) # matrix of 0 of correct size

for(i in seq(1,nr,1)){
  # looping through provinces
  for(j in seq(1,nc,1)){
    # looping through days
    tmp_cases <- filter(cases_province,
                        residencia_provincia_nombre == provinces[i],
                        fecha_inicio_sintomas == dates[j])
    if(dim(tmp_cases)[1] != 0){
      m[i,j] <- tmp_cases$n
    }
  }
}

# summing last 14 days for each to get infected per day
m <- get_infected(m,14)


# Saving data, including time series, dates and provinces -----------------
write.csv(m,'outputs/cases_provs.csv')
write.csv(dates,'outputs/cases_dates_provs.csv')
write.csv(provinces,'outputs/cases_names_provs.csv')


