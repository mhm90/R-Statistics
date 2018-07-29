#install.packages('mclust')
source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

library(cluster)
### Clustering

clustData = data.matrix(data[, !names(data) %in% c("Reason.f.", "ID.f")])
k = length(levels(data$Reason.f.))

### K-Means
kMeans = kmeans(clustData, centers = k, nstart = 10)
print(kMeans)
plot(clustData, col = kMeans$cluster)
plot(clustData, col = data$Reason.f.)

kMeans$centers
kMeans$cluster
kMeans$size

points(kMeans$centers, pch=3, cex=2, col="black")
#text(kMeans$centers, labels=c("a","b","c","d"), pos=2)

### Hierarchical Clustering
dists = dist(clustData)

hCluster = hclust(dists, method = "single")
plot(hCluster)
rect.hclust(hCluster, k = k, border="red")

### Model-Based Clustering
require(mclust)

mCluster = Mclust(clustData)
summary(mCluster)

plot(mCluster, what = "classification")

mc1=Mclust(clustData, G=3)
summary(mc1)
plot(mc1, what = "classification")