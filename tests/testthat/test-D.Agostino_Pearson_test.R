test_that("D.Agostino_Pearson_test", {
    cholesterol <- c(393, 353, 334, 336, 327, 300, 300, 308, 283, 285,
                     270, 270, 272, 278, 278, 263, 264, 267, 267, 267,
                     268, 254, 254, 254, 256, 256, 258, 240, 243, 246,
                     247, 248, 230, 230, 230, 230, 231, 232, 232, 232,
                     234, 234, 236, 236, 238, 220, 225, 225, 226, 210,
                     211, 212, 215, 216, 217, 218, 200, 202, 192, 198,
                     184, 167)

    dap_out <- D.Agostino_Pearson_test(cholesterol, silent = TRUE)

    b1 <- round(dap_out[["summary"]][["statistic"]][[1]], 2)
    b2 <- round(dap_out[["summary"]][["statistic"]][[2]], 2)
    Zs <- round(dap_out[["summary"]][["standard_value"]][[1]], 2)
    Zk <- round(dap_out[["summary"]][["standard_value"]][[2]], 2)
    b1_pval <- round(dap_out[["summary"]][["pval"]][[1]], 4)
    b2_pval <- round(dap_out[["summary"]][["pval"]][[2]], 4)
    K2 <- round(dap_out[["statistic"]][["K2"]], 2)
    pval <- round(dap_out[["pvalue"]], 4)

    testthat::expect_equal(b1, 1.02)
    testthat::expect_equal(b2, 4.58)
    testthat::expect_equal(Zs, 3.14)
    testthat::expect_equal(Zk, 2.21)
    testthat::expect_equal(b1_pval, 0.0017)
    testthat::expect_equal(b2_pval, 0.0269)
    testthat::expect_equal(K2, 14.75)
    testthat::expect_equal(pval, 0.0006)
})
