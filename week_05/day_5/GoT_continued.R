library(shiny)
library(tidyverse)
library(bslib)

game_of_thrones <- read_csv("~/Desktop/CodeClan/codeclan_work/week_01/day_2/character-deaths.csv")

game_of_thrones$allegiances <- ifelse(game_of_thrones$allegiances == "Lannister", "House Lannister", 
                                      ifelse(game_of_thrones$allegiances == "Tyrell", "House Tyrell", 
                                             ifelse(game_of_thrones$allegiances == "Tully", "House Tully", 
                                                    game_of_thrones$allegiances)))



all_allegiances <- game_of_thrones %>%
  distinct(allegiances) %>%
  pull()


ui <- fluidPage(
  theme = bs_theme(bootswatch = "simplex"),
  titlePanel("Valar Morghulis"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "nobility_input",
                   label = "Filter by Nobility:",
                   choices = c("All", "Noble", "Peasant"),
                   selected = "All"
      ), 
      
      selectInput(inputId = "book_num",
                  label = "Select a Book:",
                  choices = c(1:5),
                  selected = 1
      ),
      
      actionButton(inputId = "action_update", label = "Update dashboard?")
      
    ), 
    
    mainPanel( 
      
      plotOutput("death_plot"),
      
      br(),
      
      tableOutput("death_table")
      
    )
  )
)


server <- function(input, output) { 
  
  # Reactive expression for filtered data
  filtered_data <- eventReactive(eventExpr = input$action_update, valueExpr = {
    
    game_of_thrones %>%
      filter(!is.na(book_of_death)) %>%
      filter(if (input$nobility_input == "All") {
        nobility == nobility
      } else if (input$nobility_input == "Noble") {
        nobility == 1
      } else {
        nobility == 0
      }) %>%
      filter(book_of_death == input$book_num)
    
  })
  
  # Reactive expression for summarized data
  summarized_data <- reactive({
    
    filtered_data() %>%
      group_by(allegiances) %>%
      summarize(total_deaths = sum(ifelse(is.na(year_of_death), 0, 1)))
    
  })
  
  # Render plot
  output$death_plot <- renderPlot({
    
    ggplot(summarized_data(), aes(x = allegiances, y = total_deaths, fill = "#9D0A0E")) + 
      geom_col() +
      labs(
        x = "Allegiances",
        y = "Number of Deaths"
      ) + 
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1), 
            legend.position = "none",
      ) +
      coord_cartesian(ylim = c(0, 35)) +
      scale_y_continuous(breaks = seq(0, 35, 5), 
                         labels = seq(0, 35, 5))
    
  })
  

  output$death_table <- renderTable({
    
    summarized_data()
    
  })
  
}

shinyApp(ui = ui, server = server)
         
