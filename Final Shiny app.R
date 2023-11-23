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
spyt <- read_csv("Spotify_Youtube.csv")

#cleaning the relevant data
cl_spyt <- spyt %>%
  mutate(lg_Title = nchar(Title),
         link_Desc = str_count(Description, "https://"),
         tf_licens = as.integer(as.logical(spyt$Licensed)),
         tf_offvid = as.integer(as.logical(spyt$official_video))) %>%
  select(Instrumentalness, Liveness, Valence, Tempo, Duration_ms, Stream, lg_Title, Views, Likes, link_Desc, tf_licens, tf_offvid, Danceability, Energy, Speechiness)


ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    useShinyjs(),
    fluidRow(
      box(selectInput("var_x", label = h2("select x-axis"), 
                      choices = colnames(cl_spyt)),
          selectInput("var_y", label = h2("select y-axis"), 
                      choices = colnames(cl_spyt)))
    ),
    fluidRow(
      box(plotOutput("line", height = 600, width = 900, click = "plot_click"))
    ),
    fluidRow(verbatimTextOutput("info"))
  )
)

server <- function(input, output) {
  output$line<- renderPlot({
    ggplot(cl_spyt) + aes_string(x=input$var_x, y=input$var_y) + geom_point()
  })
  output$info <- renderText({
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
  })
  addClass(selector = "body", class = "sidebar-collapse")
}

# Run the application 
shinyApp(ui = ui, server = server)
