#' D'Agostino-Pearson K2 test for normal distribution inferences.
#'
#' The D'Agostino–Pearson K<sup>2</sup> test is a statistical test for assessing whether a sample comes from a normal distribution.
#' It combines information from:
#' - skewness (asymmetry)
#' - kurtosis (tail heaviness)
#' into a single omnibus test statistic.
#'
#' @param x A numeric vector.
#' @param alpha Significance threshold (default: 0.05).
#' @param alternative Character. The alternative hypothesis (H1) to test.
#'      Available options are c("two.sided", "less", "greater").
#'      Note that, this is only applicable on skewness and kurtosis test.
#'
#' @returns A list:
#' bool: Is the input data normally distributed?
#' method: The name of the test.
#' alpha: Significance threshold (default: 0.05).
#' alternative: The alternative hypothesis (H1) to test.
#' summary_table: Statistic summary, if any.
#' statistic: The value used to calculate p-value.
#' pvalue: p-value.
#' confidence_interval: The lower and upper bound of CI.
#'
#' @examples
#' D.Agostino_Pearson_test(cholesterol)
#'
#' @references
#' D’agostino, R.B., Belanger, A., D’agostino, R.B., 1990.
#' A Suggestion for Using Powerful and Informative Tests of Normality.
#' The American Statistician 44, 316–321.
#' https://doi.org/10.1080/00031305.1990.10475751
#' @export
D.Agostino_Pearson_test <- function(
        x,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater"),
        min_n = 20
) {
    alt <- match.arg(alternative)
    x <- x[stats::complete.cases(x)]
    n <- length(x)
    avg <- mean(x)

    if (n < min_n)
        warning(sprintf("Sample size less than %s, this test is inappropriate.", min_n))

    skewness <- D.Agostino_skewness(x, alpha, alt)
    Zs <- skewness[["statistic"]][["Z(sqrt-b1)"]]

    kurtosis <- D.Agostino_kurtosis(x, alpha, alt)
    Zk <- kurtosis[["statistic"]][["Z(b2)"]]

    # K-square omnibus test
    K2 <- (Zs ^ 2) + (Zk ^ 2)
    pval <- stats::pchisq(K2, df = 2, lower.tail = FALSE)

    normality_standard_output(
        method = "D'Agostino-Pearson K-square omnibus test",
        bool = (pval > 0.05),
        alpha = alpha,
        statistic = c("K2" = K2),
        pvalue = pval
    )
}

