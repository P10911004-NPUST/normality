#' Cramer-von Mises Normality Test
#'
#' An empirical distribution function (EDF)-based goodness-of-fit test that measures the
#' overall discrepancy between the empirical and theoretical cumulative distribution functions
#' by assigning relatively uniform weight across the entire distribution.
#'
#' @param x A numeric vector, at least length of 8.
#' @param alpha Numeric (default: 0.05). Significance threshold, range from 0 to 1.
#' @param silent Logical (default: FALSE). If `FALSE`, print out the results.
#' @param summary Logical (default: TRUE). Produce a summary table.
#' @param misc Logical (default: FALSE). Output other unimportant parameters.
#'
#' @returns A list.
#'
#' @examples
#' out <- Cramer_von_Mises_test(rnorm(10))
#' print(out$summary)
#'
#' @references
#' Thode, H. C., Jr., 2002. Goodness of fit tests.
#' Testing for normality. Marcel Dekker, New York.
#' (Section 5.1.3, pg. 103)
#'
#' Stephens, M.A., 2017. Tests Based on EDF Statistics.
#' In: D'Agostino, R.B., Stephens, M.A. (Eds.),
#' Goodness-of-Fit Techniques, 1st ed. Routledge, New York,
#' (Table 4.9, pg. 127).
#' https://doi.org/10.1201/9780203753064
#'
#' @export
Cramer_von_Mises_test <- function(
        x,
        alpha = 0.05,
        silent = FALSE,
        summary = TRUE,
        misc = FALSE
) {
    x <- sort(x[stats::complete.cases(x)], decreasing = FALSE)
    n <- length(x)
    i <- seq_along(x)
    avg <- mean(x)
    std <- stats::sd(x)

    if (x[1] - x[n] == 0) stop("All values are identical.")
    if (n < 8) warning("Cramer-von-Mises test is inappropriate for n < 8")

    Z <- (x - avg) / std
    Pi_lower <- stats::pnorm(Z)

    W2 <- (1 / (12 * n)) + sum((Pi_lower - (2 * i - 1) / (n + n)) ^ 2)
    mW2 <- (1 + 0.5 / n) * W2

    if (mW2 < 0.0275)
        pval <- 1 - exp(-13.953 + 775.5 * mW2 - 12542.61 * mW2 * mW2)
    else if (mW2 < 0.051)
        pval <- 1 - exp(-5.903 + 179.546 * mW2 - 1515.29 * mW2 * mW2)
    else if (mW2 < 0.092)
        pval <- exp(0.886 - 31.62 * mW2 + 10.897 * mW2 * mW2)
    else if (mW2 < 2.635)
        pval <- exp(1.111 - 34.242 * mW2 + 12.832 * mW2 * mW2)
    else {
        ## When mW2 > 2.635, the pval will exceed 1
        # for (mW2 in seq(0.095, 2.655, 0.01))
        # {
        #     ret <- exp(1.111 - 34.242 * mW2 + 12.832 * mW2 * mW2)
        #     print(sprintf("%s: %e", mW2, ret))
        # }
        pval <- 1
    }

    ret <- normality_standard_output(
        method = "Cramer-von-Mises normality test",
        is_normal = (pval > alpha),
        alpha = alpha,
        alternative = "greater",
        statistic = c("W2" = W2),
        pvalue = pval
    )

    if (isTRUE(summary))
    {
        ret[["summary"]] <- normality_standard_summary_table(
            method = "Cramer-von-Mises (W2)",
            statistic = W2,
            standard_value = mW2,
            critical_value = NA_real_,
            pval = pval,
            signif = pval2asterisk(pval, c(alpha, 0.01, 0.001)),
            N = n,
            AVG = avg,
            MED = stats::median(x),
            MIN = min(x),
            MAX = max(x),
            SD = stats::sd(x)
        )
    }

    if (isTRUE(misc))
        ret[["misc"]] <- list("p(i)" = Pi_lower, "modified-W2" = mW2)

    if (isFALSE(silent))
    {
        cat("\n------------------------------------\n")
        cat("Cramer-von-Mises (W2) normality test", "\n\n")
        cat("Statistic (W2) =", round(W2, 4), "\n")
        cat("p-value =", round(pval, 5))
        cat("\n------------------------------------\n")
    }

    invisible(ret)
}

