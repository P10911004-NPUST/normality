test_that("skewness", {
    # The sqrt-b1 in D.Agostino is equal to g1 in skewness test
    dap_out <- D.Agostino_Pearson_test(cholesterol)
    dap_skew <- round(dap_out[["summary_table"]][["statistic"]][1], 2) # sqrt-b1
    testthat::expect_equal(dap_skew, round(1.020, 2))

    skew_out <- skewness(cholesterol, method = "g1")
    g1 <- round(skew_out[["statistic"]][["g1"]], 2) # g1

    testthat::expect_equal(dap_skew, g1)

    # The SE(sqrt-b1) in D.Agostino is equal to SE(G1) in skewness test.
    dap_se <- round(dap_out[["summary_table"]][["SE"]][1], 4) # SE(sqrt-b1)
    skew_out <- skewness(cholesterol, method = "G1")
    skew_se <- round(skew_out[["summary_table"]][["SE"]][1], 4) # SE(G1)

    testthat::expect_equal(dap_se, skew_se)
})
