# Demonstration of final model and RMSE
if(!require(recosystem)) install.packages("recosystem")
library(tidyverse)
library(recosystem)

load("edx.rda")#loading edx object from working directory
load("validation.rda")#loading validation hold-out object from working directory

RMSE <- function(true_ratings, predicted_ratings){
  sqrt(mean((true_ratings - predicted_ratings)^2))
} #RMSE function as defined in text book

set.seed(1, sample.kind="Rounding") #ensure consistency of results through set seed.

train <- data_memory(edx$userId, edx$movieId, rating = edx$rating) 
#sparse matrix of residuals are basis for training matrix factorization model

r = Reco() #creating the Recommender System Object of the recosys package

r$train(train_data = train, opts = list(dim=30, lrate = .1, costp_l1 = 0,
                                        costp_l2=.1, costq_l1=0, costq_l2=.1))
#LIMBF model is trained using residual sparse matrix

valid <- data_memory(validation$userId, validation$movieId) 
#validation set userId and movieId data inputed into recosys environment for 
#prediction.  Note that the actual ratings are not entered into object.
#The validation set actual ratings will only be used for validating model prediction.

r$predict(test_data = valid)
#prediction function for recosys based on validation data - it 
#produces a file in the working directory that contains predictions. 
#This can take a while.

pred <-read.csv("predict.txt", header = FALSE)
#reading the prediction file into the local environment.  Predictions are in CSV
#format without a header.

RMSE(validation$rating, pred$V1)
#.819 RMSE

