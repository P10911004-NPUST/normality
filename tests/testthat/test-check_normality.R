test_that("check_normality", {
    cholesterol <- c(393, 353, 334, 336, 327, 300, 300, 308, 283, 285,
                     270, 270, 272, 278, 278, 263, 264, 267, 267, 267,
                     268, 254, 254, 254, 256, 256, 258, 240, 243, 246,
                     247, 248, 230, 230, 230, 230, 231, 232, 232, 232,
                     234, 234, 236, 236, 238, 220, 225, 225, 226, 210,
                     211, 212, 215, 216, 217, 218, 200, 202, 192, 198,
                     184, 167)

    AD_out <- check_normality(cholesterol, silent = TRUE, method = "AD")
    DAP_out <- check_normality(cholesterol, silent = TRUE, method = "DAP")
    SWR_out <- check_normality(cholesterol, silent = TRUE, method = "SWR")

    A2 <- round(AD_out[["statistic"]][["A2"]], 2)
    K2 <- round(DAP_out[["statistic"]][["K2"]], 2)
    W <- round(SWR_out[["statistic"]][["W"]], 5)

    testthat::expect_equal(A2, 1.15)
    testthat::expect_equal(K2, 14.75)
    testthat::expect_equal(W, 0.93857)
})
