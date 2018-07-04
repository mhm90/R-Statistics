# check for data
if (!exists("data", mode="list")) source("./Src/Basics.R", local = TRUE, echo = FALSE)

plot(`Absenteeism time in hours` ~ `Reason.f`, data = data)

### ========== Single Regression ==========

### Wrong way
regFit = lm(`Absenteeism time in hours` ~ `Reason for absence`, data = data)
summary(regFit)
abline(regFit, col = "red")

### Right Way
# https://stats.idre.ucla.edu/r/modules/coding-for-categorical-variables-in-regression-models/
# https://stats.idre.ucla.edu/r/library/r-library-contrast-coding-systems-for-categorical-variables/

regFit = lm(`Absenteeism time in hours` ~ `Reason.f`, data = data)
summary(regFit)
abline(regFit, col = "blue")

confint(regFit)

#predict(regFit, data.frame(), interval = "confidence")

### ========== Multiple Regression ==========

fitFull = lm(`Absenteeism time in hours` ~ . -ID - `Reason for absence` - `Month of absence` -`Day of the week` - Seasons, data = data)
summary(fitFull)
#plot(fitFull)

fit1 = update(fitFull, . ~ . - ID.f , data = data)
summary(fit1)

fit2 = update(fit1, . ~ . - Season.f , data = data)
summary(fit2)

fit3 = update(fit1, . ~ . - Reason.f. , data = data)
summary(fit3)

fit4 = update(fit3, . ~ . - Month.f , data = data)
summary(fit4)

fit5 = update(fit4, . ~ . - Season.f , data = data)
summary(fit5)

### ========== Subset Selection ==========

k = 10
folds <- cvFolds(NROW(data), K=k)
