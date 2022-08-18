# This is code to explore original dataset, specially dates.
# Code developed by Denise Cammarota.

# Loading of necessary libraries ---------------------------------
library(data.table)
library(dplyr)
library(ggplot2)

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

# Basic analysis of the data ---------------------------------------

# detecting NAs in fechas atributes
colSums(is.na(data))

# possible values of clasificacion_resumen
unique(data$clasificacion_resumen)

# possible values of residencia_provincia_nombre
# value 'SIN ESPECIFICAR' is not a province
unique(data$residencia_provincia_nombre)

# Exploring relationship between dates ------------------------------

# max dates values
max(data$fecha_apertura[is.na(data$fecha_apertura)
                        != TRUE])
max(data$fecha_inicio_sintomas[is.na(data$fecha_inicio_sintomas)
                               != TRUE])

# min dates values
min(data$fecha_apertura[is.na(data$fecha_apertura)
                        != TRUE])

min(data$fecha_inicio_sintomas[is.na(data$fecha_inicio_sintomas)
                               != TRUE])

# get interesting dates, only confirmed in 2020
data <- filter(data, clasificacion_resumen == 'Confirmado'
                & fecha_apertura < '2021-01-01'
                & fecha_inicio_sintomas < '2021-01-01')

# vectors with dates
dates_start <- data$fecha_inicio_sintomas
dates_report <- data$fecha_apertura

# substract min date of all vectors
min_date <- min(min(data$fecha_apertura[is.na(data$fecha_apertura)
                                        != TRUE]),
                min(data$fecha_inicio_sintomas[is.na(data$fecha_inicio_sintomas)
                                               != TRUE]))

dates_start <- as.numeric(dates_start - min_date)

dates_report <- as.numeric(dates_report - min_date)

# Relationship between fecha_apertura and fecha_inicio --------------
# diregarding NAs in fecha_inicio_sintomas
dates_start_nna <- dates_start[is.na(dates_start) != TRUE]
dates_report_nna <- dates_report[is.na(dates_start) != TRUE]

# convert to data.frame for plotting
dates_start_nna <- data.frame(dates_start_nna)
dates_report_nna <- data.frame(dates_report_nna)
dates_total_nna <- data.frame(dates_start_nna,
                              dates_report_nna)


# calculating mean and variance of difference between dates
mean_diff <- mean(dates_total_nna$dates_report_nna
     - dates_total_nna$dates_start_nna)

sd_diff <- sd(dates_total_nna$dates_report_nna
   - dates_total_nna$dates_start_nna)

# plotting this difference in histogram with ggplot
ggplot(dates_total_nna, aes(x= dates_report_nna - dates_start_nna)) +
  geom_histogram(binwidth = 1) +
  xlim(-5,15) +
  geom_vline(aes(xintercept = mean_diff),
             col='black',size=1) +
  geom_vline(aes(xintercept = mean_diff + sd_diff),
             col='red',size=1) +
  geom_vline(aes(xintercept = mean_diff - sd_diff),
             col='red',size=1) +
  labs(x="fecha_apertura - fecha_inicio_sintomas",
       y = "Counts", title =
         "Histogram of fecha_apertura - fecha_inicio_sintomas") +
  theme_bw() +
  theme(plot.title=element_text(size = 12,
                                hjust = 0.5))

ggplot2::ggsave(filename = "figs/dates_diff.png",
                dpi = 300,
                units = "in",
                width = 4.5,
                height = 3.0)





