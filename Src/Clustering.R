if (!exists("data", mode="list") || exists("rowsToDelete", mode = "numeric")) source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

library(cluster)

class(data)
pca = prcomp(data.frame(data), scale. = TRUE)
pca
