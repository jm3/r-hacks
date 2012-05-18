# dependencies; uncomment to install
# install.packages("lubridate")
# install.packages("twitteR")
# install.packages("tm")

library(lubridate) # melt dates
library(twitteR) # use the Twitter API
library(tm) # mine text
library(stringr) # mine text

favs <- read.csv("./favs.csv")
favs$avatar <- NULL # drop unneeded column
favs$tweet_date <- mdy_hms(favs$tweet_date) # coerce to POSIXct

favs$link_pos     = str_locate(favs$tweet,"http")
favs$RT_pos       = str_locate(favs$tweet,"RT")
favs$mention_pos  = str_locate(favs$tweet,"@")
favs$length       = str_length(favs$tweet)

tweets <- read.csv("./tweets.csv")
tweets$date <- ymd_hm(paste(tweets$date,tweets$time)) # merge date + time

# drop unneeded columns
tweets$time      <- NULL
tweets$length    <- NULL
tweets$RT_pos    <- NULL
tweets$link_pos  <- NULL

# derive some stats
tweets$link_pos     = str_locate(tweets$tweet,"http")
tweets$RT_pos       = str_locate(tweets$tweet,"RT")
tweets$mention_pos  = str_locate(tweets$tweet,"@")
tweets$length       = str_length(tweets$tweet)

# plots some hotness
fit <- lm(favs$length ~ favs$tweet_date)
plot(favs$tweet_date,favs$length); abline(fit)
plot(density(favs$length))
plot(density(tweets$length))
fit <- lm(favs$length ~ favs$tweet_date)
plot(fit)
rm(fit)

recent_tweets <- userTimeline("jm3", n=3000)
recent_tweets[1:3]
recent_tweets <- do.call("rbind", lapply(recent_tweets, as.data.frame))
dim(recent_tweets)

# working with http://www.rdatamining.com/examples/text-mining +
# http://www.r-bloggers.com/an-example-of-social-network-analysis-with-r-using-package-igraph/
