# Demonstration of final model and RMSE

library(recommenderlab)

RMSE <- function(true_ratings, predicted_ratings){
  sqrt(mean((true_ratings - predicted_ratings)^2))
}


