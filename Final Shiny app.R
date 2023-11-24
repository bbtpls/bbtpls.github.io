#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)
library(shinyjs)
library(shinydashboard)
library(readr)
library(plotly)
spyt <- read_csv("Spotify_Youtube.csv")

#cleaning the relevant data
cl_spyt <- spyt %>%
  mutate(Length_of_Title = nchar(Title),
         Links_in_Description = str_count(Description, "https://"),
         Licensed_Binary = as.integer(as.logical(spyt$Licensed)),
         Official_Video_Binary = as.integer(as.logical(spyt$official_video))) %>%
  select(Stream, Danceability, Energy, Speechiness, Instrumentalness, Liveness, Valence, Tempo, Duration_ms, Length_of_Title, Views, Likes, Comments, Links_in_Description, Licensed_Binary, Official_Video_Binary)


ui <- dashboardPage(
  dashboardHeader(disable = TRUE),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    useShinyjs(),
    fluidRow(
      box(selectInput("var_x", label = h2("select x-axis"), 
                      choices = colnames(cl_spyt), selected = NULL),
          selectInput("var_y", label = h2("select y-axis", selected = NULL), 
                      choices = colnames(cl_spyt)))
    ),
    plotlyOutput("graph")
  )
)

server <- function(input, output, session) {
  output$graph <- renderPlotly({
    plot_ly(cl_spyt, x=~get(input$var_x), y=~get(input$var_y), type = 'scatter', mode = 'markers')%>%
      layout(title = paste('Plot of', input$var_y, 'against', input$var_x), xaxis = list(title = input$var_x), yaxis = list(title = input$var_y))
  })

  addClass(selector = "body", class = "sidebar-collapse")
}

# Run the application 
shinyApp(ui = ui, server = server)
