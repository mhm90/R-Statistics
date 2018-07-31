### KNN

source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

library(class)

set.seed(4135)
rand = runif(NROW(data))
shuffle = order(rand)
shuffledData = data.frame(data[shuffle, ])

n = NROW(shuffledData) - 100
i = n + 1
trainData = shuffledData[1:n, !names(data) %in% c("Reason.f.", "ID.f", "Reason.ICD.Disease")]
testData = shuffledData[c(i:NROW(shuffledData)), !names(data) %in% c("Reason.f.", "ID.f", "Reason.ICD.Disease")]

set.seed(87654)
knnPred = knn(trainData, testData, shuffledData$Reason.f.[c(1:n)], k=15)
confTable = table(knnPred, shuffledData$Reason.f.[c(i:NROW(shuffledData))])
cat("Confusion Table\n")
print(confTable)
#Accuracy
acc = mean(knnPred == shuffledData$Reason.f.[c(i:NROW(shuffledData))])
print(sprintf("Accuracy on test data: %f", acc))
