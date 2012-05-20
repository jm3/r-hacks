# dependencies; uncomment to install
# install.packages("lubridate")
# install.packages("twitteR")
# install.packages("tm")

library(lubridate) # melt dates
library(twitteR) # use the Twitter API
library(tm) # mine text
library(stringr) # mine text

favs <- read.csv("./favs.csv")

attach(favs)
# tweet IDs are opaque identifiers; we don't do math on them; thus factors
favs$tweet_id <-factor(tweet_id, order=T)

# strings not factors
favs$tweet <- as.character(tweet)
favs$name <- factor(paste(name, " (@", screen_name, ")", sep=""))

# drop unneeded columns after merging
favs$avatar <- NULL
favs$screen_name <- NULL

# coerce to POSIXct
favs$date <- mdy_hms(date)
favs$link_pos     = str_locate(tweet,"http")
favs$RT_pos       = str_locate(tweet,"RT")
favs$mention_pos  = str_locate(tweet,"@")
favs$length       = str_length(tweet)
detach(favs)

tweets <- read.csv("./tweets.csv")
attach(tweets)
# merge date + time
tweets$date <- ymd_hm(paste(date,time))
# poor man's version: tweets$date = as.Date(paste(tweets$date,tweets$time))

# drop unneeded columns
tweets$time      <- NULL
tweets$length    <- NULL
tweets$RT_pos    <- NULL
tweets$link_pos  <- NULL

# strings not factors
tweets$tweet <- as.character(tweet)

# derive some stats
tweets$link_pos     = str_locate(tweet,"http")
tweets$RT_pos       = str_locate(tweet,"RT")
tweets$mention_pos  = str_locate(tweet,"@")
tweets$length       = str_length(tweet)
detach(tweets)

# plots some hotness
fit <- lm(favs$length ~ favs$date)
plot(favs$date,favs$length); abline(fit)
plot(density(favs$length))
plot(density(tweets$length))
fit <- lm(favs$length ~ favs$date)
plot(fit)
rm(fit)

recent_tweets <- userTimeline("jm3", n=3000)
recent_tweets[1:3]
recent_tweets <- do.call("rbind", lapply(recent_tweets, as.data.frame))
dim(recent_tweets)

# working with http://www.rdatamining.com/examples/text-mining +
# http://www.r-bloggers.com/an-example-of-social-network-analysis-with-r-using-package-igraph/
