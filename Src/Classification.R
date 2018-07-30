#install.packages("cvTools")
require(cvTools)

source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

### Logestic Regression

# Coding reasons with ICD diseases or other reasons
# 0 -> Other reasons
# 1 -> ICD Diseases
icdCodes = c("I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX", "XXI")
data$Reason.ICD.Disease = factor(ifelse(data$Reason.f. %in% icdCodes, yes = 1, no = 0), levels = c(0,1), labels = c("Other", "ICD"))

pairs(data, col = data$Reason.ICD.Disease)

K = 10
folds = cvFolds(NROW(data), K = K)
misClassifications = c()
fitLogits = c()
removedFeatures = c("Reason.f.", "ID.f")
minMisClassificationGlm = NULL
minMisClass = 10000
for(i in 1:K) {
  train = data[folds$subsets[folds$which != i] , !(names(data) %in% removedFeatures)] 
  validation = data[folds$subsets[folds$which == i], !(names(data) %in% removedFeatures)] 
  
  glmFit = glm(Reason.ICD.Disease ~ . , data = train, family = binomial())
  a = alias(glmFit)
  summary(glmFit)
  
  pred = predict(glmFit, newdata = validation, type='response')
  predRes = ifelse(pred > 0.5, 'ICD','Other')
  
  # TP, FP, TN, FN table
  cat(sprintf("Confusion Table for fold[%d]", i))
  confTable = table(predRes, validation$Reason.ICD.Disease)
  print(confTable)
  #View(confTable)
  
  # Accuracy
  acc = mean(predRes == validation$Reason.ICD.Disease)
  cat(sprintf("Accuracy[%d] = %f \n\n", i, acc))
  
  misClass = mean(predRes != validation$Reason.ICD.Disease)
  misClassifications = append(misClassifications, misClass)
  if (misClass < minMisClass) {
    minMisClass = misClass
    minMisClassificationGlm = glmFit
  }
}
mean(misClassifications)

summary(minMisClassificationGlm)
glmFit = minMisClassificationGlm
fittedProbs = predict(glmFit, newdata = data, type='response')

### Finding best threshold by ROC curve
#install.packages("pROC")
require(pROC)

rocCurve = roc(response = data$Reason.ICD.Disease, fittedProbs, ci = TRUE, ci.alpha = 0.9,
               partial.auc=c(0.9, 1), partial.auc.correct=TRUE, partial.auc.focus="sens",
               plot = TRUE, auc.polygon=TRUE, max.auc.polygon=TRUE, grid=TRUE,
               print.auc=TRUE, show.thres=TRUE, reuse.auc = TRUE)
plot(rocCurve)

coords(rocCurve, "best", ret=c("threshold", "specificity", "1-npv"))

sens.ci = ci.se(rocCurve, specificities = seq(0, 1, 0.1))
plot(sens.ci, type="shape", col="lightblue")
plot(sens.ci, type="bars")

plot(ci.thresholds(rocCurve))


### KNN
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
table(knnPred, shuffledData$Reason.f.[c(i:NROW(shuffledData))])
#Accuracy
mean(knnPred == shuffledData$Reason.f.[c(i:NROW(shuffledData))])

