library(shiny)
library(tidyverse)

fluidPage(
  fluidRow(
    actionButton("new_blobset_btn", "New Blobset")
  ),
  fluidRow(
    plotOutput("plot1", click = "plot1_click"),
    tableOutput("near_points")
  )
)