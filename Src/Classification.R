if (!exists("data", mode="list")) source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

# Coding reasons with ICD diseases or other reasons
# 0 -> Other reasons
# 1 -> ICD Diseases
icdCodes = c("I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX", "XXI")
data$Reason.ICD.Disease = factor(ifelse(data$Reason.f. %in% icdCodes, yes = 1, no = 0), levels = c(0,1), labels = c("Other", "ICD"))

pairs(data, col = data$Reason.ICD.Disease)

K = 10
folds <- cvFolds(NROW(data), K = K)

for(i in 1:K) {
  train = data[folds$subsets[folds$which != i] , ] 
  validation = data[folds$subsets[folds$which == i], ] 
  
  glmFit = glm(Reason.ICD.Disease ~ . - Reason.f. - ID.f, data = train, family = binomial())
  a = alias(glmFit)
  summary(glmFit)
  
  pred = predict(glmFit, newdata = validation, type='response')
  predRes = ifelse(pred > 0.5, 'ICD','Other')
  
  # TP, FP table
  confTable = table(predRes, data$Reason.ICD.Disease)
  #View(confTable)
  
  # Accuracy
  mean(predRes == data$Reason.ICD.Disease)

}

#install.packages("pROC")
require(pROC)

rocCurve = roc(response = data$Reason.ICD.Disease, fitted.values(glmFit), ci = TRUE, ci.alpha = 0.9,
               partial.auc=c(0.9, 1), partial.auc.correct=TRUE, partial.auc.focus="sens",
               plot = TRUE, auc.polygon=TRUE, max.auc.polygon=TRUE, grid=TRUE,
               print.auc=TRUE, show.thres=TRUE, reuse.auc = TRUE)
plot(rocCurve)

coords(rocCurve, "best", ret=c("threshold", "specificity", "1-npv"))

sens.ci <- ci.se(rocCurve, specificities = seq(0, 1, 0.1))
plot(sens.ci, type="shape", col="lightblue")
plot(sens.ci, type="bars")

plot(ci.thresholds(rocCurve))
