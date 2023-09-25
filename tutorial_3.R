# bivariate plots - plotting relationships against 2 or more variables

# simple scatter plots - x vs y, with axes and symbols
plot(Census.Data$Unemployed, Census.Data$Qualifications, xlab="% in full time employment", ylab="% with a qualification", pch=22)

# 3 dimension bubble plots - size of dependent variable
symbols(Census.Data$Unemployed, Census.Data$Qualifications, circles = Census.Data$White_British, fg = "white", bg="orange", inches = 0.2)
# larger circles = greater percentage

# add regression line with width and type (1-6)
symbols(Census.Data$Unemployed, Census.Data$Qualifications, circles = Census.Data$White_British, fg = "white", bg="lightblue", inches = 0.2, xlab="% in full time employment", ylab="% with a qualification") +
  abline(lm(Census.Data$Qualifications~ Census.Data$Unemployed), col="red", lwd=3, lty=4)

# use ggplot
library(ggplot2)

# scatter plot
p <- ggplot(Census.Data, aes(Unemployed, Qualifications))
p + geom_point()

# include sizes of dependent variables
p <- ggplot(Census.Data, aes(Unemployed, Qualifications))
p + geom_point(aes(colour = White_British, size=Low_Occupancy))
# plot percentage of White British population depending on occupation rates in homes e.g. overcrowded
