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

new_blobset <- function(blob_param_df = 
                          tibble(x_mu = c(0), x_sigma = c(1), 
                                 y_mu = c(0), y_sigma = c(1),  
                                 plot_id = c(0), elem_num = c(10))) {
  blob_param_df %>% 
    pmap(function(...) new_blob(...)) %>% 
    bind_rows(.)
}

function(input, output, session) {
  
  blobset_df <- reactiveVal(new_blobset(), label = 'blobset_df')
  
  observeEvent(blobset_df(), {
  })

  plot_colors <- reactiveVal()

  observeEvent(input$new_blobset_btn, label = 'observe: new_blobset_btn', {
    blobset_df(
      new_blobset(
        tibble(x_mu = c(-5, 1, 10), x_sigma = c(2, 8, 4), 
               y_mu = c(7, 4, -3), y_sigma = c(5, 3, 9),  
               plot_id = c(0, 1, 2), elem_num = c(50, 50, 50))))
    plot_colors(rep('black', length(blobset_df()$plot_id %>% unique())))
  })
  
  output$plot1 <- renderPlot({
    ggplot(data = blobset_df(), mapping = aes(x = x, y = y, color = factor(plot_id))) +
      geom_point() +
      scale_color_manual(
        values = (function() {
          if(is_null(plot_colors())) c('black')
          else plot_colors()
        })())
  })
  
  output$plot2 <- renderPlot({
    ggplot(data = blobset_df(), mapping = aes(x = x_mu, y = y_mu, color = factor(plot_id))) +
      geom_point() +
      scale_color_manual(
        values = (function() {
          if(is_null(plot_colors())) c('black')
          else plot_colors()
        })())
  })
  
  # output$near_points <- renderTable({
  #   nearPoints(blobset_df(), input$plot1_click, threshold = 10, maxpoints = 1, addDist = TRUE)
  # })
  
  observeEvent(input$plot2_click, {
    clicked_plot_id <- nearPoints(blobset_df(), 
                                  input$plot2_click, 
                                  threshold = 10, 
                                  maxpoints = 1)$plot_id
    plot_colors_nr <- rep('black', length(blobset_df()$plot_id %>% unique()))
    plot_colors_nr[clicked_plot_id+1] <- 'magenta'
    plot_colors(plot_colors_nr)
  })
}