---
title: Exploring Sentiment Analysis
author: Lorna Maria
date: '2018-10-19'
slug: exploring-sentiment-analysis
categories: [Data Science]
tags: [Rstats]
image: images/post/sentiment.jpeg
draft: no
type: post
---
Published in [The StartUp Publication](https://medium.com/swlh)
#### Introduction
One of the applications of text mining is sentiment analysis.In order for us to go ahead and carry out a sentiment analysis of our mined text,we are required to clean and prepare our data set as we saw in a [previous article](https://towardsdatascience.com/understanding-and-writing-your-first-text-mining-script-with-r-c74a7efbe30f?).

<hr>

#### Understanding Sentiment Analysis
**Sentiment Analysis** : The study of extracted information to identify reactions, attitudes, context and emotions.As one of the applications of text mining, sentiment analysis exposes the attitudes in the mined text.
It is based on word polarities, it takes into account positive or negative words and neutral words are dismissed.

![Table showing word polarities](/images/post/img1.png)
*Table showing word polarities*

Sentiment analysis is done based on lexicons. A **lexicon** in simpler terms is a vocabulary, say the English lexicon.In this context, a lexicon is a selection of words with the two polarities that can be used as a metric in sentiment analysis.
There are many different types of lexicons that can be used depending on the context of the data you are working with.There is also a possibility of creating a custom lexicon depending on how much customisation we would like to make with your data.

In this article,we shall make use of the [syuzhet]() package.While there are a number of packages for sentiment analysis on CRAN,the syuzhet package is great to learn with because it is a combination of the most common lexicons like nrc, bing and afinn.
We also make use of ggplot2 to further visualise our results from the sentiment analysis.

<hr>

#### How does Sentiment analysis work?
In simple terms,sentiment analysis is performed as an intersection of a term-document (built from the mined text) and a lexicon of choice.

*The first step is to have a term-document and a lexicon of your choice.*
![The first step is to have a term-document and a lexicon of your choice.](/images/post/img2.png)

*Then form an intersection between the two sets.*
![Then form an intersection between the two sets.](/images/post/img3.png)

<hr>

#### Hands-on with Sentiment analysis
* Example one: This is a simple example where we extract emotions from a sentence.We load the sentence,split each word using the *strsplit()* function to form a character vector and use the *get_nrc_sentiment()* function from the syuzhet library.This function takes in new_sentence and compares it with the nrc emotion lexicon to return the scores as shown below.
```
library(syuzhet)
sentence <- "i love cats such a bundle of joy."
new_sentence <- as.character(strsplit(sentence," "))
get_nrc_sentiment(new_sentence)
#This is the output
anger anticipation disgust fear joy sadness surprise trust negative
   0          0       0    0   2       0        0     0        0
positive
     2
```
* Example two: This second example makes use of a TED talks data set that was downloaded from Kaggle under the name transcript.csv.It underwent cleaning using the tm package following the steps in this article and was carried forward for sentiment analysis.
```
#load the libraries
library(syuzhet)
library(tm)
library(ggplot2)
#mydataCopy is a term document,generated from cleaning #transcripts.csv 
mydataCopy <- mydata
#carryout sentiment mining using the get_nrc_sentiment()function #log the findings under a variable result
result <- get_nrc_sentiment(as.character(mydataCopy))
#change result from a list to a data frame and transpose it 
result1<-data.frame(t(result))
#rowSums computes column sums across rows for each level of a #grouping variable.
new_result <- data.frame(rowSums(result1))
#name rows and columns of the dataframe
names(new_result)[1] <- "count"
new_result <- cbind("sentiment" = rownames(new_result), new_result)
rownames(new_result) <- NULL
#plot the first 8 rows,the distinct emotions
qplot(sentiment, data=new_result[1:8,], weight=count, geom="bar",fill=sentiment)+ggtitle("TedTalk Sentiments")

#plot the last 2 rows ,positive and negative
qplot(sentiment, data=new_result[9:10,], weight=count, geom="bar",fill=sentiment)+ggtitle("TedTalk Sentiments")
```
![Plot1: Shows distinct emotions](/images/post/img4.png)

*Plot1: Shows distinct emotions*

![Plot2: shows a combination of emtions under 2 polarities](/images/post/img5.png)

*Plot2: shows a combination of emtions under 2 polarities*

<hr>

#### Conclusion
The code from this example can be accessed from this [repository](https://github.com/lornamariak/Sentiment-Analysis).
We have applied our sentiment analysis tricks on mined text to come up with an evident description of the emotions attached to text data.This could be a whole project that can help you gain insights on how and when to talk to your audience, what they feel about a certain topic /product/service and what better way you can interact with them.