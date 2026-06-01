#' Kurtosis test
#'
#' @param x Numeric vector. The input data.
#' @param alpha Numeric (default: 0.05). Significance threshold (0 - 1).
#' @param alternative Character (default: "two.sided).
#'      The alternative hypothesis (H1) to test. Available options are c("two.sided", "less", "greater").
#' @param method Character (default: "G2"). Different skewness formula.
#'      Available options are c("G2", "b2", "g2"). The "g2" is the original one.
#'      The "G2" and "b2" are the unbiased estimate version of "g2".
#'
#' @returns A list:
#' is_normal: Is the input data normally distributed?
#' method: The name of the test.
#' alpha: Significance threshold (default: 0.05).
#' alternative: The alternative hypothesis (H1) to test.
#' summary_table: Statistic summary, if any.
#' statistic: The value used to calculate p-value.
#' pvalue: p-value.
#' confidence_interval: The lower and upper bound of CI.
#'
#' @examples
#' x <- c(10:17, 12, 12, 13, 13, 13, 13, 13, 14, 14, 14, 15, 15)
#' kurtosis(x)
#' @references
#' Joanes, D.N., Gill, C.A., 1998.
#' Comparing measures of sample skewness and kurtosis.
#' J Royal Statistical Soc D 47, 183–189.
#' https://doi.org/10.1111/1467-9884.00122
#'
#' Wright, D.B., Herrington, J.A., 2011.
#' Problematic standard errors and confidence intervals for skewness and kurtosis.
#' Behav Res 43, 8–17.
#' https://doi.org/10.3758/s13428-010-0044-x
#' @export
kurtosis <- function(
        x,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater"),
        method = c("G2", "b2", "g2")
){
    stopifnot(alpha >= 0 & alpha <= 1)
    alt <- match.arg(alternative[1], c("two.sided", "less", "greater"))
    method <- match.arg(method[1], c("G2", "b2", "g2"))

    x <- x[stats::complete.cases(x)]
    n <- length(x)
    avg <- mean(x)

    m2 <- sum((x - avg) ^ 2) / n
    m4 <- sum((x - avg) ^ 4) / n

    g2 <- (m4 / (m2 ^ 2)) - 3
    var_g2 <- 24 * n * (n - 2) * (n - 3) / ((n + 1) * (n + 1) * (n + 3) * (n + 5))
    se_g2 <- sqrt(var_g2)

    if (method == "g2")
    {
        kurt <- g2
        se <- se_g2
        Zk <- g2 / se
    }

    if (method == "G2")
    {
        kurt <- ((n - 1) * ((n + 1) * g2 + 6)) / ((n - 2) * (n - 3))
        se <- ((n - 1) * (n + 1) / ((n - 2) * (n - 3))) * se_g2
        Zk <- kurt / se
    }

    if (method == "b2")
    {
        kurt <- (((n - 1) / n) ^ 2) * (m4 / (m2 ^ 2)) - 3
        se <- (((n - 1) / n) ^ 2) * se_g2
        Zk <- kurt / se
    }

    pval <- stats::pnorm(Zk, lower.tail = FALSE) * 2

    if (alt == "two.sided")
    {
        Zk_pval <- if (pval > 1) 2 - pval else pval
        Zcrit <- stats::qnorm(1 - alpha / 2)
    }

    if (alt == "less") # kurtosis < 3, low peak
    {
        Zk_pval <- pval / 2
        Zcrit <- stats::qnorm(1 - alpha)
    }

    if (alt == "greater") # kurtosis > 3, high peak
    {
        Zk_pval <- 1 - pval / 2
        Zcrit <- stats::qnorm(alpha)
    }

    kurt <- kurt + 3
    CI_lower <- kurt - se * Zcrit
    CI_upper <- kurt + se * Zcrit

    tab <- data.frame(
        check.names = FALSE,
        row.names = sprintf("kurtosis (%s)", method),
        "statistic" = kurt,
        "Z" = Zk,
        "Zcrit" = Zcrit,
        "SE" = se,
        "pval" = Zk_pval,
        "CI_lower" = CI_lower,
        "CI_upper" = CI_upper
    )

    normality_standard_output(
        method = sprintf("Kurtosis (%s) test", method),
        is_normal = (Zk_pval > alpha),
        alpha = alpha,
        alternative = alt,
        summary_table = tab,
        statistic = stats::setNames(kurt, method),
        pvalue = Zk_pval,
        confidence_interval = c("lower" = CI_lower, "upper" = CI_upper)
    )
}
