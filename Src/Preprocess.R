echo = FALSE

if (!exists("mode", mode = "character") || mode != "preprocess") {

  #if (!exists("mode", mode = "character") || mode != "none")
    source("./Src/BasicPreprocess.R", local = FALSE, echo = FALSE)
  
  # Removing original categorical features
  # Removing extra features: Season (can be evaluated by Month), BMI (can be evaluated by Weight & Height)
  removeCols = c("ID", "Reason for absence", "Month of absence", "Day of the week", "Seasons", "Season.f", "Body mass index")
  data = data[ , !(names(data) %in% removeCols)]
  
  # Removing unused class labels
  data$Reason.f. = factor(data$Reason.f.)
  
  levels(data$Reason.f.)
  
  mode = "preprocess"
}