# R Learnings
# http://www.johndcook.com/R_language_for_programmers.html
# referencing matrix rows + cols: 
m <- matrix(1:4,nrow=2)
m[1,] # first row (1,3)
m[,1] # first column (1,2)

df <- data.frame()
attach(df) # = $_ in perl, default variable / DF for functions
# N.b. attach only works for lists, data frames and environments

str(df) # summarize a data structure and print its types

# nominal variables have no ordering (vs ordinal vars)
# Categorical (nominal) and ordered categorical (ordinal) variables in R are called factors.

rownames = whatevercolumnname # specific which column name R should use for row data on graphs

# lists collect multiple variables into a single bucket

x%%y  : Modulus (x mod y) 5%%2 is 1 
x%/%y : Integer division 5%/%2 is 2

# FIXME not working for some reason
df <- transform(df
  # df$local can now be referred to as local within this block
)

is.na() # test for missing data

# "join" two data sets on a common key:
tweets <- merge(tweets1, tweets2, by="tweet_id")
# N.b. by can take a vector of keys for multi-key joins;
tweets <- merge(tweets1,tweets2,by=c("tweet_id","screen_name"))

# alternatively, just slam two matrices side-by-side into one:
fuck_it <- cbind(tweets, favorite_foods)

# to append rows, use rbind:
tweets <- rbind(tweets,more_tweets) # rows must have the same vars

# re-coding bad values (NOTE: DOES NOT SEEM TO WORK)
attach(favs)
favs[RT_pos == -1, "RT_pos"] <- NA

na.omit(tweets) # remove all reows with missing data aka. listwise deletion

# within the RESHAPE packages:
# rename: rename a var without doing newname <- oldname

# Best Linear Unbiased Estimator

# for truncated normal distributions: msm package