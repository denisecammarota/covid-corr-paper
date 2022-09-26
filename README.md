# Correlation Analysis for initial propagation of COVID-19 in Argentina

**Author: Denise Stefania Cammarota**

## Methods
The relationship between the epidemiological dynamics of provinces is quantified by calculating lagged cross-correlations. In order to calculate these quantities in R, we use the function `ccf` that is present in base R, indicating that the maximum possible lag is around 365 days. That is, the lag between two provinces could have any value between 0 and 365 days. 

## Dataset 
The dataset of confirmed cases is the official dataset provided by the Argentinian Ministry of Health to this day. The dataset is periodically updated in [this link](http://datos.salud.gob.ar/dataset/covid-19-casos-registrados-en-la-republica-argentina/archivo/fd657d02-a33a-498b-a91b-2ef1a68b8d16). However, the one I am using was downloaded from that same link on Saturday 13th of August of 2022, and can be found in [this link](https://drive.google.com/file/d/1j1QXQZu60LGApLWroKqafhmUa9XdE-m7/view?usp=sharing) of my personal Drive, since the official sites updates the dataset but leaves no record of previous ones. Even though I use my local copy of the dataset to perform all analysis, I haven't uploaded it to GitHub since its size is about 6 GB.  

## Requirements 
Windows, Linux or MacOS with R installed, at least 8GB of RAM to explore and process the raw data. Apart from base R, the following libraries need to be installed in order to run all scripts:
```
dplyr
data.table
ggplot2
reshape2
matrixStats
deSolve
```
These can be installed by running the following commands in an R terminal:

```
install.packages("dplyr")
install.packages("data.table")
install.packages("ggplot2")
install.packages("reshape2")
install.packages("matrixStats")
install.packages("deSolve")
```

## Project structure
This is the corresponding folder structure, updated as of the day of the last commit to the project. This structure is subject of modification until completion of the project.  

```
project/
*    ├── data/
*    │   ├── raw
*    │   └── processed
*    ├── docs/
*    ├── fct/
*    ├── figs/
*    ├── outputs/
*    ├── R/
*    └── README.md
```

-  The `data` folder contains two subfolders with raw and processed data. The `raw` data folder is not found on the repository, since it contains the total cases file, whose size is too big to be uploaded to GitHub. The `processed` subfolder contains processed cases and time series data. 
- The `docs` folder contains markdown and html files. In this case, the resulting report can be found in this folder. 
- The `fct` folder contains custom R functions in order to process and analyze the data. 
- The `figs` folder contains figures obtained from data analysis. 
- The `outputs` folder contains important outputs generated from our scripts. In this case, the time series of provinces with the corresponding information on provinces names and dates, along with the correlations and lags matrices can be found here. 
- The `R` folder contains the R script to process and analyze the data.



