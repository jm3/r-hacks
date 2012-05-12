library(rredis)
redisConnect()

# pretty-print big numbers with commas for readability
pp <- function(x){
  format( x, big.mark=",", scientific=FALSE)
}

sets  <- c('tweets:hashtags', 'tweets:links', 'tweets:mentions', 'user:is_public')
zsets <- c('words', 'user:followers', 'user:num_tweets')
langs  <- c("DE", "EN", "ES", "FA", "FR", "NL", "PT", "RU")
countries  <- c(
  "AE", "AF", "AG", "AM", "AO", "AQ", "AR", "AT", "AU", "AZ", "BA", "BB", "BD", 
  "BE", "BH", "BN", "BR", "BS", "BW", "BY", "CA", "CH", "CL", "CN", "CO", "CR", 
  "CU", "CY", "DE", "DK", "DO", "DZ", "EC", "EE", "EG", "ES", "ET", "FI", "FJ", 
  "FK", "FR", "GB", "GE", "GH", "GI", "GL", "GR", "GT", "GU", "HK", "HN", "HR", 
  "HU", "ID", "IE", "IL", "IN", "IR", "IT", "JM", "JO", "JP", "KE", "KH", "KP", 
  "KR", "KW", "LB", "LK", "LT", "LU", "LV", "MA", "MC", "MK", "MT", "MU", "MW", 
  "MX", "MY", "NG", "NI", "NL", "NO", "NP", "NZ", "OM", "PA", "PE", "PH", "PK", 
  "PL", "PT", "PY", "QA", "RO", "RS", "RU", "RW", "SA", "SE", "SG", "SI", "SN", 
  "SV", "TH", "TR", "TT", "TW", "TZ", "UA", "UG", "US", "UY", "VA", "VE", "VI", 
  "VN", "XK", "ZA", "ZW")

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
lang_stats <- lang_stats[rev(order(lang_stats$occurrences)),]

country_stats <- c(1:length(countries))
for (i in 1:length(countries)) {
  key <- paste("user:country:",countries[i],sep="")
  card <- redisSCard(key)
  country_stats[i] <- card
  print( paste(key, pp( card)))
}
country_stats <- data.frame(countries,country_stats)
names(country_stats) <- c("tweet country", "occurrences")
country_stats <- country_stats[rev(order(country_stats$occurrences)),]

# clean up the workspace
rm(i,card,key)