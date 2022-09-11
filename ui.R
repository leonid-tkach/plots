library(shiny)
library(tidyverse)

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
    tableOutput("near_points")
  )
)