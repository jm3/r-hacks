# truncated normal distribution from 1 .. 140
dtnorm0 <- function(x, mean = 0, sd = 1, log = FALSE) {
  dtnorm(x, mean=mean, sd=sd, lower=1, upper=140)
}

# individual density plots drawn randomly from a truncated normal (rtnorm)
twitter_dist <- function( vec, num_runs=10000 ) {
  data.frame(dist=rtnorm(num_runs, mean=mean(vec), sd=sd(vec), lower=1, upper=140))
}
