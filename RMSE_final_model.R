# Demonstration of final model and RMSE

library(recommenderlab)
library(tidyverse)
library(recosystem)
load("edx.rda")
load("validation.rda")
RMSE <- function(true_ratings, predicted_ratings){
  sqrt(mean((true_ratings - predicted_ratings)^2))
}

mu <- mean(edx$rating)

res <- edx %>% 
  group_by(userId) %>%
  mutate(bu = mean(rating-mu)) %>% #user effect is adjusted through normalization
  ungroup() %>%
  group_by(movieId) %>%
  mutate(bi = sum(rating-mu)/(n()+.5)) %>% #movie effect is adjusted through regularization
  ungroup() %>%
  mutate(res = rating-bu-bi)#residuals found through removing user and movie effects

train <- data_memory(res$userId, res$movieId, rating = res$rating) 
#sparse matrix of residuals are basis for training matrix factorization model

r = Reco() #creating the Recommender System Object of the recosys package

r$train(train_data = train, opts = list(costq_l1 = 0))
#LIMBF model is trained using residual sparse matrix

valid <- data_memory(validation$userId, validation$movieId) 
#validation set userId and movieId data inputed into recosys environment for 
#prediction.  Note that the actual ratings are not entered into object.
#The validation set actual ratings will only be used for validating model prediction.

r$predict(test_data = valid)
#prediction function for recosys based on validation data - it 
#produces a file in the working directory that contains predictions. This can take a while.

pred <-read.csv("predict.txt", header = FALSE)
#reading the prediction file into the local environment.  Predictions are in CSV
#format without a header.

RMSE(validation$rating, pred$V1)
#.8324285 RMSE

