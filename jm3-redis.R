library(rredis)
redisConnect()
sets  <- c('tweets:hashtags', 'tweets:links', 'tweets:mentions', 'user:is_public')
zsets <- c('words', 'user:followers', 'user:num_tweets')

for (i in 1:length(sets)) {
  print(sets[i])
  print(redisSCard(sets[i]))
}
for (i in 1:length(zsets)) {
  print(redisZCard(zsets[i]))
}

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

langs  <- c("DE", "EN", "ES", "FA", "FR", "NL", "PT", "RU", "pinyin")