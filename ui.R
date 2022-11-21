library(shiny)
library(tidyverse)
library(dygraphs)

fluidPage(
  fluidRow(
    actionButton("new_blobset_btn", "New Blobset")
  ),
  fluidRow(
    plotOutput("plot1", click = "plot1_click"),
  ),
  fluidRow(
    plotOutput("plot2", click = "plot2_click"),
  ),
  fluidRow(
    dygraphOutput("plot3"),
  ),
  fluidRow(
    tableOutput("near_points")
  )
)