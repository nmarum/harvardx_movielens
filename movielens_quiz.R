#movielens quiz

#Q1 How many rows and columns are there in the edx dataset?

dim(edx)
#Number of rows:
nrow(edx)

#Number of columns:
ncol(edx)


#q2 How many zeros were given as ratings in the edx dataset?

edx %>% group_by(rating) %>% dplyr::count()

#No movies have a rating of 0. Movies are rated from 0.5 to 5.0 in 0.5 increments. 
#The number of 0s can be found using 
edx %>% filter(rating == 0) %>% tally()

#how many ratings were 3s?
edx %>% filter(rating == 3) %>% tally()

#how many movies are in the data set.
n_distinct(edx$movieId)

#how many different users in the data set?
n_distinct(edx$userId)


#How many movie ratings are in each of the following genres in the edx dataset?
#drama
sum(str_detect(string = edx$genres, pattern = "Drama"))

#Comedy:
sum(str_detect(string = edx$genres, pattern = "Comedy"))

#Thriller:
sum(str_detect(string = edx$genres, pattern = "Thriller"))

#Romance:
sum(str_detect(string = edx$genres, pattern = "Romance"))

#recommended code:
# str_detect
genres = c("Drama", "Comedy", "Thriller", "Romance")
sapply(genres, function(g) {
  sum(str_detect(edx$genres, g))
})

#which move has the greatest number of rankings?

edx %>% group_by(title) %>% tally() %>% arrange(desc(n))

#recommended code:
edx %>% group_by(movieId, title) %>%
  summarize(count = n()) %>%
  arrange(desc(count))

#what are the most common ratings, from most to least

sort(table(edx$rating))
hist(edx$rating)

#rec code:
edx %>% group_by(rating) %>% summarize(count = n()) %>% top_n(5) %>%
  arrange(desc(count))

#True or False - In general, half star ratings less common than full star
edx %>%
  group_by(rating) %>%
  summarize(count = n()) %>%
  ggplot(aes(x = rating, y = count)) +
  geom_line()
