#The Stock Market Data
#Logistic Regression LDA, QDA and KNN
library(ISLR)
names(Smarket)
dim(Smarket)
summary(Smarket)
#The cor() function produces a matrix that contains all of the 
#pairwisecorrelations among the predictors in a data set.

cor(Smarket)
#The above command gives an error message because the Direction variable is qualitative.

cor(Smarket[-9]) #here the Directional variable is excluded because it's qualitative

#As one would expect, the correlations between the lag variables and to-day’s returns are close to zero
#In other words, there appears to be little correlation between today’s returns and previous days’ returns.
#The only substantial correlation is between Year and Volume.


#By plotting the data we see that Volume is increasing over time. In other words, the average number
# of shares traded daily increased from 2001 to 2005.
attach(Smarket)
plot(Volume)


#Next, we will ﬁt a logistic regression model in order to predict Direction using Lag1 through Lag5 and Volume. 
#The glm() function ﬁts generalized linear models, a class of models that includes logistic regression.
#The synthanx of the glm() function is similar to that of lm(), except that we must pass in
#the argument family=binomial in order to tell R to run a logistic regression
#rather than some other type of generalized linear model
glm.fits= glm( Direction~Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume ,data = Smarket , family = binomial )
summary(glm.fits)

#The smallest p-value here is associated with Lag1
#The negative coeﬃcient for this predictor suggests that if the market had a positive return yesterday,
#then it is less likely to go up today.
#However, at a value of 0.15, the p-value is still relatively large, and so there is no clear evidence 
#of a real association between Lag1 and Direction.

#We use the coef() function in order to access just the coeﬃcients for this ﬁtted model. 
coef(glm.fits)

#We can also use the summary() function to access particular aspects of the ﬁtted model, 
#such as the p-values for the coeﬃcients.
summary(glm.fits)$coef
summary(glm.fits)$coef[,4]

#The predict() function can be used to predict the probability that the market 
#will go up, given values of the predictors
glm.probs=predict(glm.fits, type="Response")
#The type="response" option tells R to output probabilities of the form P (Y = 1|X), 
#as opposed to other information such as the logit.
lm.probs[1:10]
