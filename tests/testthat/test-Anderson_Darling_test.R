test_that("Anderson-Darling test", {
    leghorn_chick <- c(156, 162, 168, 182, 186, 190, 190, 196, 202, 210,
                       214, 220, 226, 230, 230, 236, 236, 242, 246, 270)
    out <- Anderson_Darling_test(leghorn_chick, silent = TRUE)
    A2 <- round(out[["statistic"]][["A2"]], 3)
    mA2 <- round(out[["summary"]][["standard_value"]], 3)
    pval <- round(out[["pvalue"]], 3)

    testthat::expect_equal(A2, 0.214)
    testthat::expect_equal(mA2, 0.223)
    testthat::expect_equal(pval, 0.826)
})


# # Test for normal distribution
# n <- ceiling(runif(1000, min = 8, max = 1000))
# for (i in 1:1000)
# {
#     x <- rnorm(n[i])
#
#     nort <- nortest::ad.test(x)
#     A2_nort <- unname(round(nort[["statistic"]], 4))
#     pval_nort <- round(nort[["p.value"]], 4)
#
#     out <- normality::Anderson_Darling_test(x, silent = TRUE)
#     A2 <- unname(round(out[["statistic"]], 4))
#     pval <- round(out[["pvalue"]], 4)
#
#     if (pval != pval_nort | A2 != A2_nort) print("Fail")
# }


# # Test for uniform distribution
# n <- ceiling(runif(1000, min = 8, max = 1000))
# for (i in 1:1000)
# {
#     x <- runif(n[i])
#
#     nort <- nortest::ad.test(x)
#     A2_nort <- unname(round(nort[["statistic"]], 4))
#     pval_nort <- round(nort[["p.value"]], 4)
#
#     out <- normality::Anderson_Darling_test(x, silent = TRUE)
#     A2 <- unname(round(out[["statistic"]], 4))
#     pval <- round(out[["pvalue"]], 4)
#
#     if (pval != pval_nort | A2 != A2_nort) print("Fail")
# }


# # Test for right-skewed distribution
# n <- ceiling(runif(1000, min = 8, max = 1000))
# for (i in 1:1000)
# {
#     x <- rnorm(n[i]) ^ 2
#
#     nort <- nortest::ad.test(x)
#     A2_nort <- unname(round(nort[["statistic"]], 4))
#     pval_nort <- round(nort[["p.value"]], 4)
#
#     out <- normality::Anderson_Darling_test(x, silent = TRUE)
#     A2 <- unname(round(out[["statistic"]], 4))
#     pval <- round(out[["pvalue"]], 4)
#
#     if (pval != pval_nort | A2 != A2_nort)
#         print(sprintf("A2 = (%s, %s); p = (%s, %s)", A2, A2_nort, pval, pval_nort))
# }


# # Test for left-skewed distribution
# n <- ceiling(runif(1000, min = 8, max = 1000))
# for (i in 1:1000)
# {
#     x <- sqrt(rnorm(n[i], 10, 2))
#     nort <- nortest::ad.test(x)
#     A2_nort <- unname(round(nort[["statistic"]], 4))
#     pval_nort <- round(nort[["p.value"]], 4)
#
#     out <- normality::Anderson_Darling_test(x, silent = TRUE)
#     A2 <- unname(round(out[["statistic"]], 4))
#     pval <- round(out[["pvalue"]], 4)
#
#     if (pval != pval_nort | A2 != A2_nort)
#         print(sprintf("A2 = (%s, %s); p = (%s, %s)", A2, A2_nort, pval, pval_nort))
# }
