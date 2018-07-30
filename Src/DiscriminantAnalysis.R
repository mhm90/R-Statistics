require(MASS) #LDA & QDA

# Preprocess data
source("./Src/PCA.R", local = TRUE, echo = FALSE)

# Features to remove (less important PCA component)
toRemoveComps = c(9:17)
daData = data.frame(y = data$Reason.f., x = pca$x[, -toRemoveComps])
# Removing classes with less than 10 samples
freq = table(daData$y)

rowsToDelete = c()
for (i in 1:NROW(daData)) {
  if (freq[[daData$y[i]]] < 30) {
    rowsToDelete = append(rowsToDelete, i)
  }
}

# Removing samples with low class rate
daData = daData[-rowsToDelete, ]
daData$y = factor(daData$y)

### ===== LDA =====
ldaFit = lda(y ~ . , data = daData)
summary(ldaFit)

ldaPred = predict(ldaFit, newdata = daData)
summary(ldaPred)

confusionTable = table(ldaPred$class, daData$y)
confusionTable

#Accuracy
mean(ldaPred$class ==  daData$y)

View(ldaPred$posterior)
names(ldaPred$posterior[1,])

summary(ldaPred$posterior)


### ===== QDA =====
qdaFit = qda(ldaFit[["terms"]], data = daData)
summary(qdaFit)

qdaPred = predict(qdaFit, newdata = daData)
summary(qdaPred)

confusionTable = table(qdaPred$class, daData$y)
confusionTable

#Accuracy
mean(qdaPred$class ==  daData$y)

summary(qdaPred$posterior)

