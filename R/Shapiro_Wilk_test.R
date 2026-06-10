#' Shapiro-Wilk Normality Test
#'
#' Performs the Shapiro-Wilk normality test which is based on the regression and
#' correlation technique.
#'
#' @param x A numeric vector.
#' @param alpha Significance threshold (default: 0.05).
#' @param method Character (default: "SWR"). Use which modification of the test?
#'        Available options are c("SWR", "SF", "SW").
#' @param silent Logical (default: FALSE). If `FALSE`, print out the results.
#'
#' @details
#' method
#'  - "SW": Shapiro-Wilk, the original test (`Shapiro and Wilk, 1965`).
#'          Only applicable when 3 <= n <= 50.
#'  - "SF": Shapiro-Francia, modified by Francia (`Shapiro and Francia, 1972`),
#'          and finally simplified and extended by Royston (`Royston, 1993`).
#'          Only applicable when 5 <= n <= 5000.
#'  - "SWR": Shapiro-Wilk-Royston, modified by Royston (`Royston, 1995`).
#'           Only applicable when 3 <= n <= 5000.
#'
#' @returns A list.
#'
#' @examples
#' Shapiro_Wilk_test(rnorm(20), method = "SW")
#' @references
#' Shapiro, S.S., Wilk, M.B., 1965.
#' An Analysis of Variance Test for Normality (Complete Samples).
#' Biometrika 52, 591–611.
#' https://doi.org/10.2307/2333709
#'
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
#'
#' Royston, P., 1992.
#' Approximating the Shapiro–Wilk W-test for non-normality.
#' Stat. Comput. 2, 117–119.
#' https://doi.org/10.1007/BF01891203
#'
#' Royston, P., 1995.
#' Remark AS R94: A Remark on Algorithm AS 181: The W-test for Normality.
#' Appl. Stat. 44, 547–551.
#' https://doi.org/10.2307/2986146
#' @export
Shapiro_Wilk_test <- function(
        x,
        alpha = 0.05,
        method = c("SWR", "SF", "SW"),
        silent = FALSE
) {
    m <- toupper(method)
    m <- match.arg(m, c("SWR", "SF", "SW"))
    f <- switch(
        match(m, c("SWR", "SF", "SW")),
        .Shapiro_Wilk_Royston,
        .Shapiro_Francia,
        .Shapiro_Wilk_original
    )

    f(x, alpha, silent)
}


#==============================================================================#
#                              Internal function                               #
#==============================================================================#

.Shapiro_Wilk_original <- function(x, alpha = 0.05, silent = FALSE)
{
    x <- sort(x[stats::complete.cases(x)])
    n <- length(x)
    avg <- mean(x)
    SS <- sum((x - avg) ^ 2)

    if (n < 3 || n > 50)
        stop("Sample size should be 3 <= n <= 50.")

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
    imin <- sum(W >= unlist(W_crit))

    pval <- interpolate(idx_i = W,
                        idx_1 = W_crit[[imin]],
                        idx_2 = W_crit[[imin + 1]],
                        val_1 = p_ref[imin],
                        val_2 = p_ref[imin + 1])

    tab <- normality_standard_summary_table(
        method = "Shapiro-Wilk (W)",
        statistic = W,
        standard_value = W,
        critical_value = unname(W_crit[[match(alpha, p_ref)]]),
        pval = pval,
        N = n,
        AVG = avg,
        MED = stats::median(x),
        MIN = min(x),
        MAX = max(x),
        SD = stats::sd(x)
    )

    ret <- normality_standard_output(
        method = "Shapiro-Wilk (W) normality test",
        is_normal = (pval > alpha),
        alpha = alpha,
        alternative = "greater",
        summary_table = tab,
        statistic = c("W" = W),
        pvalue = pval
    )

    if (isFALSE(silent))
    {
        cat("\n-------------------------------\n")
        cat("Shapiro-Wilk (W) normality test", "\n\n")
        cat("Statistic (W) =", round(W, 5), "\n")
        cat("p-value =", round(pval, 6))
        cat("\n-------------------------------\n")
    }

    invisible(ret)
}


.Shapiro_Francia <- function(x, alpha = 0.05, silent = FALSE)
{
    x <- sort(x[stats::complete.cases(x)])
    n <- length(x)
    avg = mean(x)

    if (n < 5 || n > 5000)
        stop("Sample size should be 5 <= n <= 5000.")

    m <- stats::qnorm(((1:n) - 0.375) / (n + 0.25))
    W <- stats::cor(x, m) ^ 2

    u <- log(n)
    v <- log(u)
    mu_hat <- 1.0521 * (v - u) - 1.2725
    sigma_hat <- 1.0308 - 0.26758 * (v + 2 / u)
    Z <- (log(1 - W) - mu_hat) / sigma_hat # refer to N(0, 1) upper tail
    pval <- stats::pnorm(Z, lower.tail = FALSE)
    Zcrit <- stats::qnorm(alpha, lower.tail = FALSE)

    tab <- normality_standard_summary_table(
        method = "Shapiro-Francia (W')",
        alpha = alpha,
        statistic = W,
        pval = pval,
        standard_value = Z,
        critical_value = Zcrit,
        N = n,
        AVG = avg,
        MED = stats::median(x),
        MIN = min(x),
        MAX = max(x),
        SD = stats::sd(x)
    )

    ret <- normality_standard_output(
        method = "Shapiro-Francia (W') normality test",
        is_normal = (pval > 0.05),
        alpha = alpha,
        alternative = "greater",
        summary_table = tab,
        statistic = c("W'" = W),
        pvalue = pval
    )

    if (isFALSE(silent))
    {
        cat("\n-----------------------------------\n")
        cat("Shapiro-Francia (W') normality test", "\n\n")
        cat("Statistic (W') =", round(W, 5), "\n")
        cat("p-value =", round(pval, 6))
        cat("\n-----------------------------------\n")
    }

    invisible(ret)
}



.Shapiro_Wilk_Royston <- function(x, alpha = 0.05, silent = FALSE)
{
    return(0)
}


