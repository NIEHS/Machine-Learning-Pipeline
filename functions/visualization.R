# Compare PCA with t-SNE


visualization <- function(dataIn) {

library(caret)
library(Rtsne)
library(ggplot2)
library(grid)
library(gridExtra)


# dataIn must have a column called 'toPredict' which is a 2-factor variable and everything else should be numeric
# standarize data to mean 0 and SD 1

toPredictColumnToAddBack <- subset(dataIn, select =  c(toPredict))
dataOnly                 <- subset(dataIn, select = -c(toPredict))
dataScaled               <- as.data.frame(scale(dataOnly))
dataFinal                <- cbind(toPredictColumnToAddBack, dataScaled)

print('Data has been scaled to mean 0 and standard deviation 1 (also known as Z-scaling for data visualization)')


################################  T-SNE  ###########################################################

# variable to be predicted must be 'toPredict' and must be a 2-level factor variable

## for plotting
colors = rainbow(length(unique(dataFinal$toPredict)))
names(colors) = unique(dataFinal$toPredict)

PERPLEXITY <- 100
ITERATIONS <- 500
## Executing the algorithm on curated data
tsne <- Rtsne(dataFinal[,-1], dims = 2, perplexity = PERPLEXITY, verbose=TRUE, max_iter = ITERATIONS)

tsne_plot <- data.frame(x = tsne$Y[,1], y = tsne$Y[,2])

p <- ggplot(tsne_plot) +
     geom_point(aes(x = x, y = y, color = dataRaw$toPredict)) +
     ggtitle(paste0('T-SNE plot with ', nrow(dataFinal), ' datapoints'))

print(p)

# plot(tsne$Y, t='n', main=paste0('tsne: perplexity=',PERPLEXITY, '   iterations=', ITERATIONS))
# text(tsne$Y, labels=dataFinal$toPredict, col=colors[dataFinal$toPredict])

# #################################  PCA with ggplot  ###############################################

pca1 <- prcomp(dataFinal[, -1])

df_out <- as.data.frame(pca1$x)
df_out$group <- dataFinal$toPredict

p <- ggplot(df_out,aes(x=PC1,y=PC2,color=group ))
p <- p + geom_point() +
     ggtitle(paste0('PCA plot with ', nrow(dataFinal), ' datapoints'))
print(p)

#####################################################################################################
# Uncomment to get really good illustration of PCA vs T-SNE

# https://www.analyticsvidhya.com/blog/2017/01/t-sne-implementation-r-python/
# Download MNIST data from above and save to disk

#####################  MNIST DATA  ###########################
# images are 28 x 28 = 784 pixels
# Data is not transformed here since all data is on the same scale (0 - 255)
#
# DRIVE_LETTER <- 'C:/'
# DATA_PATH    <- 'Google Drive/R/caret/Generic Caret Workflow/00_release/newest/t_sne_data/'
#
# dataTemp <- read.csv(paste0(DRIVE_LETTER, DATA_PATH, 'train_nmist_tsne.csv'))
# dim(dataTemp)
#
# # There are 10K numbers which is fine for t-sne, but PCA is way too dense
# # Drop to 5K numbers which helps a bit
#
# dataRaw <- dataTemp[1:5000,]
# dim(dataRaw)
#
# # Labels        <- dataRaw$label
# dataRaw$label <- as.factor(dataRaw$label)
#
# ## for plotting
# colors = rainbow(length(unique(dataRaw$label)))
# names(colors) = unique(dataRaw$label)
#
# PERPLEXITY <- 100
# ITERATIONS <- 500
#
# ## Executing the algorithm on  data
# tsne <- Rtsne(dataRaw[,-1], dims = 2, perplexity = PERPLEXITY, verbose=TRUE, max_iter = ITERATIONS)
#
# tsne_plot <- data.frame(x = tsne$Y[,1], y = tsne$Y[,2], col = dataRaw$label)
# ggplot(tsne_plot) + geom_point(aes(x = x, y = y, color = col)) +
#     ggtitle(paste0('T-SNE plot with ', nrow(dataRaw), ' datapoints'))
#
#
# # now create PCA plot
#
# pca1 <- prcomp(dataRaw[, -1])
#
# df_out <- as.data.frame(pca1$x)
# df_out$group <- dataRaw$label
#
# p <- ggplot(df_out,aes(x=PC1,y=PC2,color=group ))
# p <- p + geom_point() +
#     ggtitle(paste0('PCA plot with ', nrow(dataRaw), ' datapoints'))
#
# print(p)


}  # end of function
