library(shinydashboard)
library(shiny)
#library(data.table)
library(leaflet)
library(leaflet.extras)
library(lubridate)
library(htmltools)



STATES = c("All", sort(as.vector(unique(acd$State))))
WEATHERCOND = c("All", sort(as.vector(unique(acd$Weather_Condition))))
COUNTIES = c("All", sort(as.vector(unique(acd$County))))
CITIES = c("All", sort(as.vector(unique(acd$City))))
DAYNIGHT = c("Both", "Day", "Night")


header = dashboardHeader(
    title = "Traffic Accident in US from March 2015 to March 2019",
    titleWidth = 500
)

body <- dashboardBody(
    
    tags$head(tags$style(HTML('
        .skin-blue .main-header .logo {
          background-color: #3c8dbc;
        }
        .skin-blue .main-header .logo:hover {
          background-color: #3c8dbc;
        }
      '))),
    
    fluidRow(
        column(width=9,
               box(width = NULL, solidHeader = FALSE,
                   textOutput("numRec")),
               box(width = NULL, solidHeader = FALSE,
                   title = "Pointmap",
                   leafletOutput("pointMap", height = 400)
               ),
               box(width=NULL, solidHeader = TRUE,
                   title = "Heatmap",
                   leafletOutput("heatMap", height= 400)
               )
        ),
        column(width = 3,
               box(width = NULL, status = "warning", solidHeader = TRUE,
                   dateInput('Date', "Please Select a Date: ", 
                             min='2015-03-09', max='2019-04-01', value='2019-01-01'),
                   selectInput("DayNight", "Please Select Day/Night: ", choices = DAYNIGHT),
                   selectInput("State", "Please Select a State: ", choices = STATES),
                   selectInput("Weather", "Please Select a Weather Condition: ", choices = WEATHERCOND),
                   selectInput("County", "Please Select a County: ", choices = COUNTIES),
                   sliderInput("Visibility", "Please Select Visibility (mi) Range: ", 
                               min=0, max=10, value=c(0,10)),
                   sliderInput("WindSpeed", "Please Select Wind Speed (mph) Range:", 
                               min=0, max=17.3, value=c(0,17.3)),
                   sliderInput("Severity", "Please Select Severity Range: ",
                               min=0, max=4, value=c(0,4))
               )
        )
    )
)

dashboardPage(
    header,
    dashboardSidebar(disable = TRUE),
    body
)
