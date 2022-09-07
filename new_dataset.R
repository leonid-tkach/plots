library(tidyverse)

new_blob_df <- function(x_mu = 0, x_sigma = 1, 
                        y_mu = 0, y_sigma = 1,  
                        plot_id = 0, elem_num = 10) {
  x <- round(rnorm(elem_num, x_mu, x_sigma), 0)
  y <- round(rnorm(elem_num, y_mu, y_sigma), 0)
  tibble(x = x, y = y, plot_id = plot_id)
}

new_blob_df(5, 4, 10, 4, 0)
