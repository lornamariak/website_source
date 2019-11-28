---
title: Reactivity in Shiny library
author: Lorna Maria
date: '2019-11-28'
slug: reactivity-in-shiny-library
categories: [Data Science]
tags: [Rstats]
image: images/featured-post/post-1.jpg
draft: no
type: post
---
#### Introduction
One of the things that makes shiny apps interactive is reactivity. In the simplest of terms **reactivity/reactive programming** is the ability of a program to compute outputs from a given set of user inputs. The ability of a shiny app to handle reactivity makes a two-way communication between the user and the existing information.
Reactivity is applied in cases such as performing calculations, data manipulation, the collection of user information among other scenarios.
As a beginner setting out to build shiny apps, having the basic knowledge to handle reactivity will help you go a long way to exploring different use cases of shiny apps.

<hr>

#### Let’s get started
The idea of reactivity will not occur to one until the error message below.
This error occurs when a reactive component is placed inside a non reactive function. The app will not load and will parse this error. Let’s us look at what a reactive function is and what it does.

##### Reactive Components of a shiny app
There are three major reactive components of a shiny app:
**Reactive Inputs**
A reactive input is defined as an input that a user provides through the browser interface. For example when a user fills a form,selects an item or clicks a button. These actions will trigger values to be set form the reactive inputs.Text input and Add button are reactive inputs.
**Reactive Outputs**
A reactive output is defined as program provided output in the browser interface. For example a graph, a map, a plot or a table of values.Table of values as a reactive output.
**Reactive Expressions**
A reactive expression is defined as one that transforms the reactive inputs to reactive outputs.These perform computations before sending reactive outputs.These will also mask slow operations like reading data from a server, making network calls among other scenarios.We shall see one in an example.

<hr>

Example 1
Let’s start with a simple example of adding up two integers and returning their sum in a shiny app.
```
ui
titlePanel("Sum of two integers"),
  
  #number input form
  sidebarLayout(
    sidebarPanel(
      textInput("one", "First Integer"),
      textInput("two", "Second Integer"),
      actionButton("add", "Add")
    ),
    
    # Show result
    mainPanel(
      
   textOutput("sum")
      
    )
server
server <- function(input,output,session) {
#observe the add click and perform a reactive expression
  observeEvent( input$add,{
    x <- as.numeric(input$one)
    y <- as.numeric(input$two)
    #reactive expression
    n <- x+y
    output$sum <- renderPrint(n)
  }
    
  )
```
Example 2
Now let’s build something a bit complex while handling reactivity.
```
ui
fields <- c("name","age","height","weight")
ui <- fluidPage(
   
   # Application title
   titlePanel("Health card"),
   
   # Sidebar with reactive inputs
   sidebarLayout(
      sidebarPanel(
         textInput("name","Your Name"),
        selectInput("age","Age bracket",c("18-25","25-45","above 45")),
         textInput("weight","Please enter your weight in kg"),
         textInput("height","Please enter your height in cm"),
         actionButton("save","Add")
        
      ),
      
      # a table of reactive outputs
      mainPanel(
         mainPanel(
            
            DT::dataTableOutput("responses", width = 500), tags$hr()
            
         )
      )
   )
)
server
# Define server logic 
   server <- function(input, output,session) {
      
#create a data frame called responses
      saveData <- function(data) {
         data <- as.data.frame(t(data))
         if (exists("responses")) {
            responses <<- rbind(responses, data)
         } else {
            responses <<- data
         }
      }
      
      loadData <- function() {
         if (exists("responses")) {
            responses
         }
      }
      
      
      # Whenever a field is filled, aggregate all form data
      #formData is a reactive function
      formData <- reactive({
         data <- sapply(fields, function(x) input[[x]])
         data
      })
      
      # When the Save button is clicked, save the form data
      observeEvent(input$save, {
         saveData(formData())
      })
      
      # Show the previous responses
      # (update with current response when save is clicked)
      output$responses <- DT::renderDataTable({
         input$save
         loadData()
      })     
   }
```
Result

When project is run.

There you go! Now that you can handle the basics, please go ahead and try it out.