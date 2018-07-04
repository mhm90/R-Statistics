data = read.csv('./Datasets/GPU Kernel/sgemm_product.csv')

names(data)
summary(data)

#subIndex = runif(1000, 1, length(nrow(data)))
set.seed(floor(runif(1,10,300)))
library('caTools')
split <- sample.split(data$MWG, SplitRatio = 0.05)

subData = subset(data, subset = split)
pairs(subData)
