test_that("kurtosis", {
    x <- c(10:17, 12, 12, 13, 13, 13, 13, 13, 14, 14, 14, 15, 15)
    G2 <- round(kurtosis(x, method = "G2", silent = TRUE)[["statistic"]][["G2"]], 4)
    b2 <- round(kurtosis(x, method = "b2", silent = TRUE)[["statistic"]][["b2"]], 4)

    testthat::expect_equal(G2 - 3, 0.2743)
    testthat::expect_equal(b2 - 3, -0.3605)

    # The b2 in D.Agostino is equal to g2 in kurtosis test
    cholesterol <- c(393, 353, 334, 336, 327, 300, 300, 308, 283, 285,
                     270, 270, 272, 278, 278, 263, 264, 267, 267, 267,
                     268, 254, 254, 254, 256, 256, 258, 240, 243, 246,
                     247, 248, 230, 230, 230, 230, 231, 232, 232, 232,
                     234, 234, 236, 236, 238, 220, 225, 225, 226, 210,
                     211, 212, 215, 216, 217, 218, 200, 202, 192, 198,
                     184, 167)

    dap_out <- D.Agostino_Pearson_test(cholesterol, silent = TRUE)
    dap_kurt <- round(dap_out[["summary"]][["statistic"]][2], 2) # b2

    testthat::expect_equal(dap_kurt, 4.580)

    kurt_out <- kurtosis(cholesterol, method = "g2", silent = TRUE)
    g2 <- round(kurt_out[["statistic"]][["g2"]], 2) # g2

    testthat::expect_equal(dap_kurt, g2)

    # The SE(b2) in D.Agostino is equal to SE(G2) in kurtosis test.
    dap_se <- round(dap_out[["summary"]][["SE"]][2], 4) # SE(b2)
    kurt_out <- kurtosis(cholesterol, method = "G2", silent = TRUE)
    kurt_se <- round(kurt_out[["summary"]][["SE"]], 4) # SE(G2)

    testthat::expect_equal(dap_se, kurt_se)
})
