#install.packages("e1071")
install.packages('gplots')

require(caTools)
require(e1071)
library(gplots)

source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

### ===== SVM =====
# with 10-fold CV
# More than 2 class: 1 vs 1 approach
svmFit = svm(Reason.f. ~ . , data = data, cross = 10)
summ = summary(svmFit)
summ

# Check accuracy
pred = predict(svmFit, subset(data, select = -Reason.f.), decision.values = TRUE)
#View(pred)
attr(pred, "decision.values")

plot(cmdscale(dist(subset(data, select = -Reason.f.))), # projecting feature space to 2d Dimension
     col = as.integer(data$Reason.f.),
     pch = c("o","+")[1:NROW(data) %in% svmFit$index + 1])

# Confusion Table
table(pred, data$Reason.f.)
# Accuracy On Original Data
mean(pred ==  data$Reason.f.)

### Tuned SVM
set.seed(24562)
split = sample.split(data$Reason.f., SplitRatio = 0.8)

trainSet = subset(data, split)
testSet = subset(data, !split)

## Linear Kernel
tunedSvm = tune(svm, Reason.f. ~ . , data = trainSet, kernel = "linear", ranges = list(cost=c(0.001, 0.01, 0.1, 1,5,10,100)))
summary(tunedSvm)
bestmod = tunedSvm$best.model
summary(bestmod)
bestmod$cost
bestmod$degree
bestmod$gamma
bestmod$epsilon

#Accuracy of training data in tuning
predTunedSVM = predict(bestmod, trainSet)
table(predict = predTunedSVM, truth = trainSet$Reason.f.)
mean(predTunedSVM == trainSet$Reason.f.)

#Accuracy of test data in tuning
predTunedSVM = predict(bestmod, testSet)
table(predict = predTunedSVM, truth = testSet$Reason.f.)
mean(predTunedSVM == testSet$Reason.f.)


## Radial Kernel
tunedSvm = tune(svm, Reason.f. ~ . , data = trainSet, kernel = "radial", ranges = list(cost=c(0.001, 0.01, 0.1, 1,5,10,100)))
summary(tunedSvm)
bestmod = tunedSvm$best.model
summary(bestmod)
bestmod$cost
bestmod$degree
bestmod$gamma
bestmod$epsilon

#Accuracy of training data in tuning
predTunedSVM = predict(bestmod, trainSet)
table(predict = predTunedSVM, truth = trainSet$Reason.f.)
mean(predTunedSVM == trainSet$Reason.f.)

#Accuracy of test data in tuning
predTunedSVM = predict(bestmod, testSet)
table(predict = predTunedSVM, truth = testSet$Reason.f.)
mean(predTunedSVM == testSet$Reason.f.)
