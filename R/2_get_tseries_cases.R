# This is code to obtain time series of COVID cases in different
# provinces. Code developed by Denise Cammarota.

# Loading of necessary libraries ---------------------------------
library(dplyr)

# Loading cases data ---------------------------------------------

# cases input path
cases_file <- 'data/processed/Covid19Casos_processed.csv'

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

# get last date of reporting in 2020
max_date <- max(cases_province$fecha_inicio_sintomas)

# get first date of reporting in 2020
min_date <- min(cases_province$fecha_inicio_sintomas)

# get a complete vector of dates
dates <- seq(min_date,max_date,by='days')

# matrix to have our time series
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

# Saving data, including time series, dates and provinces -----------------
write.table(m,'data/processed/c_provinces.csv',
          row.names = FALSE,
          col.names = FALSE)
write.table(dates,'data/processed/c_dates_provinces.csv',
            row.names = FALSE,
            col.names = FALSE)
write.table(provinces,'data/processed/c_names_provinces.csv',
            row.names = FALSE,
            col.names = FALSE)


