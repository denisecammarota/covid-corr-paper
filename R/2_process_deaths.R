# This is code to obtain records of deaths from COVID-19 in
# Argentina along with the date of death and province.
# Code developed by Denise Cammarota.

# Loading of necessary libraries ---------------------------------
library(data.table)
library(dplyr)

# Loading of necessary dataset -----------------------------------

input_file <- 'data/raw/Covid19Casos.csv' # input file path

col_names <- c('residencia_provincia_nombre',
               'fallecido',
               'fecha_fallecimiento') # subset of original columns

data <- fread(file=input_file,
              select=col_names,
              data.table=FALSE) # read data

#cast dates to date class objects
data$fecha_fallecimiento <- as.Date(data$fecha_fallecimiento)

# Processing of the data ----------------------------------------

# getting only confirmed deaths in 2020
deaths <- filter(data, fallecido == 'SI'
                & fecha_fallecimiento < '2021-01-01')

# seeing if there are missing dates
sum(is.na(deaths$fecha_fallecimiento))

# dropping unnecessary columns
deaths$fallecido <- NULL

# Saving to output file -----------------------------------------

output_file <- 'data/processed/Covid19Casos_deaths.csv' # output path
fwrite(deaths,output_file) # write output file

