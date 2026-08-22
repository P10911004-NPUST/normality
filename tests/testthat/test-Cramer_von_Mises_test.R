test_that("Cramer_von_Mises_test", {
    lognorm <- c(48.4, 49, 59.5, 59.6, 60.7, 88.8, 98.2, 109.4, 169.1, 227.1)
    out <- Cramer_von_Mises_test(lognorm, silent = TRUE)
    mW2 <- unname(round(out$statistic, 4))
    pval <- unname(round(out$pvalue, 5))
    testthat::expect_equal(mW2, 0.1379)
    testthat::expect_equal(pval, 0.02791)

    piglet_birthweights <- c( 605,  858,  862,  992, 1006, 1018,
                              1020, 1079, 1088, 1110, 1120, 1166)
    out <- Cramer_von_Mises_test(piglet_birthweights, silent = TRUE)
    mW2 <- unname(round(out$statistic, 4))
    pval <- unname(round(out$pvalue, 5))
    testthat::expect_equal(mW2, 0.1132)
    testthat::expect_equal(pval, 0.06397)
})
