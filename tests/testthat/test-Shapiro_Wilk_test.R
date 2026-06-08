test_that("Shapiro-Wilk original test", {
    test_data <- c(6, 1, -4, 8, -2, 5, 0)
    out <- Shapiro_Wilk_test(test_data, method = "sw")

    W <- round(out[["statistic"]][["W"]], 3)
    expect_equal(W, 0.953)
})
