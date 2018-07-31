usePlot = FALSE
source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

class(data)
#trace("colMeans", quote(names(x)))

pcaData = data.matrix(data[, !names(data) %in% c("Reason.f.", "ID.f")])
class(pcaData)
pca = prcomp(pcaData, scale. = TRUE)
pca$x
print(summary(pca))
biplot(pca, scale = 1, main = "Feature transformation  using PCA")
plot(pca, type = 'l', main = "Covered Variance Proportion over PCA Components")
