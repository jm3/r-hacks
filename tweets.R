# load date libraries
library(lubridate)

favs <- read.csv("./favs.csv")
favs$avatar <- NULL
favs$tweet_date <- mdy_hms(favs$tweet_date) # coerce to POSIXct

tweets <- read.csv("./tweets.csv")

tweets$date <- ymd_hm(paste(tweets$date,tweets$time)) # coerce to POSIXct
tweets$time <- NULL
fit <- lm(tweets$tweet_length ~ tweets$link_position)
plot(fit)

# README.PRE-PROCESSING - NOTE: ORDER OF STEPS IS SIGNIFICANT
# start with tweetbackup csv file
# strip out leading twitter URL format from tweetbackup retaining only the tweet ID (so we can check it for favorites later)
# use SEARCH() and FIND() functions in spreadsheet to detect presence + position of:
#  * hashtags
#  * mentions
#  * replies
#  * RTs
#  * links
# 
# in exported file, replace ,"" with ,"
# join double-lined tweets (ugh)
# strip leading "jm3: " from tweets
# format dates as YYYY-MM-DD with custom format
# format times as 24-hour format with custom format
# strip all commas + single quotes in tweets (this will affect the length count)
# pad dates + time + tweet columns with QQ so we can vi replace them faster with quotes
