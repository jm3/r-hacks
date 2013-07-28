library(rredis)

# pretty-print big numbers with commas for readability
pp <- function(x){
  format( x, big.mark=",", scientific=FALSE)
}

redisConnect()

sets  <- c("tweets:hashtags", "tweets:links", "tweets:mentions", "user:is_public")
zsets <- c("words", "user:followers", "user:num_tweets")

langs <- read.csv("./data/lang-codes.csv", header=FALSE)
langs <- as.matrix(langs)
countries <- read.csv("./data/country-codes.csv", header=FALSE)
countries <- as.matrix(countries)

for (i in 1:length(sets)) {
  print( paste(sets[i], ":", pp( redisSCard(sets[i]))))
}

for (i in 1:length(zsets)) {
  print( paste(zsets[i], ":", pp( redisZCard(zsets[i]))))
}

lang_stats <- c(1:length(langs))
for (i in 1:length(langs)) {
  key <- paste("user:lang:",langs[i],sep="")
  card <- redisSCard(key)
  lang_stats[i] <- card
  print( paste(key, pp(card)))
}
lang_stats <- data.frame(langs,lang_stats)
names(lang_stats) <- c("tweet language","occurrences")

country_stats <- c(1:length(countries))
for (i in 1:length(countries)) {
  key <- paste("user:country:",countries[i],sep="")
  card <- redisSCard(key)
  country_stats[i] <- card
  print( paste(key, pp( card)))
}
country_stats <- data.frame(countries,country_stats)
names(country_stats) <- c("tweet country", "occurrences")

# clean up the workspace
rm(i,card,key)
