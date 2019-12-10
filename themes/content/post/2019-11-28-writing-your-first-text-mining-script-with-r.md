---
title: "Writing your first Text Mining Script with R"
author: Lorna Maria
date: '2018-01-11'
slug: text-mining-script-with-r
categories: [Data Science]
tags: [Rstats]
image: images/post/textmine.jpg
draft: no
type: post
---
Published in [Towards Data Science](https://towardsdatascience.com/)

#### Introduction
One of the reasons data science has become popular is because of it’s ability to reveal so much information on large data sets in a split second or just a query.
Think about it deeply ,on a daily basis how much information in form of text do we give out? All this information contains our sentiments,our opinions ,our plans ,pieces of advice ,our favourite phrase among other things.
However revealing each of those this can seem like finding a needle from a haystack at a glance ,until we use techniques like text mining/analysis .
Text mining takes in account information retrieval ,analysis and study of word frequencies and pattern recognition to aid visualisation and predictive analytics.
In this article ,We go through the major steps that a data set undergoes to get ready for further analysis.we shall write our script using R and the code will be written in R studio.
To achieve our goal ,we shall use an R package called “tm”.This package supports all text mining functions like loading data,cleaning data and building a term matrix.It is available on CRAN.
##### Let’s install and load the package in our work space to begin with.
```R 
#downloading and installing the package from CRAN
install.packages("tm")
#loading tm
library(tm)
```
<hr>

#### Loading Data

Text to be mined can be loaded into R from different source formats.It can come from text files(.txt),pdfs (.pdf),csv files(.csv) e.t.c ,but no matter the source format ,to be used in the tm package it is turned into a *corpus*.
A corpus is defined as “a collection of written texts, especially the entire works of a particular author or a body of writing on a particular subject”.
The tm package use the Corpus() function to create a corpus.
```R
#loading a text file from local computer
newdata<- readlines(filepath)
#Load data as corpus
#VectorSource() creates character vectors
mydata <- Corpus(VectorSource(newdata))
```
Refer to this [guide](http://www.r-tutor.com/r-introduction/data-frame/data-import) to learn more about importing files into R.

<hr>

#### Cleaning Data.
Once we have successfully loaded the data into the work space,it is time to clean this data. Our goal at this step is to create independent terms(words) from the data file before we can start counting how frequent they appear.
Since R is case sensitive ,we shall first convert the entire text to lowercase to avoid considering same words like “write” and “Write” differently.
We shall remove : URLs ,emojis,non-english words,punctuations,numbers,whitespace and stop words.<br>
**Stop words** : The commonly used english words like “a”,” is ”,”the” in the tm package are referred to as stop words. These words have to be eliminated so as to render the results more accurate.It is also possible to create your own custom stop words.

```R
# convert to lower case
mydata <- tm_map(mydata, content_transformer(tolower))
#remove ������ what would be emojis
mydata<-tm_map(mydata, content_transformer(gsub), pattern="\\W",replace=" ")
# remove URLs
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
mydata <- tm_map(mydata, content_transformer(removeURL)
)
# remove anything other than English letters or space
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
mydata <- tm_map(mydata, content_transformer(removeNumPunct))
# remove stopwords
mydata <- tm_map(mydata, removeWords, stopwords("english"))
#u can create custom stop words using the code below.
#myStopwords <- c(setdiff(stopwords('english'), c("r", "big")),"use", "see", "used", "via", "amp")
#mydata <- tm_map(mydata, removeWords, myStopwords)
# remove extra whitespace
mydata <- tm_map(mydata, stripWhitespace)
# Remove numbers
mydata <- tm_map(mydata, removeNumbers)
# Remove punctuations
mydata <- tm_map(mydata, removePunctuation)
```
<hr>

#### Stemming
Stemming is the process of gathering words of similar origin into one word for example “communication”, “communicates”, “communicate”. Stemming helps us increase accuracy in our mined text by removing suffixes and reducing words to their basic forms.We shall use the **SnowballC library**.

```R
library(SnowballC)
mydata <- tm_map(mydata, stemDocument)
```
##### Building a term Matrix and Revealing word frequencies
After the cleaning process ,we are left with independent terms that exist throughout the document.These are stored in a matrix that shows each of their occurrence. This matrix logs the number of times the term appears in our clean data set thus being called a **term matrix**.
```R
#create a term matrix and store it as dtm
dtm <- TermDocumentMatrix(mydata)
```
**Word frequencies** :These are the number of times words appear in data set.Word frequencies will indicate to us from the most frequently used words in the data set to the least used using the compilation of occurrences from the term matrix.

<hr>

#### Conclusion
We have just written a basic text mining script ,however it is just the beginning of text mining.The ability to get the text in its raw format and clean it to this point will give us direction to things like building a word cloud,sentiment analysis and building models.