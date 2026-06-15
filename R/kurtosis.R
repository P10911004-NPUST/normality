#' Kurtosis test
#'
#' Performs a kurtosis test to assess whether a distribution deviates from
#' normality in terms of tail heaviness.
#'
#' The test evaluates the null hypothesis that the population kurtosis is
#' equal to 3, which is the kurtosis of a normal distribution.
#' Values significantly different from 3 indicate deviations from normality,
#' such as heavy-tailed or light-tailed behavior.
#'
#' @param x Numeric vector containing the input data.
#' @param alpha Numeric (default: 0.05). Significance level for hypothesis
#'   testing. Must be between 0 and 1.
#' @param alternative Character (default: "two.sided").
#'   Specifies the alternative hypothesis. Available options are
#'   c("two.sided", "less", "greater").
#' @param method Character (default: "G2"). Formula used to estimate
#'   kurtosis. Available options are c("G2", "b2", "g2").
#'   The "g2" statistic is the classical sample kurtosis estimator,
#'   while "G2" and "b2" are bias-corrected versions of "g2".
#' @param silent Logical (default: FALSE). If `FALSE`, results are printed
#'   to the console.
#'
#' @returns A list
#'
#' @examples
#' x <- c(10:17, 12, 12, 13, 13, 13, 13, 13, 14, 14, 14, 15, 15)
#' kurtosis(x)
#' @references
#' Joanes, D.N., Gill, C.A., 1998.
#' Comparing measures of sample skewness and kurtosis.
#' J. R. Stat. Soc. D (The Statistician) 47, 183–189.
#' https://doi.org/10.1111/1467-9884.00122
#'
#' Wright, D.B., Herrington, J.A., 2011.
#' Problematic standard errors and confidence intervals for skewness and kurtosis.
#' Behav. Res. Methods 43, 8–17.
#' https://doi.org/10.3758/s13428-010-0044-x
#' @export
kurtosis <- function(
        x,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater"),
        method = c("G2", "b2", "g2"),
        silent = FALSE
){
    alt <- match.arg(alternative[1], c("two.sided", "less", "greater"))
    method <- match.arg(method[1], c("G2", "b2", "g2"))

    x <- x[stats::complete.cases(x)]
    n <- length(x)
    avg <- mean(x)

    if (x[1] - x[n] == 0) stop("All values are identical.")

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

    tab <- normality_standard_summary_table(
        method = sprintf("kurtosis (%s)", method),
        alpha = alpha,
        statistic = kurt,
        pval = Zk_pval,
        signif = pval2asterisk(pval, c(alpha, 0.01, 0.001)),
        standard_value = Zk,
        critical_value = Zcrit,
        SE = se,
        CI_lower = CI_lower,
        CI_upper = CI_upper
    )

    ret <- normality_standard_output(
        method = sprintf("Kurtosis (%s) test", method),
        is_normal = (Zk_pval > alpha),
        alpha = alpha,
        alternative = alt,
        summary = tab,
        statistic = stats::setNames(kurt, method),
        pvalue = Zk_pval
    )

    if (isFALSE(silent))
    {
        cat("\n--------------------------------------\n")
        cat("Kurtosis test", "\n\n")
        cat("Alternative:", alt, "\n\n")
        cat(sprintf("Kurtosis (%s) = %s\n", method, round(kurt, 4)))
        cat(sprintf("p-value = %s", round(pval, 5)))
        cat("\n--------------------------------------\n")
    }

    invisible(ret)
}
