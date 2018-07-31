#install.packages("readxl")
library(readxl)

rm(list = ls())

#data = read.csv('./Datasets/GPU Kernel/sgemm_product.csv')
data = read_excel('./Datasets/Absenteeism at work/Absenteeism_at_work.xls')
summary(data)

#data$`Same Person`

# Infos
reasonCodes = c("None", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX", "XXI", "patient.follow-up", "medical.consultation", "blood.donation", "laboratory.exam", "unjustified.absence", "physiotherapy", "dental.consultation")
sort(unique(data$`Reason for absence`))

# Fixing categorical data
data$ID.f = factor(data$ID)
data$Reason.f. = factor(data$`Reason for absence`, levels=c(0:28), labels = reasonCodes)
data$Month.f = factor(data$`Month of absence`)
data$WeekDay.f = factor(data$`Day of the week`)
data$Season.f = factor(data$Seasons)

mode = "none"
