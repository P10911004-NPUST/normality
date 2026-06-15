test_that("Shapiro-Wilk-Royston test", {
    lognorm <- c(48.4, 49, 59.5, 59.6, 60.7, 88.8, 98.2, 109.4, 169.1, 227.1)

    out <- Shapiro_Wilk_test(lognorm, method = "SWR", silent = TRUE)

    W <- round(out[["statistic"]][["W"]], 5)
    pval <- round(out[["pvalue"]], 5)

    testthat::expect_equal(W, 0.80783)
    testthat::expect_equal(pval, 0.01805)

    # ns <- floor(runif(10000, min = 3, max = 5000))
    # for (n in ns)
    # {
    #     x <- rnorm(n)
    #     out1 <- Shapiro_Wilk_test(x, method = "SWR", silent = TRUE)
    #     out2 <- shapiro.test(x)
    #     W1 <- round(out1[["statistic"]][["W"]], 5)
    #     W2 <- round(out2[["statistic"]][["W"]], 5)
    #     pval1 <- round(out1[["pvalue"]], 5)
    #     pval2 <- round(out2[["p.value"]], 5)
    #
    #     if (W1 != W2) print(paste("W", n, W1, W2, sep = ", "))
    #     if (pval1 != pval2) print(paste("pval", n, pval1, pval2, sep = ", "))
    # }
})


test_that("Shapiro-Francia test", {
    piglet_birthweights <- c( 605,  858,  862,  992, 1006, 1018,
                              1020, 1079, 1088, 1110, 1120, 1166)

    out <- Shapiro_Wilk_test(piglet_birthweights, method = "SF", silent = TRUE)

    W <- round(out[["statistic"]][["W'"]], 5)
    pval <- round(out[["pvalue"]], 5)

    testthat::expect_equal(W, 0.84151)
    testthat::expect_equal(pval, 0.02865)

    # ns <- floor(runif(10000, min = 5, max = 5000))
    # for (n in ns)
    # {
    #     x <- rnorm(n)
    #     out1 <- Shapiro_Wilk_test(x, method = "SF", silent = TRUE)
    #     out2 <- nortest::sf.test(x)
    #     W1 <- round(out1[["statistic"]][["W'"]], 5)
    #     W2 <- round(out2[["statistic"]][["W"]], 5)
    #     pval1 <- round(out1[["pvalue"]], 5)
    #     pval2 <- round(out2[["p.value"]], 5)
    #
    #     if (W1 != W2) print(paste("W", n, W1, W2, sep = ", "))
    #     if (pval1 != pval2) print(paste("pval", n, pval1, pval2, sep = ", "))
    # }
})


test_that("Shapiro-Wilk original test", {
    test_data <- c(6, 1, -4, 8, -2, 5, 0)
    out <- Shapiro_Wilk_test(test_data, method = "SW", silent = TRUE)

    W <- round(out[["statistic"]][["W"]], 3)
    testthat::expect_equal(W, 0.953)
})

