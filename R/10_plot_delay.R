# This is code to plot delay in the reporting date plots for some
# Argentinian provinces. Similar to process_cases in some parts.
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

# getting only confirmed cases up to 01/11/2021
cases <- filter(data, clasificacion_resumen == 'Confirmado'
                & fecha_apertura < '2021-01-11'
                & fecha_inicio_sintomas < '2021-01-11')


# positions with na in fecha_inicio_sintomas
s <- is.na(cases$fecha_inicio_sintomas)

# replacing na in fecha_inicio_sintomas
cases$fecha_inicio_sintomas[s] <- as.Date(cases$fecha_apertura[s]) -
  runif(sum(s),0,8)

# dropping unnecessary columns
cases$fecha_apertura <- NULL
cases$clasificacion_resumen <- NULL

# Calculating new cases per day --------------------------------------

cases_province <- cases %>% group_by(residencia_provincia_nombre,
                                     fecha_inicio_sintomas) %>%
                                      summarise(n = n())

# filter registers with 'SIN ESPECIFICAR' as province
cases_province <- filter(cases_province,
                         residencia_provincia_nombre != 'SIN ESPECIFICAR')

# extracting cases per province
cases_province <- data.frame(cases_province)

cases_delay <- filter(cases_province,
                      residencia_provincia_nombre %in% c('Buenos Aires','CABA'))

# Plotting -----------------------------------------------------------
ggplot(cases_delay,aes(fecha_inicio_sintomas,n)) +
  geom_point(aes(colour = residencia_provincia_nombre),
             size = 2.25) + geom_line(aes(colour = residencia_provincia_nombre),size = 1.25) +
  theme_bw() + xlab("t (days)") + ylab(TeX("New cases")) +
  theme(legend.key.height = unit(0.2, 'cm'),
        legend.key.width = unit(0.2, 'cm'),
        text = element_text(size=18)) +
  guides(fill=guide_legend(ncol = 1), color=guide_legend(title="Province")) +
  scale_x_date(date_breaks = "3 days" , date_labels = "%d-%b",
               limits = as.Date(c('2020-12-20', '2021-01-10'))) +
  ylim(0,3200)

ggsave('figs/tseries_delay.png', width = 8.73, height = 3.79)
