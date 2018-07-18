# Removing classes with less than 2 samples
freq = table(data$Reason.f.)

rowsToDelete = c()
for (i in 1:NROW(data)) {
  if (freq[[data$Reason.f.[i]]] < 2) {
    rowsToDelete = append(rowsToDelete, i)
  }
}

# Removing samples with low class rate
data = data[-rowsToDelete, ]
# Removing unused class labels
data$Reason.f. = factor(data$Reason.f.)

levels(data$Reason.f.)
