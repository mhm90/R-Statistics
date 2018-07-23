if (!exists("data", mode="list") || exists("rowsToDelete", mode = "numeric")) source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

class(data)
#trace("colMeans", quote(names(x)))

pcaData = data.matrix(data[, !names(data) %in% c("Reason.f.", "ID.f")])
class(pcaData)
pca = prcomp(pcaData, scale. = TRUE)
pca$x
summary(pca)
biplot(pca, scale = 1)
plot(pca, type = 'l', "Covered Variance Proportion over PCA Components")
