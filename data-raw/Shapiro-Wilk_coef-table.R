## code to prepare `leghorn_chick` dataset goes here
Shapiro_Wilk_coef_table <- read.csv("./data-raw/Shapiro-Wilk_coef-table.csv")[, -1]

usethis::use_data(Shapiro_Wilk_coef_table, overwrite = TRUE)
