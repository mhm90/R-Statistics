#install.packages('tree')
#install.packages("C50")
#install.packages("randomForest")
#install.packages("rpart")
#install.packages("rpart.plot")


if (!exists("data", mode="list") || exists("rowsToDelete", mode = "numeric")) source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

### Split Data
#Shuffling data
set.seed(512)
rand = runif(NROW(data))
shuffle = order(rand)
shuffledData = data.frame(data[shuffle, ])

n = NROW(shuffledData) - 100
i = n + 1
trainData = shuffledData[1:n, ]
testData = shuffledData[c(i:NROW(shuffledData)), ]

### Simple Tree
library(tree)

treeFit = tree(trainData$Reason.f. ~ . -ID.f , data = trainData)
summary(treeFit)
plot(treeFit); text(treeFit, pretty = 0)

prediction = predict(treeFit, newdata = trainData, type = "class")
plot(prediction)

# Train error
table(prediction, trainData$Reason.f.)
# Tarin Accuracy
mean(prediction == trainData$Reason.f.)

prediction = predict(treeFit, newdata = testData, type = "class")
# Train error
table(prediction, testData$Reason.f.)
# Tarin Accuracy
mean(prediction == testData$Reason.f.)

cvTree = cv.tree(treeFit, FUN = prune.misclass, K = 5)
plot(cvTree)

prunedTree = prune.misclass(treeFit, best = 6)
plot(prunedTree); text(prunedTree, pretty = 0)

### Decision Tree
library("C50")
x =  trainData[, !(names(trainData) %in% c("Reason.f.", "ID.f"))]
C5Fit = C5.0(x = x, y = trainData$Reason.f.)
summary(C5Fit)
plot(C5Fit)

# Test Error
predC5 = predict(C5Fit, testData)
table(predC5, testData$Reason.f.)
# Accuracy
mean(predC5 == testData$Reason.f.)

### Recursive Tree
library("rpart")
library("rpart.plot")

rTree = rpart(Reason.f. ~ . -ID.f , data = trainData, method = "class")
summary(rTree)
rpart.plot(rTree)

prediction = predict(rTree, newdata = testData, type = "class")
plot(prediction)


