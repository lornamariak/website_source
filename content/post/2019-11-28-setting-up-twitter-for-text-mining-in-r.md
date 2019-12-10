---
title: Setting Up Twitter for Text mining in R
author: Lorna Maria
date: '2019-02-05'
slug: setting-up-twitter-for-text-mining-in-r
categories: [Data Science]
tags: [Rstats]
image: images/post/settwitter.jpeg
draft: no
type: post
---
Published in [Towards Data Science](https://towardsdatascience.com/)

#### Introduction
Over the years, social media has become a hot spot for data mining. Every day there are always topics trending, campaigns running and groups of people discussing different global, continental or national issues.This is a major target to harness data.
In this article, we focus on Twitter as a centre of opinions and sentiments across the globe.We set out to mine text from the millions of tweets that go out every day to be able to understand what is going on all even beyond our own timelines.
<hr>
#### Twitter API Set Up
To use the twitter API we need to have a twitter account.
Sign Up via (https://twitter.com) ,go to (https://apps.twitter.com/) to access twitter developer options.
![Create a New App](/images/post/settwitterimg1.png)

Create a new application

![Create a New App](/images/post/settwitterimg2.png)

**Application Name**: Give your app a unique name. if it is taken you will be notified to change.

**Application site**: This can be a link to your Github repository where the application code will be if your app has no site yet. (like mine)

**Call back URL**: This is a link to which a success or failure message is relayed from one program to another.It tells the program on where to go next in both cases.You can direct your application to any port available, mine is port 1410.

###### App Credentials
These are very important to help one log into the application.There are four major credentials used in this set up.

**Consumer key** : This key identifies the client to the application.

**Consumer Secret**: This is the clients password that is used with server authentication.

**Access Token**:This is the consumer identification that is used to define their privileges.

**Access Secret**:This is sent with the access token as a password.
They are obtained this way.

![App credentials](/images/post/settwitterimg3.png)
![Generating Tokens](/images/post/settwitterimg4.png)
![App Tokens](/images/post/settwitterimg5.png)

**Note**:These credentials are meant to be kept private,that is why i shaded through mine.
Voila! We have an API set up

<hr>
#### R Studio Set Up
R uses the twitteR library, an R based Twitter client that handles communication with the Twitter API. Let us take a moment and thank Jeff Gentry for putting this library together.

```R
#from CRAN
install.packages(“twitteR”)
#alternatively from the Github
library(devtools)
install_github(“geoffjentry/twitteR”)
```
The difference between the two methods above is that the first method downloads the package from the CRAN site and will take the argument of a package name while the second will install packages from the GitHub repository and will take an argument of the repository name. Read more about packages and installation [here](https://www.datacamp.com/community/tutorials/r-packages-guide).

#### Authentication
Twitter uses Open Authentication (OAuth) to grant access to the information. Open Authentication is a token based authentication method.Let’s refer to our four credentials.

```R
#load library
library(twitteR)
#load credentials
consumer_key <- “****************”
consumer_secret<- “*******************”
access_token <- “*******************”
access_secret <- “************************”
#set up to authenticate
setup_twitter_oauth(consumer_key ,consumer_secret,access_token ,access_secret)
```
We use the setup_twitter_oauth function to set up our authentication.The setup_twitter_oauth() function takes in the four twitter credentials that we generated from the API set up above.
Go ahead and authorise direct authentication by pressing Y on our keyboard.

#### Querying Twitter
To query is to simply ask a question. To be able to access the data we need, we have to send meaningful queries to twitter. With Twitter, we have access to tons of information from trends to campaigns to accounts. We have a range of things to query.
Let us run query on this hashtag #rstats
```R
#fetch tweets associated with that hashtag , 12 tweets-n in 
#(en)glish-lang since the indicated date yy/mm/dd
tweets <- twitteR::searchTwitter(“#rstats”,n =12,lang =”en”,since = ‘2018–01–01’)
#strip retweets
strip_retweets(tweets)
```
This code returns the tweets as a list.The strip_retweets() function eliminates any retweets in the returned tweets.
For further analyse these tweets we shall consider converting the returned tweets to a data frame and store them locally.

```R
#convert to data frame using the twListtoDF function
df <- twListToDF(tweets)\#extract the data frame save it locally
saveRDS(df, file=”tweets.rds”)
df1 <- readRDS(“mytweets.rds”)
```
#### Cleaning the Tweets
From the query, we have managed to store the results into a data frame on our computers.Now let us examine this data to find out whoever has the highest Retweets and give them a shoutout straight from our script.
We shall use the dplyr library to traverse through this data frame.
```R
library(dplyr)
#clean up any duplicate tweets from the data frame using #dplyr::distinct
dplyr::distinct(df1)
```
Let us make use of dplyr verbs to select the tweet,screenname,id and retweet count for a tweet with the most retweets and store the result in a data frame called winner.

```R
winner <-df1 %>% select(text,retweetCount,screenName,id )%>% filter(retweetCount == max(retweetCount))
View(winner)
```
Check out more on dplyr via this [cheat sheet](https://rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf).

#### Sending a Direct Message
To notify our retweet competition winner ,we shall send them a direct message from this script by picking their handle from the winner data frame.
The dmsend() function takes in the message and username which is saved as the screenName.
```R
us <- userFactory$new(screenName= winner$screenName)
dmSend(“Thank you for participating in #rstats,Your tweet had the highest retweets”, us$screenName)

```
#### Conclusion
We have just created our first mined dataset from twitter and used it to find out our retweet competition winner. 
Well, that is just a small example of what we can do, however, there is a column that contains text from the mined tweets which can be analysed using techniques from the other articles on this blog.
There are more possibilities with this mined data like sentiment analysis and word frequency visualisations.
Happy Tweet Mining!
