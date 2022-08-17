# This is code to plot correlations and lags between provinces.
# Code developed by Denise Cammarota.

# Loading of necessary libraries ------------------------------
library(ggplot2) # plot
library(reshape2) # melt function
library(dplyr)

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
  scale_fill_viridis_c(option='magma') + # viridis (colorblind ok)
  labs(x="Provinces", y = "Provinces", title =
      "Provinces Correlations") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 9, angle = 90,
                                   vjust = 0.6),
        axis.text.y = element_text(size = 9),
        plot.title=element_text(size = 11, hjust = 0.5))

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
  scale_fill_viridis_c(option='magma') + # viridis (colorblind ok)
  labs(x="Provinces", y = "Provinces", title =
         "Provinces Correlations (minus Formosa)") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 9, angle = 90,
                                   vjust = 0.6),
        axis.text.y = element_text(size = 9),
        plot.title=element_text(size = 11, hjust = 0.5))

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
  scale_fill_viridis_c(option='magma')+ # viridis (colorblind ok)
  labs(x="Provinces", y = "Provinces", title =
      "Provinces Lags") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 9, angle = 90,
                                   vjust = 0.6),
        axis.text.y = element_text(size = 9),
        plot.title=element_text(size = 11, hjust = 0.5))

ggplot2::ggsave(filename = "figs/cases_lags.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)



# Computing and plotting mean values --------------------------

## Mean Correlation -------------------------------------------

# taking the mean and convert for ggplot to data.frame
mean_corrs <- data.frame(rowMeans(corrs))
seq_provs <- seq(1, ncol(corrs), 1) # numeric sequence for xticks

# plot corrs per province
ggplot(mean_corrs,
       aes(x = seq_provs, y = rowMeans.corrs.)) +
  geom_point(size=3) +
  geom_line(size=1) +
  theme_bw() +
  scale_x_discrete("Province", seq_provs,
                   pnames[, 2], as.factor(seq_provs)) +
  labs(x="Province", y = "Mean Correlation", title =
      "Mean Province Correlation") +
  theme(plot.title=element_text(size = 12,
                                hjust = 0.5),
        axis.text.x = element_text(size = 9, angle = 90,
                                   vjust = 0.6))

# saving the plot
ggplot2::ggsave(filename = "figs/cases_mcorrs.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)


# taking out Formosa to plot again
mean_corrs_sf <- data.frame(mean_corrs[-9, ]) # eliminating Formosa
seq_provs_sf <- seq(1, ncol(corrs)-1, 1) # new province seq for xticks
names(seq_provs_sf) <- 'rowMeans.corrs.' #correcting new name

# plot corrs per province
ggplot(mean_corrs_sf,
       aes(x = seq_provs_sf, y = mean_corrs..9...)) +
  geom_point(size=3) +
  geom_line(size=1) +
  theme_bw() +
  scale_x_discrete("Province", seq_provs_sf,
                   pnames[-9, 2], as.factor(seq_provs_sf)) +
  labs(x="Province", y = "Mean Correlation", title =
         "Mean Province Correlation (minus Formosa)") +
  theme(plot.title=element_text(size = 12,
                                hjust = 0.5),
        axis.text.x = element_text(size = 9, angle = 90,
                                   vjust = 0.6))

# saving the plot
ggplot2::ggsave(filename = "figs/cases_mcorrs_sf.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)

# Mean Lags ------------------------------------------------

# taking the mean and convert for ggplot to data.frame
mean_lags <- data.frame(rowMeans(lags))

# plot mean lag per province
ggplot(mean_lags,
       aes(x = seq_provs, y = rowMeans.lags.)) +
  geom_point(size=3) +
  geom_line(size=1) +
  theme_bw() +
  scale_x_discrete("Province", seq_provs,
                   pnames[, 2], as.factor(seq_provs)) +
  labs(x="Province", y = "Mean Lag", title =
         "Mean Province Lag") +
  theme(plot.title=element_text(size = 12,
                                hjust = 0.5),
        axis.text.x = element_text(size = 9, angle = 90,
                                   vjust = 0.6))

# saving the plot
ggplot2::ggsave(filename = "figs/cases_mlags.png",
                dpi = 300,
                units = "in",
                width = 5.5,
                height = 4.5)



