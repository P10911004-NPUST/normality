## code to prepare `leghorn_chick` dataset goes here
Shapiro_Wilk_pval_table <- read.csv("./data-raw/Shapiro-Wilk_pval-table.csv")[, -1]

usethis::use_data(Shapiro_Wilk_pval_table, overwrite = TRUE)
