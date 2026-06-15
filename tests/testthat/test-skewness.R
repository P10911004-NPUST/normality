test_that("skewness", {
    cholesterol <- c(393, 353, 334, 336, 327, 300, 300, 308, 283, 285,
                     270, 270, 272, 278, 278, 263, 264, 267, 267, 267,
                     268, 254, 254, 254, 256, 256, 258, 240, 243, 246,
                     247, 248, 230, 230, 230, 230, 231, 232, 232, 232,
                     234, 234, 236, 236, 238, 220, 225, 225, 226, 210,
                     211, 212, 215, 216, 217, 218, 200, 202, 192, 198,
                     184, 167)

    # The sqrt-b1 in D.Agostino is equal to g1 in skewness test
    dap_out <- D.Agostino_Pearson_test(cholesterol, silent = TRUE)
    dap_skew <- round(dap_out[["summary"]][["statistic"]][1], 2) # sqrt-b1
    testthat::expect_equal(dap_skew, round(1.020, 2))

    skew_out <- skewness(cholesterol, method = "g1", silent = TRUE)
    g1 <- round(skew_out[["statistic"]][["g1"]], 2) # g1

    testthat::expect_equal(dap_skew, g1)

    # The SE(sqrt-b1) in D.Agostino is equal to SE(G1) in skewness test.
    dap_se <- round(dap_out[["summary"]][["SE"]][1], 4) # SE(sqrt-b1)
    skew_out <- skewness(cholesterol, method = "G1", silent = TRUE)
    skew_se <- round(skew_out[["summary"]][["SE"]][1], 4) # SE(G1)

    testthat::expect_equal(dap_se, skew_se)
})
