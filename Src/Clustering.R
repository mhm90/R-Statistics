#install.packages('mclust')
source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

library(cluster)
### Clustering

clustData = data.matrix(data[, !names(data) %in% c("Reason.f.", "ID.f")])
k = length(unique(levels(data$Reason.f.)))

### K-Means
kMeans = kmeans(clustData, centers = k, nstart = 10)
print(kMeans)
plot(clustData, col = kMeans$cluster, main = sprintf("Coloring data projection in 2D by K-Means clusters (K=%d)", k))
plot(clustData, col = data$Reason.f., main = "Coloring data projection in 2D by data classes (Reason for Absence)")

print(kMeans$centers)
print(kMeans$cluster)
print(kMeans$size)

points(kMeans$centers, pch=3, cex=2, col="black")
#text(kMeans$centers, labels=c("a","b","c","d"), pos=2)

### Hierarchical Clustering
cat("\n\n\n\n Hierarchical Clustering\n")
cat("    Calculating distances")

dists = dist(clustData)

hCluster = hclust(dists, method = "single")
print(summary(hCluster))
plot(hCluster, main = sprintf("Hierarchical Clustering of data (Red boxes indicate clusters with k=%d)", k))
rect.hclust(hCluster, k = k, border="red")

### Model-Based Clustering
require(mclust)
cat("\n\n\n\n Model-Based Clustering \n\n")
mCluster = Mclust(clustData)
print(summary(mCluster))

plot(mCluster, what = "classification", main = "Model based Clustering")

mc1=Mclust(clustData, G=k)
print(summary(mc1))
plot(mc1, what = "classification", main = sprintf("Model based Clustering (Groups = %d)", k))
