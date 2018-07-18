install.packages("e1071")
require(caTools)
require(e1071)

if (!exists("data", mode="list")) source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

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
#Accuracy
mean(pred ==  data$Reason.f.)

tunedSvm = tune(svmFit, Reason.f. ~ . , data = data, kernel = "linear", ranges = list(cost=c(0.001, 0.01, 0.1, 1,5,10,100)))
