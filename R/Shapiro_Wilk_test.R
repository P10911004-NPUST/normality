#' Shapiro-Wilk Normality Test
#'
#' Performs the Shapiro-Wilk test of normality.
#'
#' @param x A numeric vector.
#' @param alpha Significance threshold (default: 0.05).
#' @param method Character (default: "swr"). Use which modification of the test?
#'        Available options are c("swr", "sf", "sw").
#' @details
#' method
#'  - "swr": Shapiro-Wilk-Royston, extended by Royston.
#'  - "sf": Shapiro-Francia, modified by Francia.
#'  - "sw": Shapiro-Wilk, the original test.
#'
#' @returns A list.
#'
#' @examples
#' Shapiro_Wilk_test(rnorm(20), method = "sw")
#' @export
Shapiro_Wilk_test <- function(x, alpha = 0.05, method = c("swr", "sf", "sw"))
{
    m <- tolower(method)
    m <- match.arg(m, c("swr", "sf", "sw"))
    f <- switch(
        match(m, c("swr", "sf", "sw")),
        .Shapiro_Wilk_Royston,
        .Shapiro_Francia,
        .Shapiro_Wilk_original
    )

    f(x, alpha)
}


#==============================================================================#
# Internal function
#==============================================================================#

#' Shapiro-Wilk Normality Test
#'
#' The original version of the W test.
#'
#' @param x Numeric vector.
#' @param alpha Numeric (default: 0.05). Significance threshold, range from 0 to 1.
#'
#' @returns A list, see `normality_standard_output()`.
#'
#' @references
#' Shapiro, S.S., Wilk, M.B., 1965.
#' An Analysis of Variance Test for Normality (Complete Samples).
#' Biometrika 52, 591–611.
#' https://doi.org/10.2307/2333709
.Shapiro_Wilk_original <- function(x, alpha = 0.05)
{
    x <- sort(x[stats::complete.cases(x)])
    n <- length(x)
    avg <- mean(x)
    SS <- sum((x - avg) ^ 2)

    if (n < 3 || n > 50)
        stop("Sample size should be 3 < n < 50.")

    # Not sure how much impact the ties will have.
    # How to determine the severity and how to handle them?
    if (is_tied(x))
        warning("Too many tied-values.")

    # If n is odd, remove the middle one, then x will become even
    if (n %% 2 != 0)
        x <- x[-((n + 1) / 2)]

    x1 <- sort(x)
    x2 <- rev(x1)

    a_ref <- unname(unlist(Shapiro_Wilk_coef_table[n, , drop = TRUE]))

    b <- vapply(X = 1:(n / 2),
                FUN = function(i) a_ref[[i]] * (x2[i] - x1[i]),
                FUN.VALUE = numeric(1))
    b <- sum(b)
    W <- (b ^ 2) / SS

    p_ref <- c(0, 0.01, 0.02, 0.05, 0.1, 0.5, 0.9, 0.95, 0.98, 0.99)
    W_crit <- Shapiro_Wilk_pval_table[n, , drop = TRUE] # this is a list
    imin <- sum(W > unlist(W_crit))
    # interpolate() <<< from utils.R
    pval <- interpolate(idx_i = W,
                        idx_1 = W_crit[[imin]],
                        idx_2 = W_crit[[imin + 1]],
                        val_1 = p_ref[imin],
                        val_2 = p_ref[imin + 1])

    tab <- normality_standard_summary_table(
        method = "Shapiro-Wilk (W)",
        statistic = W,
        critical_value = unname(W_crit[[4]]),
        pval = pval
    )

    normality_standard_output(
        method = "Shapiro-Wilk normality test",
        is_normal = (pval > alpha),
        alpha = alpha,
        alternative = "greater",
        summary_table = tab,
        statistic = c("W" = W),
        pvalue = pval
    )
}


#' Shapiro-Francia Normality Test
#'
#' Performs the Shapiro-Francia test of normality.
#'
#' @param x Numeric vector.
#'
#' @returns A list.
#'
#' @references
#' Shapiro, S.S., Francia, R.S., 1972.
#' An Approximate Analysis of Variance Test for Normality.
#' J. Am. Stat. Assoc. 67, 215–216.
#' https://doi.org/10.1080/01621459.1972.10481232
#'
#' Royston, P., 1993.
#' A pocket-calculator algorithm for the Shapiro–Francia test for non-normality:
#' an application to medicine.
#' Stat. Med. 12, 181–184.
#' https://doi.org/10.1002/sim.4780120209
.Shapiro_Francia <- function(x)
{
    return(0)
}



.Shapiro_Wilk_Royston <- function(x)
{
    return(0)
}




