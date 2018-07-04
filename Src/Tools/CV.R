#install.packages("cvTools")
library(cvTools)
k = 10
?cvFolds()
folds = cvFolds(NROW(data), K=k)
class(folds["subsets"])
cvApply = function() {
  for (i in 1:k) {
    
  }
}
#irphe.ac.ir/sharif