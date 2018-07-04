data = read.csv('./Datasets/GPU Kernel/sgemm_product.csv')

#names(data)
summary(data)

plot(Run1..ms. ~ MWG, data = data)

regFit = lm(Run1..ms. ~ MWG, data = data)
summary(regFit)
confint(regFit)

abline(regFit, col = "blue")

predict(regFit, data.frame(MWG = c(2,4,32)), interval = "confidence")
