#' Skewness test
#'
#' @param x Numeric vector. The input data.
#' @param alpha Numeric (default: 0.05). Significance threshold (0 - 1).
#' @param alternative Character (default: "two.sided).
#'      The alternative hypothesis (H1) to test. Available options are c("two.sided", "less", "greater").
#' @param method Character (default: "G1"). Different skewness formula.
#'      Available options are c("G1", "b1", "g1"). The "g1" is the original one.
#'      The "G1" and "b1" are the unbiased estimate version of "g1".
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
#' skewness(cholesterol)
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
skewness <- function(
        x,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater"),
        method = c("G1", "b1", "g1")
){
    stopifnot(alpha >= 0 & alpha <= 1)
    alt <- match.arg(alternative[1], c("two.sided", "less", "greater"))
    method <- match.arg(method[1], c("G1", "b1", "g1"))

    x <- x[stats::complete.cases(x)]
    n <- length(x)
    avg <- mean(x)

    m2 <- sum((x - avg) ^ 2) / n
    m3 <- sum((x - avg) ^ 3) / n

    g1 <- m3 / sqrt(m2 ^ 3)
    var_g1 <- 6 * (n - 2) / ((n + 1) * (n + 3))
    se_g1 <- sqrt(var_g1)

    if (method == "g1")
    {
        skew <- g1
        se <- se_g1
        Zs <- g1 / se
    }

    if (method == "G1")
    {
        skew <- g1 * sqrt(n * (n - 1)) / (n - 2)
        se <- se_g1 * sqrt(n * (n - 1)) / (n - 2)
        Zs <- skew / se
    }

    if (method == "b1")
    {
        skew <- g1 * sqrt(((n - 1) / n) ^ 3)
        se <- se_g1 * sqrt(((n - 1) / n) ^ 3)
        Zs <- skew / se
    }

    pval <- stats::pnorm(Zs, lower.tail = FALSE) * 2

    if (alt == "two.sided")
    {
        Zs_pval <- if (pval > 1) 2 - pval else pval
        Zcrit <- stats::qnorm(1 - alpha / 2)
    }

    if (alt == "less") # skewness < 0, the peak towards right
    {
        Zs_pval <- pval / 2
        Zcrit <- stats::qnorm(1 - alpha)
    }

    if (alt == "greater") # skewness > 0, the peak towards left
    {
        Zs_pval <- 1 - pval / 2
        Zcrit <- stats::qnorm(alpha)
    }

    CI_lower <- skew - se * Zcrit
    CI_upper <- skew + se * Zcrit

    tab <- data.frame(
        check.names = FALSE,
        row.names = sprintf("skewness (%s)", method),
        "statistic" = skew,
        "Z" = Zs,
        "Zcrit" = Zcrit,
        "SE" = se,
        "pval" = Zs_pval,
        "CI_lower" = CI_lower,
        "CI_upper" = CI_upper
    )

    normality_standard_output(
        method = sprintf("Skewness (%s) test", method),
        is_normal = (Zs_pval > alpha),
        alpha = alpha,
        alternative = alt,
        summary_table = tab,
        statistic = stats::setNames(skew, method),
        pvalue = Zs_pval,
        confidence_interval = c("lower" = CI_lower, "upper" = CI_upper)
    )
}





# Pearson_skewness <- function(x, center = c("median", "mode"))
# {
#     center <- match.arg(center, c("median", "mode"))
#
#     if (center == "mode")
#     {
#         # Pearson's First Coefficient of Skewness
#         ## This is not reliable when the mode is only a few pieces of data
#         x <- x[stats::complete.cases(x)]
#         `_mode_` <- sort(x)[unname(which.max(table(x)))]
#         skew <- (mean(x) - `_mode_`) / stats::sd(x)
#     }
#
#     if (center == "median")
#     {
#         # Pearson's Second Coefficient of Skewness
#         x <- x[stats::complete.cases(x)]
#         skew <- 3 * (mean(x) - stats::median(x)) / stats::sd(x)
#     }
#
#     return(skew)
# }




Fisher_Pearson_skewness <- function(x, adjusted = TRUE)
{
    # Adjusted Fisher-Pearson Skewness Coefficient
    x <- x[stats::complete.cases(x)]
    xbar <- mean(x)
    n <- length(x)

    if (FALSE)
    {
        ## Guthrie, W.F., 2020.
        ## NIST/SEMATECH e-Handbook of Statistical Methods (NIST Handbook 151).
        ## https://doi.org/10.18434/M32189
        std.p <- sqrt(sum((x - xbar) ^ 2) / n)  # Population's standard deviation
        g1 <- sum((x - xbar) ^ 3) / (n * std.p ^ 3)
        if (isTRUE(adjusted))
            g1 <- sqrt(n * (n - 1)) / (n - 2) * g1
    }

    if (TRUE)
    {
        ## from D'Agostino et al., 1990
        ## also noted as Fisher g statistics, g1
        ## the output from here is identical to the above
        g1 <- sum(((x - xbar) / stats::sd(x)) ^ 3)
        if (isTRUE(adjusted))
            g1 <- g1 * n / ((n - 1) * (n - 2))
    }

    return(g1)
}

