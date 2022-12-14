library(tidyverse)

new_blob <- function(x_mu = 0, x_sigma = 1, 
                        y_mu = 0, y_sigma = 1,  
                        plot_id = 0, elem_num = 10) {
  # browser()
  x <- round(rnorm(elem_num, x_mu, x_sigma), 0)
  y <- round(rnorm(elem_num, y_mu, y_sigma), 0)
  tibble(x = x, y = y, plot_id = plot_id)
}

new_blobset <- function(blob_param_df = 
                             tibble(x_mu = c(0), x_sigma = c(1), 
                                    y_mu = c(0), y_sigma = c(1),  
                                    plot_id = c(0), elem_num = c(10))) {
  # browser()
  blob_param_df %>% 
    pmap(function(...) new_blob(...)) %>% 
    bind_rows(.)
}

blob_param_df <- tibble(x_mu = c(-5, 1, 10), x_sigma = c(2, 8, 4), 
                        y_mu = c(7, 4, -3), y_sigma = c(5, 3, 9),  
                        plot_id = c(0, 1, 2), elem_num = c(20, 20, 20))

blobset_df <- new_blobset(blob_param_df)

ggplot(data = blobset_df, mapping = aes(x = x, y = y, color = factor(plot_id))) +
  geom_point()
