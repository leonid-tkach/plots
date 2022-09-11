blob_colors <- c('red', 'green', 'blue')

ndistrs_df <- tibble(x_mu = c(-5, 1, 10), x_sigma = c(2, 7, 4), 
                     y_mu = c(7, 4, -3), y_sigma = c(5, 3, 8),  
                     plot_id = c(0, 1, 2), elem_num = c(100, 100, 100))

new_blob <- function(x_mu = 0, x_sigma = 1, 
                     y_mu = 0, y_sigma = 1,  
                     plot_id = 0, elem_num = 10) {
  x <- rnorm(elem_num, x_mu, x_sigma)
  y <- rnorm(elem_num, y_mu, y_sigma)
  tibble(x = x, 
         y = y, 
         x_mu = x_mu,
         y_mu = y_mu,
         plot_id = as.integer(plot_id))
}

new_blobset <- function(blob_param_df = ndistrs_df) {
  blob_param_df %>% 
    pmap(function(...) new_blob(...)) %>% 
    bind_rows(.)
}

function(input, output, session) {
  
  blobset_df <- reactiveVal(new_blobset())
  
  observeEvent(blobset_df(), {
  })

  plot_colors <- reactiveVal()

  observeEvent(input$new_blobset_btn, {
    blobset_df(new_blobset(ndistrs_df))
  })
  
  is_null_plot_colors <- function() {
    if(is_null(plot_colors())) isolate(plot_colors(c('black', 'black', 'black')))
    plot_colors()
  }
  
  output$plot1 <- renderPlot({
    ggplot(data = blobset_df(), mapping = aes(x = x, y = y, color = factor(plot_id))) +
      geom_point() +
      scale_color_manual(
        values = is_null_plot_colors()
      ) +
      xlim(-25, 25) +
      ylim(-25, 25) +
      labs(title = "Normal distribution blobs") +
      theme(plot.title = element_text(size = rel(2)))
  })
  
  output$plot2 <- renderPlot({
    ggplot(data = blobset_df(), mapping = aes(x = x_mu, 
                                              y = y_mu, 
                                              color = factor(plot_id))) +
      geom_point(size = 12) +
      scale_color_manual(
        values = is_null_plot_colors()
      ) +
      xlim(-25, 25) +
      ylim(-25, 25) +
      labs(title = "Mean (mu) for the above blobs. Click!") +
      theme(plot.title = element_text(size = rel(2)))
  })
  
  observeEvent(input$plot2_click, {
    clicked_plot_id <- nearPoints(blobset_df(), 
                                  input$plot2_click, 
                                  threshold = 10, 
                                  maxpoints = 1)$plot_id
    # browser()
    plot_colors_nr <- plot_colors()
    plot_colors_nr[clicked_plot_id+1] <- if_else(plot_colors_nr[clicked_plot_id+1] == 'black', 
                                                 blob_colors[clicked_plot_id+1],
                                                 'black')
    plot_colors(plot_colors_nr)
  })
}