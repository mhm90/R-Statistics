#install.packages("cvTools")
library(cvTools)
k = 10
?cvFolds()
folds = cvFolds(NROW(data), K=k)

#(unlist(folds["subsets"])) <- change list to vector
lm
cvApply = function(formula, data, folds) {
  for (i in 1:k) {
    #train = data[folds$subsets[folds$which != i], ]
    model = lm(formula = formula, data = data, subset = folds$subsets[folds$which != i])
    validation = data[folds$subsets[folds$which == i], ]
    prediction = predict(model, newdata = validation, type = "response")
    
  }
  
}

cvApply()
#irphe.ac.ir/sharif