library(shinydashboard)
library(shiny)
library(data.table)
library(leaflet)
library(leaflet.extras)
library(lubridate)
library(htmltools)

#setwd('Downloads/Rstudio_dir/shiny/TrafficAccidents/USTrafficAccidentMarch2015-March2019/')
acd = fread('US_Accidents.csv', sep=',')
acd$Start_Time = as_datetime(acd$Start_Time)

icons <- awesomeIcons(icon = "whatever",
                      iconColor = "black",
                      library = "ion",
                      markerColor = acd$Color)

function(input, output, session) {
    rt <- reactive({
        x = acd[as_date(acd$Start_Time)==input$Date,]
        
        if (input$State!='All') {
            if (input$Weather!='All') {
                df0 = subset(x, State==input$State & Weather_Condition==input$Weather)
            } else {
                df0 = subset(x, State==input$State)
            }
        } else {
            if (input$Weather!='All') {
                df0 = subset(x, Weather_Condition==input$Weather)
            } else {
                df0 = x
            }
        }
        
        if (input$County!='All') {
            df1 = subset(df0, County==input$County)
        } else {
            df1 = df0
        }
        
        
        if (input$DayNight != 'Both') {
            df2 = subset(df1, Sunrise_Sunset == input$DayNight)
        } else {
            df2 = df1
        }
        
        df = subset(df2, Severity >= input$Severity[1] & Severity <= input$Severity[2] &
                        Visibility.mi. >= input$Visibility[1] & Visibility.mi. <= input$Visibility[2] &
                        Wind_Speed.mph. >= input$WindSpeed[1] & Wind_Speed.mph. <= input$WindSpeed[2]) 
        df
    })
    
    output$numRec <- renderText({
        paste(dim(rt())[1], " Records found")
    })
    
    output$pointMap <- renderLeaflet({
        leaflet(rt()) %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            addAwesomeMarkers(~Start_Lng, ~Start_Lat, icon=icons, popup = ~htmlEscape(Description))
    })
    output$heatMap <- renderLeaflet({
        leaflet(rt()) %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            addHeatmap(lng = ~Start_Lng, lat= ~Start_Lat, blur = 20, max=0.05, radius=15) 
    })
}
