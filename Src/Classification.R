if (!exists("data", mode="list")) source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

glmFit = glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,family=binomial)
summary(glmFit)
