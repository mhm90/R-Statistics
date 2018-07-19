#install.packages('tree')
if (!exists("data", mode="list") || exists("rowsToDelete", mode = "numeric")) source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

library(tree)

#Shuffling data
set.seed(512)
rand = runif(NROW(data))
shuffle = order(rand)
shuffledData = data.frame(data[shuffle, ])

n = NROW(shuffledData) - 100
trainData = shuffledData[1:n,]
testData = shuffledData[n+1:NROW(shuffledData),]

treeFit = tree(trainData$Reason.f. ~ . -ID.f , data = trainData)
summary(treeFit)
plot(treeFit)
text(treeFit, pretty = 0)

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
cv.tree