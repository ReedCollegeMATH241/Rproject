# R Twitter Sentiment Analysis
## Math 241 Term Project

### The Problem
The problem I decided to investigate is the question of how much Portland's famously crumby weather affects the sentiments expressed in tweets about the city.

### Motivation
Twitter has become a ubiquitous means of self-expression which is entirely public. Thus more and more it has become a source of information about its users. At this point it has become so ubiquitous that nightly news often cites twitter data for *vox populi* type reporting. Working in media research this past summer I found that statistics about twitter were often used by producers to get a sense for audience engagement. However, many of these statistics were very basic like day-over-day percent-change in followers, numbers of retweets, and etc. These are basic reliable statistics, but in both journalism and consumer research there is also a lot of interest in getting a good cross-sectional read on what twitter users think about various subjects. And doing this computationally is a major challenge which ties into a number of areas which are attracting a lot of attention in data driven industries. 

One of these areas is sentiment analysis, which is an attempt to extrapolate some sort of summary of the feelings expressed in a unit of text. The sort of initial compromise which the problem requires that one make is the adoption of a metric for sentiment. Of course this is a challenge because even from person to person the perceived sentiment in a text is going to vary. This project is essentially an investigation of some basic methods of sentiment analysis, methods that rely on publicly shared algorithms. On the other side of the spectrum there are a number of commercial services like IBM's Alchemy API that provide the results of far more sophisticated methods.

### Approach
* Collect data using the R package _twitteR_ with the geocode provided by the _ggmap_ package's `geocode('Portland,Or')` function.

* Explore data.
