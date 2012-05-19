# R Learnings

# referencing matrix rows + cols: 
m <- matrix(1:4,nrow=2)
m[1,] # first row (1,3)
m[,1] # first column (1,2)

df <- data.frame()
attach(df) # = $_ in perl, default variable / DF for functions
# N.b. attach only works for lists, data frames and environments

str # summarize a data structure and print its types
# nominal variables have no ordering (vs ordinal vars)

