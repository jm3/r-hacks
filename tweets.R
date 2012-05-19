# dependencies; uncomment to install
# install.packages("lubridate")
# install.packages("twitteR")
# install.packages("tm")

library(lubridate) # melt dates
library(twitteR) # use the Twitter API
library(tm) # mine text
library(stringr) # mine text

favs <- read.csv("./favs.csv")

# clean up the data
favs <- transform(favs,
  # drop unneeded column
  avatar <- NULL,

  # tweet IDs are opaque identifiers; we don't do math on them; thus factors
  tweet_id <-factor(tweet_id, order=T),

  # strings not factors
  tweet <- as.character(tweet),
  name <- as.character(name),

  # coerce to POSIXct
  tweet_date <- mdy_hms(tweet_date)

  # derive some values
  link_pos     = str_locate(tweet,"http"),
  RT_pos       = str_locate(tweet,"RT"),
  mention_pos  = str_locate(tweet,"@"),
  length       = str_length(tweet),
)

tweets <- read.csv("./tweets.csv")
tweets <- transform(tweets,
  # merge date + time
  date <- ymd_hm(paste(date,time))

  # drop unneeded columns
  time      <- NULL
  length    <- NULL
  RT_pos    <- NULL
  link_pos  <- NULL

  # derive some stats
  link_pos     = str_locate(tweet,"http")
  RT_pos       = str_locate(tweet,"RT")
  mention_pos  = str_locate(tweet,"@")
  length       = str_length(tweet)
)

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
