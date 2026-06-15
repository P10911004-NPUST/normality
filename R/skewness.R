#' Skewness test
#'
#' The test evaluates whether the population skewness is equal to zero.
#' Under the null hypothesis, the data are assumed to originate from a
#' symmetric distribution. Significant positive or negative skewness
#' indicates asymmetry in the distribution and may suggest a departure
#' from normality.
#'
#' @param x Numeric vector containing the input data.
#' @param alpha Numeric (default: 0.05). Significance level for hypothesis
#'   testing. Must be between 0 and 1.
#' @param alternative Character (default: "two.sided").
#'   Specifies the alternative hypothesis. Available options are
#'   c("two.sided", "less", "greater").
#' @param method Character (default: "G1"). Formula used to estimate
#'   skewness. Available options are c("G1", "b1", "g1").
#'   The "g1" statistic is the conventional moment-based sample skewness.
#'   The "G1" and "b1" statistics apply finite-sample corrections to reduce
#'   the bias of "g1".
#' @param silent Logical (default: FALSE). If `FALSE`, the test results are
#'   printed to the console.
#'
#' @returns A list
#'
#' @examples
#' skewness(rnorm(30))
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
skewness <- function(
        x,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater"),
        method = c("G1", "b1", "g1"),
        silent = FALSE
){
    alt <- match.arg(alternative[1], c("two.sided", "less", "greater"))
    method <- match.arg(method[1], c("G1", "b1", "g1"))

    x <- x[stats::complete.cases(x)]
    n <- length(x)
    avg <- mean(x)

    if (x[1] - x[n] == 0) stop("All values are identical.")

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

    tab <- normality_standard_summary_table(
        method = sprintf("skewness (%s)", method),
        alpha = alpha,
        statistic = skew,
        pval = Zs_pval,
        signif = pval2asterisk(pval, c(alpha, 0.01, 0.001)),
        standard_value = Zs,
        critical_value = Zcrit,
        SE = se,
        CI_lower = CI_lower,
        CI_upper = CI_upper
    )

    ret <- normality_standard_output(
        method = sprintf("Skewness (%s) test", method),
        is_normal = (Zs_pval > alpha),
        alpha = alpha,
        alternative = alt,
        summary = tab,
        statistic = stats::setNames(skew, method),
        pvalue = Zs_pval
    )

    if (isFALSE(silent))
    {
        cat("\n--------------------------------------\n")
        cat("Skewness test", "\n\n")
        cat("Alternative:", alt, "\n\n")
        cat(sprintf("Skewness (%s) = %s\n", method, round(skew, 4)))
        cat(sprintf("p-value = %s", round(pval, 5)))
        cat("\n--------------------------------------\n")
    }

    invisible(ret)
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

