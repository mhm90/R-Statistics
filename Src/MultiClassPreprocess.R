source("./Src/Preprocess.R", local = TRUE, echo = FALSE)

# Removing classes with less than 10 samples
freq = table(data$Reason.f.)

rowsToDelete = c()
for (i in 1:NROW(data)) {
  if (freq[[data$Reason.f.[i]]] < 10) {
    rowsToDelete = append(rowsToDelete, i)
  }
}

# Removing samples with low class rate
data = data[-rowsToDelete, ]
data$Reason.f. = factor(data$Reason.f.)