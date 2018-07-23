#install.packages('mclust')
if (!exists("data", mode="list") || exists("rowsToDelete", mode = "numeric")) source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

library(cluster)

class(data)
#trace("colMeans", quote(names(x)))
pcaData = data.matrix(data[, !names(data) %in% c("Reason.f.", "ID.f")])
class(pcaData)
pca = prcomp(pcaData, scale. = TRUE)
pca$x
summary(pca)
biplot(pca, scale = 1)
plot(pca, type = 'l', "Covered Variance Proportion over PCA Components")

### Clustering

clustData = data.matrix(data[, !names(data) %in% c("Reason.f.", "ID.f")])
length(levels(data$Reason.f.))

## K-Means
kMeans = kmeans(clustData, centers = length(levels(data$Reason.f.)), nstart = 10)
print(kMeans)
plot(clustData, col = kMeans$cluster)
plot(clustData, col = data$Reason.f.)

kMeans$centers
kMeans$cluster
kMeans$size

points(kMeans$centers, pch=3, cex=2, col="black")
#text(kMeans$centers, labels=c("a","b","c","d"), pos=2)

## Hierarchical Clustering
dists = dist(clustData)

hCluster = hclust(dists, method = "single")
plot(hCluster)
rect.hclust(hCluster, k = length(levels(data$Reason.f.)), border="red")

## Model-Based Clustering
require(mclust)

mCluster = Mclust(clustData)
summary(mCluster)

plot(mCluster, what = "classification")

mc1=Mclust(clustData, G=3)
summary(mc1)
plot(mc1, what = "classification")