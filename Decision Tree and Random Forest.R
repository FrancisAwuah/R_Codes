wine <- attach(winequality.red)
View(wine)
head(wine)

barplot(table(wine$quality))
view(wine$quality)

wine$taste <- ifelse(wine$quality < 6, 'bad', 'good')
wine$taste[wine$quality == 6] <- 'normal'
wine$taste <- as.factor(wine$taste)
table(wine$taste)

set.seed(123)
samp <- sample(nrow(wine), 0.6 = nrow(wine))
train <- wine[samp, ]
test <- wine[-samp, ]

library(randomForest)
model <- randomForest(taste ~ . - quality, data = train)

model
pred <- predict(model, newdata = test)