require(MASS) #LDA & QDA

if (!exists("data", mode="list") source("./Src/Preprocess.R", local = TRUE, echo = FALSE)


### ===== LDA =====
ldaFit = lda(data$Reason.f. ~ . - ID.f, data = data)
summary(ldaFit)

ldaPred = predict(ldaFit, newdata = data)
summary(ldaPred)

confusionTable = table(ldaPred$class, data$Reason.f.)
confusionTable

#Accuracy
mean(ldaPred$class ==  data$Reason.f.)

#View(ldaPred$posterior)
names(ldaPred$posterior[1,])

summary(ldaPred$posterior)


### ===== QDA =====
qdaFit = qda(ldaFit[["terms"]], data = data)
summary(qdaFit)

qdaPred = predict(qdaFit, newdata = data)
summary(qdaPred)

confusionTable = table(qdaPred$class, data$Reason.f.)
confusionTable

#Accuracy
mean(qdaPred$class ==  data$Reason.f.)

summary(qdaPred$posterior)
