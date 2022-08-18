# This is code to obtain records of confirmed cases of COVID-19
# in Argentina along with the date of symptom onset and province.
# Code developed by Denise Cammarota.

# Loading of necessary libraries ---------------------------------
library(data.table)
library(dplyr)

# Setting random number seed -------------------------------------
set.seed(1)

# Loading of the necessary data ----------------------------------

input_file <- 'data/raw/Covid19Casos.csv' # input file path

col_names <- c('residencia_provincia_nombre',
               'fecha_inicio_sintomas','fecha_apertura',
               'clasificacion_resumen') # subset of original columns

data <- fread(file=input_file,
              select=col_names,
              data.table=FALSE) # read data

#cast dates to date class objects
data$fecha_inicio_sintomas <- as.Date(data$fecha_inicio_sintomas)
data$fecha_apertura <- as.Date(data$fecha_apertura)

# Processing the data --------------------------------------------

# getting only confirmed cases in 2020
cases <- filter(data, clasificacion_resumen == 'Confirmado'
                & fecha_apertura < '2021-01-01'
                & fecha_inicio_sintomas < '2021-01-01')

# positions with na in fecha_inicio_sintomas
s <- is.na(cases$fecha_inicio_sintomas)

# replacing na in fecha_inicio_sintomas
cases$fecha_inicio_sintomas[s] <- as.Date(cases$fecha_apertura[s]) -
                                  runif(sum(s),0,8)

# dropping unnecessary columns
cases$fecha_apertura <- NULL
cases$clasificacion_resumen <- NULL

# Saving data to output file -----------------------------------
output_file <- 'data/processed/cases_processed.csv'# output path
fwrite(cases,output_file) # write output file
