# Sentiment and Weather Analysis Write-up
Julian Haft  
## Math 241 Term Project

### The Problem
The problem I initally set out to investigate was how much Portland's famously crumby weather affects the sentiments expressed in tweets about the city.

## Disclaimer
I did not have enough data to actually try to attempt to draw any serious conclusions.

### Motivation
Twitter has become a ubiquitous means of self-expression which is entirely public. Thus more and more it has become a source of information about its users. At this point it has become so ubiquitous that nightly news often cites twitter data for vox populi type reporting. Working in media research this past summer I found that statistics about twitter were often used by producers to get a sense for audience engagement. However, many of these statistics were very basic like day-over-day percent-change in followers, numbers of retweets, number of times favorited, and so on. These are basic reliable statistics, but in both journalism and consumer research there is also a lot of interest in getting a good cross-sectional read on what twitter users think about various subjects. And doing this computationally is a major challenge which ties into a number of areas which are attracting a lot of attention in data driven industries.

One of these areas is sentiment analysis, which is an attempt to extrapolate some sort of summary of the feelings expressed in a unit of text. The initial compromise that the problem of extracting sentiment requires is the adoption of a metric for sentiment. Of course this is a challenge because even from person to person the perceived sentiment in a text is going to vary. This project is essentially an investigation of some basic methods of sentiment analysis, methods that rely on publicly shared algorithms. On the other side of the spectrum there are a number of commercial services like IBM's Alchemy API that provide the results of far more sophisticated methods. 


### Approach

First I settle on one of the options for sentiment analysis. As mentioned before there is a whole range of sophistication when it comes to sentiment analysis. I chose to go with the `qdap` package’s polarity, because the [documentation](http://trinker.github.io/qdap/vignettes/qdap_vignette.html#polarity) is excellent in terms of describing the methods used. I will also try using the `sentiment` package, which appears to be a little smarter but is not as well documented. I suspect it operates on similar principles. I am not necessarily expecting to get valid data, and the decision of which package I use may lead to my getting invalid data. However, if I do get invalid data I would rather understand the reasons why then not, so `qdap`'s sentiment analysis should allow me to make judgements about how the algorithm is working. 

### Data Acquisition
Collect data using the R package _twitteR_ `searchTwitter('Portland',since=start.date, until=end.date ,geocode=geocode)` with the geocode being provided by the _ggmap_ package's `geocode('Portland,Or')` function and `start.date` and `end.date` being dates one day apart.

I discovered rather late into the project that I could not retrieve twitter for days which were more than 7 days earlier than the time of data acquisition. In order to make the data stable I retrieved all seven days worth of data for the last week and saved them each to individual twitter files. Unfortunately, seven days was not really enough to get a read on how weather would effect sentiment in tweets about the city of Portland.

#### Explore data. 

<!--html_preserve--><div id="htmlwidget-2479" style="width:100%;height:auto;" class="datatables"></div>
<script type="application/json" data-for="htmlwidget-2479">{
  "x": {
    "data": [
      ["1", "2", "3", "4", "10", "17", "19", "20", "21", "22", "23", "24", "27", "28", "30", "31", "32", "33", "34", "35", "36", "38", "40", "41", "42", "43", "46", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63"],
      [1, 2, 3, 4, 10, 17, 19, 20, 21, 22, 23, 24, 27, 28, 30, 31, 32, 33, 34, 35, 36, 38, 40, 41, 42, 43, 46, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63],
      ["A little scary, but very cool", "I am at Hopworks Urban Brewery - hopworksbrewery in Portland, OR", "Prepping the vocal chords.  10 Barrel Brewing PDX", ", OR : Voucher Examiner at Department of Veterans Affairs", "It is a beautiful day, Portland. So get outside, spend time in a park. ", "I am at Deschutes Brewery &amp;amp; Public House - deschutespdxpub in Portland, OR", "A much needed downtown Portland Post Cinco de Mayo carnival bevrera|", "|", "Score original w/ zipper  Jackpot Records", " Portland State Vikings", "Missed youuuuuu", "Tomatoes and strawberry planting time! ! ! !", "Nice days for a beer", "Volunteering at the Cinco de Mayo fair here in Portland. Hoping to have a booth next year!", "Shadows, Sunshine, &amp;amp; Birthdays  Portland Waterfront", "Geek Girl Brunch Portland! !  Mother's Bistro &amp;amp; Bar", "Got a chance to ride with the Ducati 1299!  Portland, Oregon", "I am at Kenny &amp;amp; Zuke's Delicatessen - kennyandzukes in Portland, OR", "It is Party town here! !", "Best hat so far  Rialto", " Deschutes Brewery Portland Public House", "Make Portland normal hemp and cannabis event!", "Derby today with my Portland Sister.  McMenamins Mission Theater", "First stop Pints Brewing Company  Pints Urban", "Silently creeping along the waterfront  Portland Waterfront", "Sunny Portland  Portland State University", "Nearly 3 years in Portland and first time I dropped in on these. do not judge me|", "Tacos! ! !", "Portland exploring  Portland Saturday Market", "I am definitely in Portland.  Tilt", " Shut Up and Eat Portland", "I am at Public Domain in Portland, OR", "First stop: Rogue Brewery Falling in love with Portland already itgoeson  Rogue Distillery And", "Pretty colors  Ground Kontrol Classic Arcade", "I am at BedBathBeyond in Portland, OR", "Beautiful day for a trail run", "psufraz23", "Love THIS! !", "I am at TheBelmontGoats in Portland, OR", "One day closer to having my own garden  Portland Farmers Market", "The Cure beet at Trinket. Portland, OR.  Trinket", "Doughnut! Line around the block| maybe later.  Voodoo Doughnut", "One of my favorite houses in Portland, because it does not feel like Portland  Laurelhurst Village"]
    ],
    "container": "<table class=\"display\">\n  <thead>\n    <tr>\n      <th> </th>\n      <th>X</th>\n      <th>text</th>\n    </tr>\n  </thead>\n</table>",
    "options": {
      "columnDefs": [
        {
          "orderable": false,
          "targets": 0
        },
        {
          "className": "dt-right",
          "targets": 1
        }
      ],
      "order": [],
      "autoWidth": false
    },
    "callback": "function(table) {\nreturn table;\n}",
    "filter": "none"
  },
  "evals": ["callback"]
}</script><!--/html_preserve-->


#### Initial Observations
Reading from a csv file which was the write-out of a `twListToDF` call has removed a certain amount of data. I am not exactly sure why this is but the various emoji's and the like have been removed. In order to avoid this one might try a different storage medium. For example one could try using the `twitteR` package's `search_twitter_and_store` command to store to a database, which I attempted to do but ultimately had to abandon. Part of this data loss seems due to my using `iconv(text,'ASCII', to='UTF-8-MAC', sub='byte')` on the imported data set. This was a necessary step due to issues with the strings.

Looking at the content of the tweets, it's clear that the sentiment analysis is going to be difficult, since many of the tweets are just declarative sentences. This is due to a flaw inherent in the project's design, which is that we lack the sophistication to select tweets where people are expressing opinions. One thought as for how that might be done is to use the statusSource field provided in the lists obtained from the `twitteR` packages `searchTwitter` function, in order to eliminate generic tweets sent from applications.

Another minor problem is the lack of sentence structure. On the one hand, `qdap` relies heavily on a regular sentence structure to apply its functions, however one will almost never get that with twitter data. So it can't be helped. The `polarity` function which we will be using expects whole sentences, but right now we have whole tweets for input. However, after reviewing the theory behind how the function, it seems to turn it into sentences will lead to an inevitable loss of data. On the other hand, the `sentiment` package will not have any problems with this.

#### Basic Analysis

Now I am going to run the two basic algorithms. And compare their outputs, first we will look at a datatable produced by the `sentiment` package. Then at a plot of the polarities in the `qdap` package.

<!--html_preserve--><div id="htmlwidget-5630" style="width:100%;height:auto;" class="datatables"></div>
<script type="application/json" data-for="htmlwidget-5630">{
  "x": {
    "data": [
      ["1", "2", "3", "4", "10", "17", "19", "21", "22", "23", "24", "27", "28", "30", "31", "32", "33", "34", "35", "36", "38", "40", "41", "42", "43", "46", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63"],
      [
        "A little scary, but very cool",
        "I am at Hopworks Urban Brewery - hopworksbrewery in Portland, OR",
        "Prepping the vocal chords.  10 Barrel Brewing PDX",
        "OR : Voucher Examiner at Department of Veterans Affairs",
        "It is a beautiful day, Portland. So get outside, spend time in a park. ",
        "I am at Deschutes Brewery &amp; Public House - deschutespdxpub in Portland, OR",
        "A much needed downtown Portland Post Cinco de Mayo carnival bevrera|",
        "Score original w/ zipper  Jackpot Records",
        "Portland State Vikings",
        "Missed youuuuuu",
        "Tomatoes and strawberry planting time! ! ! !",
        "Nice days for a beer",
        "Volunteering at the Cinco de Mayo fair here in Portland. Hoping to have a booth next year!",
        "Shadows, Sunshine, &amp; Birthdays  Portland Waterfront",
        "Geek Girl Brunch Portland! !  Mother's Bistro &amp; Bar",
        "Got a chance to ride with the Ducati 1299!  Portland, Oregon",
        "I am at Kenny &amp; Zuke's Delicatessen - kennyandzukes in Portland, OR",
        "It is Party town here! !",
        "Best hat so far  Rialto",
        "Deschutes Brewery Portland Public House",
        "Make Portland normal hemp and cannabis event!",
        "Derby today with my Portland Sister.  McMenamins Mission Theater",
        "First stop Pints Brewing Company  Pints Urban",
        "Silently creeping along the waterfront  Portland Waterfront",
        "Sunny Portland  Portland State University",
        "Nearly 3 years in Portland and first time I dropped in on these. do not judge me|",
        "Tacos! ! !",
        "Portland exploring  Portland Saturday Market",
        "I am definitely in Portland.  Tilt",
        "Shut Up and Eat Portland",
        "I am at Public Domain in Portland, OR",
        "First stop: Rogue Brewery Falling in love with Portland already itgoeson  Rogue Distillery And",
        "Pretty colors  Ground Kontrol Classic Arcade",
        "I am at BedBathBeyond in Portland, OR",
        "Beautiful day for a trail run",
        "psufraz23",
        "Love THIS! !",
        "I am at TheBelmontGoats in Portland, OR",
        "One day closer to having my own garden  Portland Farmers Market",
        "The Cure beet at Trinket. Portland, OR.  Trinket",
        "Doughnut! Line around the block| maybe later.  Voodoo Doughnut",
        "One of my favorite houses in Portland, because it does not feel like Portland  Laurelhurst Village"
      ],
      ["negative", "positive", "negative", "positive", "negative", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "negative", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "neutral", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "positive", "negative", "positive"],
      ["1.03127774142571", "1.03127774142571", "1.03127774142571", "1.03127774142571", "9.47547003995745", "1.03127774142571", "1.03127774142571", "16.5333679773693", "9.47547003995745", "1.03127774142571", "1.03127774142571", "9.47547003995745", "8.78232285939751", "1.03127774142571", "1.03127774142571", "1.03127774142571", "1.03127774142571", "1.03127774142571", "9.47547003995745", "1.03127774142571", "16.5333679773693", "1.03127774142571", "1.03127774142571", "1.03127774142571", "17.2265151579293", "1.03127774142571", "1.03127774142571", "1.03127774142571", "8.78232285939751", "1.03127774142571", "1.03127774142571", "9.47547003995745", "17.2265151579293", "1.03127774142571", "9.47547003995745", "1.03127774142571", "9.47547003995745", "1.03127774142571", "1.03127774142571", "9.47547003995745", "1.03127774142571", "17.9196623384892"],
      ["18.5054868578024", "0.445453222112551", "8.78232285939751", "0.445453222112551", "17.8123396772424", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "8.78232285939751", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "9.47547003995745", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "0.445453222112551", "8.78232285939751", "0.445453222112551"]
    ],
    "container": "<table class=\"display\">\n  <thead>\n    <tr>\n      <th> </th>\n      <th>text</th>\n      <th>sentiment</th>\n      <th>positiveScore</th>\n      <th>negativeScore</th>\n    </tr>\n  </thead>\n</table>",
    "options": {
      "columnDefs": [
        {
          "orderable": false,
          "targets": 0
        }
      ],
      "order": [],
      "autoWidth": false
    },
    "callback": "function(table) {\nreturn table;\n}",
    "filter": "none"
  },
  "evals": ["callback"]
}</script><!--/html_preserve-->
One of the benefits of the `sentiment` package is that it is somewhat transparent in how it decides whether something is positive or negative in sentiment. Clearly it just compares negative to positive and assigns the sentiment as the greater of the two. However how it calculates those values is not transparent at all.


<!--html_preserve--><div id="htmlwidget-5142" style="width:100%;height:auto;" class="datatables"></div>
<script type="application/json" data-for="htmlwidget-5142">{
  "x": {
    "data": [
      ["1", "2", "3", "4", "5", "9", "10", "11", "13", "14", "16", "17", "18", "19", "20", "23", "24", "26", "27", "28", "29", "30"],
      ["Prepping the vocal chords.", "It is a beautiful day, Portland.", "So get outside, spend time in a park.", "A much needed downtown Portland Post Cinco de Mayo carnival bevrera|", "Tomatoes and strawberry planting time!", "Volunteering at the Cinco de Mayo fair here in Portland.", "Hoping to have a booth next year!", "Geek Girl Brunch Portland!", "Got a chance to ride with the Ducati 1299!", "It is Party town here!", "Make Portland normal hemp and cannabis event!", "Derby today with my Portland Sister.", "Nearly 3 years in Portland and first time I dropped in on these.", "do not judge me|", "Tacos!", "I am definitely in Portland.", "Love THIS!", "The Cure beet at Trinket.", "Portland, OR.", "Doughnut!", "Line around the block|", "maybe later."],
      [0, 0, 0.438178046004133, 0, 0, 0.438178046004133, 0, 0, 0, 0, 0, 0, 0.438178046004133, 0, 0, 0, 0.438178046004133, 0, 0.438178046004133, 0, 0, 0.438178046004133],
      [
        "-",
        "-",
        ["beautiful", "fair", "love", "cure"],
        "-",
        "-",
        ["beautiful", "fair", "love", "cure"],
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        ["beautiful", "fair", "love", "cure"],
        "-",
        "-",
        "-",
        ["beautiful", "fair", "love", "cure"],
        "-",
        ["beautiful", "fair", "love", "cure"],
        "-",
        "-",
        ["beautiful", "fair", "love", "cure"]
      ],
      [
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-"
      ]
    ],
    "container": "<table class=\"display\">\n  <thead>\n    <tr>\n      <th> </th>\n      <th>text</th>\n      <th>polarity</th>\n      <th>pos.words</th>\n      <th>neg.words</th>\n    </tr>\n  </thead>\n</table>",
    "options": {
      "columnDefs": [
        {
          "orderable": false,
          "targets": 0
        },
        {
          "className": "dt-right",
          "targets": 2
        }
      ],
      "order": [],
      "autoWidth": false
    },
    "callback": "function(table) {\nreturn table;\n}",
    "filter": "none"
  },
  "evals": ["callback"]
}</script><!--/html_preserve--><img src="write-up_files/figure-html/unnamed-chunk-3-1.png" title="" alt="" width="\maxwidth" />
The `qdap` output is a little more clear in how it is derived. In the `pos.words` column you can see which word is weighted by the `polarity` algorithm. The function doesn't explicitly label things as positive or negative, so one must come up with that spectrum on one's own. Another issue here is that the 


Based off these results, neither the `sentiment` nor the `qdap` package have provided very reliable results. But the sentiment package has the benefit of being easier to interpret and easier to use. Despite the nicety of `qdap`'s documentation it is too sensitive (Note how it removed most of the tweets because they lacked whole sentences) and specialized a package for use on this sort of data. However, the sentiment analysis is disappointing. the `negativeScore` on the tenth tweet in the above table is a really strong indication of the package's unreliability. Now I actually have a small enough data set that I could potentially use the free alchemyAPI to do the sentiment analysis. However, I do not know how to integrate its functionality with R so it is unfeasible. As a test case I did run the first few items through the API and it decided the first four tweets in the above list were positive. Given the poor quality of the data it seems that a reassesment of the methods is required.

Given the data I would have used counts of positive and negative messages in a given day as variables and tried to correlate them to weather events. The `weatherData` package, which essentially scrapes [weather underground](http://www.wunderground.com) would have been used to pull a detailed weather summary for each day. And I would have assessed the correlations between weather metrics like inches of rain and the day's counts. If  

### Conclusions
