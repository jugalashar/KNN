rm(list = ls(all= TRUE))

setwd("C:/Users/pc/Desktop/KNN")

#Loading the US Presidential data from which we can predict if a candidate will win or loose
# based on certain facors.
vote <- read.csv("C:/Users/pc/Desktop/KNN/US Presidential Data.csv")

#Loading libraries that will be used for this dataset. 
library(class)
library(caTools)
library(tidyverse)
library(caret)
library(e1071)

#str(vote)

#In KNN the Output variable has to be converted to factor data type with the appropriate levels
vote$Win.Loss <- as.factor(vote$Win.Loss)

#in KNN it is important to normalize all your predictor variables as KNN is highly sensitive to ouliers.
nor <-function(x) { (x -min(x))/(max(x)-min(x))  } 
norVote <- as.data.frame(lapply(vote[,c(2:14)], nor))

vote <- vote[,-c(2:14)]
vote <- cbind(vote,norVote)
colnames(vote)[colnames(vote)=="vote"] <- "Win.Loss"
#str(vote)

#splitting data into train and test datasets.
set.seed(101)
sample <- sample.split(vote, SplitRatio = 0.7)
train <- subset(vote, sample==TRUE)
test <- subset(vote, sample==FALSE)

#setting appropriate levels for the output variable for both test and train sets.
levels(train$Win.Loss) <- make.names(levels(factor(train$Win.Loss)))
levels(test$Win.Loss) <- make.names(levels(factor(test$Win.Loss)))

#determining k for the data through k-fold CV
x = trainControl(method = "repeatedcv", number = 10, repeats=3, classProbs = TRUE, 
                  summaryFunction=twoClassSummary)

#performing KNN on train dataset.
model <- train(Win.Loss~., data=train, method="knn",
               trControl=x, metric="ROC", tuneLength=10)

model

#displaying optimum k by means of a line graph.
plot(model)

#checking the performance of model on test dataset.
testPred <- predict(model, test, type = "prob")
#head(testPred)
library(ROCR)
testVal <- prediction(testPred[,2], test$Win.Loss)
#computing the Area Under the curve. here it is 83.3 which corresponds to a good model.
as.numeric(performance(testVal, "auc")@y.values)
#computing True Positive Rates and False positive Rates to plot ROC curve.
perfTest <- performance(testVal, "tpr", "fpr")
plot(perfTest, col="blue")

#visualizing KNN for this data set.
op <- seq(min(test$Optimism), max(test$Optimism), by= 0.01)
pess <- seq(min(test$Pessimism), max(test$Pessimism), by=0.01)

mean(test$PresentUsed)
mean(test$OwnPartyCount)
mean(test$OppPartyCount)
mean(test$NumericContent)
mean(test$Extra)
mean(test$Emoti)
mean(test$Agree)
mean(test$Consc)
mean(test$Openn)
mean(test$PastUsed)
mean(test$FutureUsed)

#creating a grid based on the mean values of all the predictor variables.
grid <- expand.grid(Optimism=op, Pessimism=pess, PastUsed=0.38, FutureUsed=0.42, 
                    PresentUsed=0.19, OwnPartyCount=0.024, OppPartyCount=0.093, NumericContent=0.103,
                    Extra=0.488, Emoti=0.581, Agree=0.453, Consc=0.553, Openn=0.363)

knnPred <- predict(model, newdata= grid)
knnPred <- as.numeric(knnPred)

testPred <- predict(model, newdata=test)
testPred <- as.numeric(testPred)

test$Pred <- testPred

probs <- matrix(knnPred, length(op), length(pess))

#using GGplot to create data points on the above grid.
ggplot(data=grid) + stat_contour(aes(x=Optimism, y=Pessimism, z=knnPred),
                                 bins=2) +
  geom_point(aes(x=Optimism, y=Pessimism, colour=as.factor(knnPred))) +
  geom_point(data=test, aes(x=test$Optimism, y=test$Pessimism, colour=as.factor(test$Pred)),
             size=5, alpha=0.5, shape=1)+
  theme_bw()
# 1 corresponds to a Loss in the election whereas 2 corresponds to a Win in the election.
