# This is code to plot correlations and lags between provinces.
# Code developed by Denise Cammarota.

# Loading of necessary libraries ------------------------------
library(ggplot2) # plot
library(reshape2) # melt function
library(dplyr)
library(matrixStats)
library(latex2exp)

# Loading of data ---------------------------------------------

corrs_file <- 'outputs/cases_corrs_provs.csv' # correlations path
lags_file <-  'outputs/cases_lags_provs.csv' # lags path
names_file <- 'outputs/cases_names_provs.csv' # province names path

corrs <- read.csv(corrs_file) # read correlations
lags <- read.csv(lags_file) # read lags
pnames <- read.csv(names_file) # read names

# Plotting correlations and lags--------------------------------

## Correlations plots -------------------------------------------

### Initial plot -----------------------------------------------

# put names of provinces as col and row names
corrs <- corrs[ ,-1]
rownames(corrs) <- colnames(corrs)
rownames(corrs) <- pnames[ ,2]
colnames(corrs) <- rownames(corrs)

# convert to matrix to use melt
corrs <- as.matrix(corrs)

# melt to right format for ggplot
melt_corrs <- melt(corrs)

# doing the actual plot
ggplot(melt_corrs, aes(x = Var2, y = Var1)) +
  geom_raster(aes(fill = value)) +
  scale_fill_viridis_c(option='magma',
                       name = TeX('$\\chi_{ij}$', italic = TRUE)) + # viridis (colorblind ok)
  labs(x="Provinces", y = "Provinces") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 11, angle = 90,
                                   vjust = 0.6),
        axis.text.y = element_text(size = 11),
        legend.title = element_text(size=14))

ggplot2::ggsave(filename = "figs/cases_corrs.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)

### Plot without Formosa ---------------------------------------

# removing Formosa from matrix
corrs_nf <- corrs[-9, ]
corrs_nf <- corrs_nf[ ,-9]

# melt again
melt_corrs_nf <- melt(corrs_nf)

# doing the same plot
ggplot(melt_corrs_nf, aes(x = Var2, y = Var1)) +
  geom_raster(aes(fill = value)) +
  scale_fill_viridis_c(option='magma',
                       name = TeX('$\\chi_{ij}$', italic = TRUE)) + # viridis (colorblind ok)
  labs(x="Provinces", y = "Provinces") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 11, angle = 90,
                                   vjust = 0.6),
        axis.text.y = element_text(size = 11),
        legend.title = element_text(size=14))

ggplot2::ggsave(filename = "figs/cases_corrs_sf.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)

## Lags plots ---------------------------------------------------

### Initial plot -----------------------------------------------

# put names of provinces as col and row names
lags <- lags[ ,-1]
rownames(lags) <- colnames(lags)
rownames(lags) <- pnames[ ,2]
colnames(lags) <- rownames(lags)

# convert to matrix to use melt
lags <- as.matrix(lags)

# melt to right format for ggplot
melt_lags <- melt(lags)

# doing the actual plot
ggplot(melt_lags, aes(x = Var2, y = Var1)) +
  geom_raster(aes(fill = value)) +
  scale_fill_viridis_c(option='magma',
                       name = TeX('$\\tau_{ij}$', italic = TRUE))+ # viridis (colorblind ok)
  labs(x="Provinces", y = "Provinces") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 11, angle = 90,
                                   vjust = 0.6),
        axis.text.y = element_text(size = 11),
        legend.title = element_text(size=14))

ggplot2::ggsave(filename = "figs/cases_lags.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)

# Plot without Formosa ----------------------------------------

lags_nf <- lags[-9, ]
lags_nf <- lags_nf[ ,-9]

melt_lags_nf <- melt(lags_nf)

# doing the same plot
ggplot(melt_lags_nf, aes(x = Var2, y = Var1)) +
  geom_raster(aes(fill = value)) +
  scale_fill_viridis_c(option='magma',
                       name = TeX('$\\tau_{ij}$', italic = TRUE)) + # viridis (colorblind ok)
  labs(x="Provinces", y = "Provinces") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 11, angle = 90,
                                   vjust = 0.6),
        axis.text.y = element_text(size = 11),
        legend.title = element_text(size=14))

ggplot2::ggsave(filename = "figs/cases_lags_sf.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)


# Computing and plotting mean values --------------------------

## Mean Correlation -------------------------------------------

# taking the mean and std, convert for ggplot to data.frame
mean_corrs <- data.frame(rowMeans(corrs)) # mean corr per province
seq_provs <- seq(1, ncol(corrs), 1) # numeric sequence for xticks
sd_corrs <- rowSds(corrs) # std per province

# plot corrs per province
ggplot(mean_corrs,
       aes(x = seq_provs, y = rowMeans.corrs.)) +
  geom_point(size=3) +
  geom_line(size=1) +
  theme_bw() +
  scale_x_discrete("Province", seq_provs,
                   pnames[, 2], as.factor(seq_provs)) +
  labs(x="Province", y = TeX('$C_{i}$', italic = TRUE)) +
  theme(axis.text.x = element_text(size = 11, angle = 90,
                                   vjust = 0.6),
        axis.text.y = element_text(size = 11)) +
  geom_errorbar(aes(ymin=rowMeans.corrs.-sd_corrs,
                    ymax=rowMeans.corrs.+sd_corrs))

# saving the plot
ggplot2::ggsave(filename = "figs/cases_mcorrs.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)


# taking out Formosa to plot again
mean_corrs_sf <- data.frame(mean_corrs[-9, ]) # eliminating Formosa mean
sd_corrs_sf <- sd_corrs[-9] # eliminating Formosa sd
seq_provs_sf <- seq(1, ncol(corrs)-1, 1) # new province seq for xticks
names(mean_corrs_sf) <- 'rowMeans.corrs.' # correcting new name


# plot corrs per province
ggplot(mean_corrs_sf,
       aes(x = seq_provs_sf, y = rowMeans.corrs.)) +
  geom_point(size=3) +
  geom_line(size=1) +
  theme_bw() +
  scale_x_discrete("Province", seq_provs_sf,
                   pnames[-9, 2], as.factor(seq_provs_sf)) +
  labs(x="Province", y = TeX('$C_{i}$', italic = TRUE)) +
  theme(axis.text.x = element_text(size = 11, angle = 90,
                                   vjust = 0.6),
        axis.text.y = element_text(size = 11)) +
  geom_errorbar(aes(ymin = rowMeans.corrs. - sd_corrs_sf,
                    ymax = rowMeans.corrs. + sd_corrs_sf))

# saving the plot
ggplot2::ggsave(filename = "figs/cases_mcorrs_sf.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)

# Mean Lags ------------------------------------------------

# taking the mean and std, convert for ggplot to data.frame
mean_lags <- data.frame(rowMeans(lags))
sd_lags <- rowSds(lags)
# plot mean lag per province
ggplot(mean_lags,
       aes(x = seq_provs, y = rowMeans.lags.)) +
  geom_point(size=3) +
  geom_line(size=1) +
  theme_bw() +
  scale_x_discrete("Province", seq_provs,
                   pnames[, 2], as.factor(seq_provs)) +
  labs(x="Province", y = TeX('$L_{i}$', italic = TRUE)) +
  theme(axis.text.x = element_text(size = 11, angle = 90,
                                   vjust = 0.6),
        axis.text.y = element_text(size = 11)) +
  geom_errorbar(aes(ymin = rowMeans.lags. - sd_lags,
                    ymax= rowMeans.lags. + sd_lags))

# saving the plot
ggplot2::ggsave(filename = "figs/cases_mlags.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)


# taking out formosa to plot again
mean_lags_sf <- data.frame(mean_lags[-9, ]) # eliminating Formosa mean
sd_lags_sf <- sd_lags[-9] # eliminating Formosa sd
seq_provs_sf <- seq(1, ncol(lags)-1, 1) # new province seq for xticks
names(mean_lags_sf) <- 'rowMeans.lags.' # correcting new name


ggplot(mean_lags_sf,
       aes(x = seq_provs_sf, y = rowMeans.lags.)) +
  geom_point(size=3) +
  geom_line(size=1) +
  theme_bw() +
  scale_x_discrete("Province", seq_provs_sf,
                   pnames[-9, 2], as.factor(seq_provs_sf)) +
  labs(x="Province", y = TeX('$L_{i}$', italic = TRUE)) +
  theme(axis.text.x = element_text(size = 11, angle = 90,
                                   vjust = 0.6),
        axis.text.y = element_text(size = 11)) +
  geom_errorbar(aes(ymin = rowMeans.lags. - sd_lags_sf,
                    ymax = rowMeans.lags. + sd_lags_sf))

ggplot2::ggsave(filename = "figs/cases_mlags_sf.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)
