## code to prepare `cholesterol` dataset goes here
cholesterol <- read.csv("./data-raw/cholesterol.csv")
cholesterol <- cholesterol[[1]]

usethis::use_data(cholesterol, overwrite = TRUE)
