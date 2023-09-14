# exploratory data analysis
print(Census.Data[1:20, 1:5]) # print first 20 rows and 5 columns
# or
View(Census.Data)

# top and bottom 'n' rows
head(Census.Data)
tail(Census.Data)

# number of columns and rows, names of columns
ncol(Census.Data)
nrow(Census.Data)
names(Census.Data)

# descriptive statistics
mean(Census.Data$Unemployed)
median(Census.Data$Unemployed)
range(Census.Data$Unemployed)
summary(Census.Data)

# univariate plots
# histogram
hist(Census.Data$Unemployed)
hist(Census.Data$Unemployed, breaks=20, col="orange", main="% in full-time employment", xlab = "Percentage")

# box and whisker plots
boxplot(Census.Data[,2:5])

# create violin plot - box plots + histogram
install.packages("vioplot") 
library(vioplot)
vioplot(Census.Data$Unemployed, Census.Data$Qualifications, Census.Data$White_British, Census.Data$Low_Occupancy, ylim = c(0,100), col="dodgerblue", rectCol="firebrick1", colMed="darkgoldenrod1")
vioplot(Census.Data$Unemployed, Census.Data$Qualifications, Census.Data$White_British, Census.Data$Low_Occupancy, ylim = c(0,100), col="dodgerblue", rectCol="firebrick1", colMed="darkgoldenrod1"
          , names = c("Unemployed", "Qualifications", "White British", "Occupancy"))