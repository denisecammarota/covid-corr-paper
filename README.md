# Correlation Analysis for initial propagation of COVID-19 in Argentina

## Motivation
During my [master thesis](http://ricabib.cab.cnea.gov.ar/1049/) on COVID-19 propagation, it was remarked that Argentinian provinces (administrative divisions similar to states) seemed to drive the epidemiological dynamics during the start of the pandemic in 2020. For example, the province corresponding to the Capital, as well as some northern provinces seemed to have peaks that preceded those of the rest of the country. Therefore, we started to study whether it was possible to quantify this type of relationship between provinces. To do that, we chose to use lagged cross-correlations of time series of different provinces. This is a standard way of computing relationships between heterogeneous epidemic dynamics, specially with small datasets. 

Even though I have done similar analyses in Python, I found that this project would be of great use to me in the light of a few things. Firstly, upon taking the Introduction to Scientific Programming/Computational Methods course, I realized that many of my problems when I did this in my thesis were due to the lack of a correctly organized workflow. Secondly, since I am currently writing a paper on this work, I think this process would greatly benefit from better organization of data and codes, as well as a second look at my analyses. Last, but not least, I am not a proficient R coder and I learn a lot by doing, so this seems like a great opportunity to learn more R. 

## Goals
My main goals for this project include:

* Process the raw data of new COVID-19 cases in Argentina using R
* Separate the processed data into the corresponding time series of infected per province
* Calculate the lagged cross-correlations for all pairs of provinces
* Plot and analyse those lags and correlations to extract insights such as:
  * Which are the biggest correlations and lags? Does that make sense?
  * Which provinces seem to drive epidemic dynamics?
* If I have time before the deadline, I would like to repeat this analysis with deaths, since this is a much more clear indicator of epidemiological situation that does not depend on how many people decide to get tested or differences in symptoms required for testing between different administrative divisions in the country. 

## Dataset 
The dataset of confirmed cases is the official dataset provided by the Argentinian Ministry of Health to this day. The dataset is periodically updated in [this link](http://datos.salud.gob.ar/dataset/covid-19-casos-registrados-en-la-republica-argentina/archivo/fd657d02-a33a-498b-a91b-2ef1a68b8d16). However, the one I am using was downloaded from that same link on Saturday 13th of August of 2022, and can be found in [this link](https://drive.google.com/file/d/1j1QXQZu60LGApLWroKqafhmUa9XdE-m7/view?usp=sharing) of my personal Drive, since the official sites updates the dataset but leaves no record of previous ones. Even though I use my local copy of the dataset to perform all analysis, I haven't uploaded it to GitHub since its size is $`\approx \: 6 \: \mathrm{GB}`$.  

## Methods


## Project structure
This is the corresponding folder structure, updated as of the day of the last commit to the project. This structure is subject of modification until completion of the project.  

```
project/
*    ├── data/
*    │   ├── raw
*    │   └── processed
*    ├── fct/
*    ├── R/
*    └── README.md
```



