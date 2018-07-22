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

clustData = data.matrix(data[, !names(data) %in% c("Reason.f.", "ID.f")])

kMeans = kmeans(clustData, centers = length(levels(data$Reason.f.)), nstart = 10)
print(kMeans)
plot(clustData, col = kMeans$cluster)
plot(clustData, col = data$Reason.f.)

