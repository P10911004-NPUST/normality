test_that("kurtosis", {
    x <- c(10:17, 12, 12, 13, 13, 13, 13, 13, 14, 14, 14, 15, 15)
    G2 <- round(kurtosis(x, method = "G2")[["statistic"]][["G2"]], 4)
    b2 <- round(kurtosis(x, method = "b2")[["statistic"]][["b2"]], 4)

    testthat::expect_equal(G2 - 3, 0.2743)
    testthat::expect_equal(b2 - 3, -0.3605)

    # The b2 in D.Agostino is equal to g2 in kurtosis test
    dap_out <- D.Agostino_Pearson_test(cholesterol)
    dap_kurt <- round(dap_out[["summary_table"]][["statistic"]][2], 2) # b2

    testthat::expect_equal(dap_kurt, 4.580)

    kurt_out <- kurtosis(cholesterol, method = "g2")
    g2 <- round(kurt_out[["statistic"]][["g2"]], 2) # g2

    testthat::expect_equal(dap_kurt, g2)

    # The SE(b2) in D.Agostino is equal to SE(G2) in kurtosis test.
    dap_se <- round(dap_out[["summary_table"]][["SE"]][2], 4) # SE(b2)
    kurt_out <- kurtosis(cholesterol, method = "G2")
    kurt_se <- round(kurt_out[["summary_table"]][["SE"]], 4) # SE(G2)

    testthat::expect_equal(dap_se, kurt_se)
})
