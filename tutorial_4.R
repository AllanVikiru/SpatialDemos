# bivariate analysis 

# run Pearsons correlation between unemployed and qualifications
cor(Census.Data$Unemployed, Census.Data$Qualifications)
# 1 perfect +ve relationship, 0 - no relationship, -1 perfect -ve relationship

# more statistical information
cor.test(Census.Data$Unemployed, Census.Data$Qualifications)

# spearmans : can cater for non-linear relationships & large-scale ordinal variables
cor.test(Census.Data$Unemployed, Census.Data$Qualifications, method = "spearman")

# correlation matrix 

cor_data1 <- Census.Data[,2:5] # slice out ID column
round(cor(cor_data1),4)

#create heatmap
library(ggplot2)
library(reshape2)
corr_matrix <- cor(cor_data1)

qplot(x=Var1, y=Var2, data=melt(corr_matrix), fill=value, geom="tile") + scale_fill_gradient2(limits=c(-1,1))

library(corrplot)
corrplot(corr_matrix, type="lower", tl.col="black", tl.srt=45)

# regression plot
# run regression model : y = b0 + b1x 
# lm(): y ~ x, df
model_1 <- lm(Qualifications~ Unemployed, Census.Data)
# set regression line to scatter plot
plot(Census.Data$Unemployed, Census.Data$Qualifications, xlab = "% Unemployed", ylab = "% with a qualification") + abline(model_1)

summary(model_1) # statistics for regression model
# y = 69.78 - 4.0672x

# do predictions of 10% unemployment
predict(model_1, data.frame(Unemployed = 10), interval = "confidence")

# residuals : differences between observed and predicted values (distance between each point in dataset and regression line) -- y = b0 + b1x + error
# computed by r-squared : higher value -> greater performance

# confidence intervals of estimated coefficients
confint(model_1, level=0.95)

#multiple regression (2 predictor variables)
model_2 <- lm(Qualifications ~ Unemployed + White_British, Census.Data)
summary(model_2)
