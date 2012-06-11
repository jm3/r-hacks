# Tweet Pre-Processing Steps 

*(note: ordering is significant)*

1. for tweets: start with tweetbackup csv file
1. strip leading "http://twitter.com/#..." URL format from tweetbackup, retaining the tweet ID #
1. use SEARCH() and FIND() functions in spreadsheet to detect presence + position of:
   * hashtags
   * mentions
   * replies
   * RTs
   * links
1. in exported file, replace ,"" with ,"
1. join multi-line tweets onto a single line (ugh)
1. strip leading "username: " from tweet text
1. format dates as YYYY-MM-DD with custom format
1. format times as 24-hour format with custom format
1. strip commas + single quotes from tweets (affect tweet length) FIXME: there *has* to be a way to make R read escaped commas / quotes in strings 
1. pad dates + time + tweet columns with QQ so we can vi replace them faster with quotes

## for favorites:
1. start with the Twitter API's json export
1. use google refine to pivot into CSV
1. hack crummy month name abbrevs into zero-padded numbers and add dashes to dates
