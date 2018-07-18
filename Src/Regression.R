#install.packages("glmnet") # For Ridge & Lasso
#install.packages("ggplot2")
# check for data
if (!exists("data", mode="list") || exists("rowsToDelete", mode = "numeric")) source("./Src/Basics.R", local = TRUE, echo = FALSE)

singleReg = function(x, y, data, ...) {
  fit = lm(y ~ x, data = data)
  summary(fit)
  plot(x, y, ...)
  #points(data$`Absenteeism time in hours`,fitted(fit),col="red",pch=20,cex=0.9)
  abline(fit, col = "green")
}

for (i in 1:NCOL(data)) {
  singleReg(data[[i]], data$`Absenteeism time in hours`, data = data, xlab=names(data)[i])
}
summary(data)

plot(`Absenteeism time in hours` ~ ID.f, data = data)
plot(`Absenteeism time in hours` ~ Season.f, data = data)
plot(`Absenteeism time in hours` ~ Month.f, data = data)
plot(`Absenteeism time in hours` ~ WeekDay.f, data = data)
plot(`Absenteeism time in hours` ~ `Transportation expense`, data = data)
plot(`Absenteeism time in hours` ~ `Distance from Residence to Work`, data = data)
plot(`Absenteeism time in hours` ~ `Service time`, data = data)
plot(`Absenteeism time in hours` ~ Age, data = data)
plot(`Absenteeism time in hours` ~ `Work load Average/day`, data = data)
plot(`Absenteeism time in hours` ~ `Hit target`, data = data)
plot(`Absenteeism time in hours` ~ `Disciplinary failure`, data = data)
plot(`Absenteeism time in hours` ~ Education, data = data)
plot(`Absenteeism time in hours` ~ Son, data = data)
plot(`Absenteeism time in hours` ~ `Social drinker`, data = data)
plot(`Absenteeism time in hours` ~ `Social smoker`, data = data)
plot(`Absenteeism time in hours` ~ Pet, data = data)
plot(`Absenteeism time in hours` ~ Weight, data = data)
plot(`Absenteeism time in hours` ~ Height, data = data)
plot(`Absenteeism time in hours` ~ `Body mass in  dex`, data = data)
plot(`Absenteeism time in hours` ~ Reason.f., data = data)
plot(`Absenteeism time in hours` ~ `Reason for absence`, data = data)

### ========== Single Regression ==========

### Wrong way
regFit = lm(`Absenteeism time in hours` ~ `Reason for absence`, data = data)
summary(regFit)
abline(regFit, col = "red")

### Right Way
# https://stats.idre.ucla.edu/r/modules/coding-for-categorical-variables-in-regression-models/
# https://stats.idre.ucla.edu/r/library/r-library-contrast-coding-systems-for-categorical-variables/

regFit = lm(`Absenteeism time in hours` ~ `Reason.f.`, data = data)

summary(regFit)
abline(regFit, col = "blue")

plot(regFit)
confint(regFit)

#predict(regFit, data.frame(), interval = "confidence")

### ========== Multiple Regression ==========

# Removing original categorical features
# Removing extra features: Season (can be evaluated by Month), BMI (can be evaluated by Weight & Height)
removeCols = c("ID", "Reason for absence", "Month of absence", "Day of the week", "Seasons", "Season.f", "Body mass index")
data = data[ , !(names(data) %in% removeCols)]

# Regression with all features
fitFull = lm(`Absenteeism time in hours` ~ . , data = data)
summary(fitFull)
#plot(fitFull)

fit1 = update(fitFull, . ~ . - ID.f , data = data)
summary(fit1)

fit2 = update(fit1, . ~ . - Reason.f. , data = data)
summary(fit2)

fit3 = update(fit2, . ~ . - Month.f , data = data)
summary(fit3)

plot(data$`Absenteeism time in hours` ~ ., data = data)
points(data$`Absenteeism time in hours`,fitted(fit3),col="red",pch=20,cex=2)


### ========== Subset Selection (with Validation Set) ==========
require(caTools)
# Validation Split
set.seed(652)
splitTrain = sample.split(data$`Absenteeism time in hours`, SplitRatio = 0.5)

trainData = subset(data, splitTrain)
testData = subset(data, !splitTrain)

# Subset Selection
regNull = lm(data$`Absenteeism time in hours` ~ 1, data = data)
regFull = lm(data$`Absenteeism time in hours` ~ ., data = data)

summary(regNull)

adjRSq = list()
i = 1
### ===== Best model by AIC =====

# Forward
forwardStepAIC = 
  step(regNull,
    scope = list(upper=regFull),
    direction="forward",
    trace = TRUE,
    k = 2,        # AIC parameter
    test="Chisq", # Chi Square test
    data=trainData)

summ = summary(forwardStepAIC)
summ
forwardRegAIC = lm(forwardStepAIC[["terms"]], data = data)
adjRSq[[i]] = summ$adj.r.squared
i = i + 1

# Backward
backwardStepAIC = 
  step(regFull,
       scope = list(lower=regNull),
       direction="backward",
       trace = TRUE,
       k = 2,        # AIC parameter
       test="Chisq", # Chi Square test
       data=trainData)

summ = summary(backwardStepAIC)
summ
backwardRegAIC = lm(backwardStepAIC[["terms"]], data = data)
adjRSq[[i]] = summ$adj.r.squared
i = i + 1

# Both
bidirStepAIC = 
  step(regNull,
       scope = list(upper=regFull),
       direction="both",
       trace = TRUE,
       k = 2,        # AIC parameter
       test="Chisq", # Chi Square test
       data=trainData)

summ = summary(bidirStepAIC)
summ
bidirRegAIC = lm(bidirStepAIC[["terms"]], data = data)
adjRSq[[i]] = summ$adj.r.squared
i = i + 1

### ===== Best model by BIC =====

BIC_Param = log2(NROW(data))

# Forward
forwardStepBIC = 
  step(regNull,
       scope = list(upper=regFull),
       direction="forward",
       trace = TRUE,
       k = BIC_Param,
       test="Chisq", # Chi Square test
       data=trainData)

summ = summary(forwardStepBIC)
summ
forwardRegBIC = lm(forwardStepAIC[["terms"]], data = data)
adjRSq[[i]] = summ$adj.r.squared
i = i + 1

# Backward
backwardStepBIC = 
  step(regFull,
       scope = list(lower=regNull),
       direction="backward",
       trace = TRUE,
       k = BIC_Param,
       test="Chisq", # Chi Square test
       data=trainData)

summ = summary(backwardStepBIC)
summ
backwardRegBIC = lm(backwardStepBIC[["terms"]], data = data)
adjRSq[[i]] = summ$adj.r.squared
i = i + 1

# Both
bidirStepBIC = 
  step(regNull,
       scope = list(upper=regFull),
       direction="both",
       trace = TRUE,
       k = BIC_Param,
       test="Chisq", # Chi Square test
       data=trainData)

summ = summary(bidirStepBIC)
summ
bidirRegBIC = lm(bidirStepBIC[["terms"]], data = data)
adjRSq[[i]] = summ$adj.r.squared
i = i + 1

### ===== Result: =====
models = list(forwardRegAIC, backwardRegAIC, bidirRegAIC, forwardRegBIC, backwardRegBIC, bidirRegBIC)
modelNames = c("Forward AIC", "Backward AIC", "Bidir AIC", "Forward BIC", "Backward BIC", "Bidir BIC")
testMse = list()
for (i in 1:length(models)) {
  resp = predict(models[[i]], newdata = testData, type = "response")
  testMse[i] = mean((testData$`Absenteeism time in hours` - resp)^2)
}

barplot(unlist(testMse), names = modelNames, ylab = "Test MSE", xlab = "Best Fitted Model")

# Adj R Squared
for (i in 1:length(adjRSq)) {
  if (is.null(adjRSq[[i]])) {
    adjRSq[[i]] = -0.0001;
  }
}
barplot(unlist(adjRSq), names = modelNames, ylab = "Adjusted R Squared", xlab = "Best Fitted Model")

### ========== Ridge & Lasso + Cross Validation ==========

#l1ce()
#lm.ridge

require(glmnet)

X = data.matrix(data[, setdiff(colnames(data), "Absenteeism time in hours")])
# Ridge
ridgeReg = glmnet(X, data$`Absenteeism time in hours`, alpha = 0)
plot(ridgeReg, main = "Ridge Regression against lambda Value")
ridgeReg = cv.glmnet(X, data$`Absenteeism time in hours`, alpha = 0)
plot(ridgeReg, main = "Cross Validated MSE over Ridge lambda Value")
coef.cv.glmnet(ridgeReg, s = "lambda.min")

# Lasso
lassoReg = glmnet(X, data$`Absenteeism time in hours`, alpha = 1)
plot(lassoReg, main = "Lasso Regression against lambda Value")
lassoReg = cv.glmnet(X, data$`Absenteeism time in hours`, alpha = 1)
plot(lassoReg, main = "Cross Validated MSE over Lasso lambda Value")
coef.cv.glmnet(lassoReg, s = "lambda.min")

summary(lassoReg)

### Test
#k = 10
#folds = cvFolds(NROW(data), K=k)
#createFolds
#apply
#?points
#?colMeans
#sapply
