# This is code to obtain records of confirmed cases of COVID-19
# in Argentina along with the date of symptom onset and province.
# Code developed by Denise Cammarota.

# Loading of necessary libraries ---------------------------------
library(data.table)
library(dplyr)

# Loading of the necessary data ----------------------------------

input_file <- 'data/raw/Covid19Casos.csv' # input file path

col_names <- c('residencia_provincia_nombre',
               'fecha_inicio_sintomas','fecha_apertura',
               'clasificacion_resumen') # subset of original columns

data <- fread(file=input_file,
              select=col_names,
              data.table=FALSE) # read data

class(data) # data.frame object

# Processing the data --------------------------------------------

# getting only confirmed cases in 2020
cases <- filter(data,clasificacion_resumen == 'Confirmado'
                & fecha_apertura < '2021-01-01')


#replacing na in fecha_inicio_sintomas, ie symptom onset day
s <- is.na(cases$fecha_inicio_sintomas)
cases$fecha_inicio_sintomas[s] <- as.Date(cases$fecha_apertura[s]) -
                                  runif(length(s),0,8)

# dropping unnecessary columns


# Saving data to output file -----------------------------------


