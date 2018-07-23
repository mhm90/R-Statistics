#install.packages('tree')
#install.packages("C50")
#install.packages("randomForest")
#install.packages("rpart")
#install.packages("rpart.plot")

if (!exists("data", mode="list")) source("./Src/MultiClassPreprocess.R", local = TRUE, echo = FALSE)

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
# Test error
table(prediction, testData$Reason.f.)
# Test Accuracy
mean(prediction == testData$Reason.f.)

cvTree = cv.tree(treeFit, FUN = prune.misclass, K = 5)
plot(cvTree)
print(cvTree)

prunedTree = prune.misclass(treeFit, best = 6)
plot(prunedTree); text(prunedTree, pretty = 0)

prediction = predict(prunedTree, newdata = trainData, type = "class")
# Train error
table(prediction, trainData$Reason.f.)
# Tarin Accuracy
mean(prediction == trainData$Reason.f.)

prediction = predict(treeFit, newdata = testData, type = "class")
# Test error
table(prediction, testData$Reason.f.)
# Test Accuracy
mean(prediction == testData$Reason.f.)

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

pcaTrain = data.frame(x = pcaData[1:n, ], y = data$Reason.f.[1:n])
pcaTest = data.frame(x = pcaData[i:NROW(pcaData), ], y = data$Reason.f.[i:NROW(pcaData)])
rTree = rpart(y ~ . , data = pcaTrain, method = "class")
summary(rTree)
rpart.plot(rTree)

predictRPart = predict(rTree, newdata = pcaTest, type = "class")
plot(predictRPart)
# Confusion Table
table(predictRPart, testData$Reason.f.)
# Accuracy
mean(predictRPart == testData$Reason.f.)

### Random Forest
library(randomForest)
randForestFit = randomForest(Reason.f. ~ . -ID.f , data = trainData, ntree = 1000, importance = TRUE, proximity = TRUE)
print(randForestFit)

round(importance(randForestFit), 2)
# Do MDS on 1 - proximity:
dataMds = cmdscale(1 - randForestFit$proximity, eig=TRUE)
op = par(pty = "s")
pairs(cbind(subset(trainData, select = -Reason.f.), dataMds$points), cex=0.6, gap=0,
      col=c("red", "green", "blue")[as.numeric(trainData$Reason.f.)],
      main="Predictors and MDS of Proximity Based on RandomForest")
par(op)
print(dataMds$GOF)

# Choose model
plot(randForestFit)

predictionRF = predict(randForestFit, newdata = trainData, type = "class")
plot(predictionRF)

# Train error
table(predictionRF, trainData$Reason.f.)
# Tarin Accuracy
mean(predictionRF == trainData$Reason.f.)

predictionRF = predict(randForestFit, newdata = testData, type = "class")
# Test error
table(predictionRF, testData$Reason.f.)
# Test Accuracy
mean(predictionRF == testData$Reason.f.)
