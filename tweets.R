# dependencies; uncomment to install
library(ggplot2) # for graphing
library(gridExtra) # for side-by-side graphing
library(lubridate) # melt dates
library(MASS) # fitdistr; max-likelihood fitting of univariate distr.s
library(msm) # rtnormal; truncated normal distributions
library(stringr) # mine text
library(timeSeries) # work with TS data
library(tm) # mine text
library(twitteR) # use the Twitter API 
library(wordcloud) # generate visual word clouds
source('distributions.R')
source('multiplot.R')

favs <- read.csv("./data/favs.csv")

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

tweets <- read.csv("./data/tweets.csv")
attach(tweets)
# merge date + time
tweets$date <- ymd_hm(paste(date,time))

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

# try using maximum likelihood estimation to fit some data to a truncated normal dist.
fitdistr(favs$length, dtnorm0, start = list(mean = 0, sd = 1))
favs_samples   <- twitter_dist(favs$length)
tweets_samples <- twitter_dist(tweets$length)

# overlay two density plots
num_obs <- 10000
series <- c(array("Favorites", num_obs), array("All Tweets", num_obs))
merged_data <- data.frame( series=series, data=c(favs_samples$dist, tweets_samples$dist))
tweet_vs_fav_density_plot <- ggplot(merged_data, aes(x=merged_data$data, fill=series)) + geom_density(alpha = 0.8)
rm(num_obs, plot, favs_samples, tweets_samples)

# plot the basic time-series data
fav_length_plot <- ggplot(favs, aes(date, length)) + geom_line() + xlab("") + ylab("Tweet Lengths")

favs_ts <- timeSeries(favs$length, favs$date, units = "tweet_lengths")

# perform a weekly aggregation using our timeSeries object
favs_by_week <- timeSequence(from = start(favs_ts),  to = end(favs_ts), by = "week")

weekly_means <- aggregate(favs_ts, favs_by_week, mean) #mean = aggregation mechanism, can use a UDF
weeks <- ymd_hms(rownames(weekly_means))
graphable_df <- data.frame(date=weeks, mean_tweet_length=weekly_means$tweet_lengths)
mean_tweet_length_plot <- ggplot(graphable_df, aes(date,mean_tweet_length)) + geom_line() + xlab("") + ylab("Mean Length of Favorited Tweet")
rm(graphable_df)

# graph num tweets favorited per week (count #observations in timeseries)
weekly_counts <- aggregate(favs_ts, favs_by_week, FUN=function(x) { length(x) })
graphable_df <- data.frame(date=weeks, tweets_per_week=weekly_counts$tweet_lengths)
tweets_per_week_plot <- ggplot(graphable_df, aes(date,tweets_per_week)) + geom_line() + xlab("") + ylab("Number of Tweets Favorited per Week")
rm(graphable_df, series)

multiplot(tweets_per_week_plot, mean_tweet_length_plot, fav_length_plot, tweet_vs_fav_density_plot + opts(legend.position="bottom"), cols=2)

##########################################################################################
# fetch recent tweets over the network via the Twitter API
# recent_tweets <- userTimeline("jm3", n=200)
# recent_tweets[1:3]
# recent_tweets <- do.call("rbind", lapply(recent_tweets, as.data.frame)) # slick; look ma no loops
# dim(recent_tweets)

# or just use the tweets we've already loaded
tweet_text <- tweets$tweet
tweet_corpus <- Corpus(VectorSource(as.vector(tweet_text, mode="character")))

# strip non-ASCII chars because TM can't handle them
tweet_corpus <- tm_map(tweet_corpus, function(x) iconv(enc2utf8(x), sub = "byte"))
tweet_corpus <- tm_map(tweet_corpus, tolower)
tweet_corpus <- tm_map(tweet_corpus, removePunctuation)
tweet_corpus <- tm_map(tweet_corpus, removeNumbers)

# exclude some more common stopwords i say a lot
tweet_stopwords <- c(stopwords('english'), "via", "rt", "im", "youre", "theres"
  "joroan", "jm", "stdoyle", "cstoller", "vnaylon", "jeffheuer", "ayn", "buzz", "jamiew", 
  "peterhoneyman", "bloggerton", "proofapi", "proofads", "bmorrissey", "markjardine", 
  "rrwhite", "timhaines", "jenspec", "adampritzker", "sugarhousebar", "mattbinkowski", 
  "sferik", "tapbotpaul", "daksis", "jschox", "notoriouskrd", "janchip", "jonelvekrog",
  "joshsternberg", "griffitherin", "lmorchard", "pheezy", "sheynkman", "dugsong", "timoni",
  "konstantinhaase", "trafnar", "farbood", "kmaverick", "tiboutoo", "aidaan", "ahalvor",
  "lauardelean", "takeitez", "umairh", "kosta", "forzablitz", "dianakimball", "mikenowland",
  "krogisms", "nanaenay", "jackpine", "seekoh", "rands", "mike", "kevin", "abruehl", "alanlwhite",
  "alexchoi", "carinnatarvin", "david", "dcurtis", "essl", "carinnatarvin", "michael", "amadad",
  "formalplay", "samaman", "markromanek", "twilio", "cdixon", "companypolicy"
)
tweet_corpus <- tm_map(tweet_corpus, removeWords, tweet_stopwords)
dtm <- TermDocumentMatrix(tweet_corpus, control = list(minWordLength = 2))
findFreqTerms(dtm, lowfreq=4)
terms_matrix <- as.matrix(dtm)

# calculate the frequency of words
sorted_vector_terms <- sort(rowSums(terms_matrix), decreasing=TRUE)
terms <- names(sorted_vector_terms)

# optionally rename any problem keys
key_to_rename <- which(names(sorted_vector_terms)=="jm");
terms[key_to_rename] <- "jm3"
rm(key_to_rename)

clean_sorted_terms_matrix <- data.frame(word=terms, freq=sorted_vector_terms)
wordcloud(clean_sorted_terms_matrix$word, clean_sorted_terms_matrix$freq, min.freq=5)
rm(k, clean_sorted_terms_matrix, dtm, sorted_vector_terms, terms, terms_matrix, tweet_stopwords)

# working with http://www.rdatamining.com/examples/text-mining +
# http://www.r-bloggers.com/an-example-of-social-network-analysis-with-r-using-package-igraph/
# plot some hotness
# fit <- lm(favs$length ~ favs$date)
# par(mfrow=c(2,2))
# plot(density(favs$length))
# plot(density(tweets$length))
# plot(favs$date,favs$length); abline(fit)
# plot(tweets$date, tweets$link)
# # fit <- lm(favs$length ~ favs$date)
# fit=lm(favs$length~favs$date+epsilon)
# # plot(fit)
# # rm(fit)
