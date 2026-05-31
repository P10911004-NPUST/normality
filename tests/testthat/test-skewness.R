test_that("skewness", {
    dap_out <- D.Agostino_Pearson_test(cholesterol)
    dap_skew <- round(dap_out[["summary_table"]][["statistic"]][1], 2)
    dap_se <- round(dap_out[["summary_table"]][["SE"]][1], 4)

    skew_out <- skewness(cholesterol, method = "g1")
    g1 <- round(skew_out[["statistic"]][["g1"]], 2)
    skew_out <- skewness(cholesterol, method = "G1")
    skew_se <- round(skew_out[["statistic"]][["SE"]], 4)

    testthat::expect_equal(dap_skew, g1)
    testthat::expect_equal(dap_se, skew_se)
})
