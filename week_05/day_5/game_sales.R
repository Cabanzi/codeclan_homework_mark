library(shiny)
library(tidyverse)
library(bslib)

game_sales <- CodeClanData::game_sales

ui <- fluidPage(
  tabsetPanel(
    tabPanel("Total sales",
             selectInput("category", "Select a category",
                         choices = c("genre", "publisher", "developer", "rating", "platform")),
             plotOutput("sales_plot")),
    tabPanel("Rating",
             selectInput("category2", "Select a category",
                         choices = c("genre", "publisher", "developer", "platform")),
             radioButtons("score", "Select score type:",
                          choices = c("Critic Score", "User Score")),
             radioButtons("top_or_bottom", "Select top or bottom:",
                          choices = c("Top 20", "Bottom 20")),
             plotOutput("rating_plot"))
  )
)

server <- function(input, output) {
  
  # Create a reactive data frame based on the selected category
  filtered_data <- reactive({
    filtered_data <- game_sales %>%
      filter(platform %in% input$platforms & year_of_release >= input$year_range[1] & year_of_release <= input$year_range[2])
    filtered_data
  }) # Add closing curly brace here
  
  # Create a line plot of total sales by year for the selected category
  output$sales_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = year_of_release, y = sales)) +
      geom_line() +
      labs(x = "Year", y = "Total Sales")
  })
  
 
  filtered_data2 <- reactive({
    game_sales %>%
      filter({{input$category2}} == .data[[input$category2]]) %>%
      arrange({{input$score}}) %>%
      { if (input$top_or_bottom == "Bottom 20") slice_tail(n = 20) else slice_head(n = 20) }
  })
  

  output$rating_plot <- renderPlot({
    ggplot(filtered_data2(), aes(x = reorder(name, {{input$score}}), y = {{input$score}})) +
      geom_col() +
      labs(x = "Game", y = {{input$score}})
  })
  
}

shinyApp(ui, server)