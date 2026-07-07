#' Lilliefors Normality Test
#'
#' Performs the Lilliefors normality test, which is an empirical distribution
#' function (EDF)-based goodness-of-fit test derived from the Kolmogorov–Smirnov
#' test, using the approximation proposed by Molin and Abdi (1998).
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
#' out <- Lilliefors_test(rnorm(10))
#' print(out$summary)
#'
#' @references
#' Molin, P., Abdi, H., 1998.
#' New tables and numerical approximation for the
#' Kolmogorov-Smirnov/Lillierfors/Van Soest test of normality.
#' Technical report, University of Bourgogne.
#' @export
Lilliefors_test <- function(
        x,
        alpha = 0.05,
        silent = FALSE,
        summary = TRUE,
        misc = FALSE
) {
    beta <- 1 - alpha
    x <- sort(x[stats::complete.cases(x)])
    n <- length(x)
    i <- seq_along(x)
    if (n < 5) stop("Sample size must be greater than 4")
    avg <- mean(x)
    std <- stats::sd(x)
    Z <- (x - avg) / std

    Pi <- stats::pnorm(Z)
    Dplus <- max(i / n - Pi)
    Dminus <- max(Pi - (i - 1) / n)
    D <- max(Dplus, Dminus)

    b0 <- 0.37872256037043
    b1 <- 1.30748185078790
    b2 <- 0.08861783849346

    A <- ((-b1 - n) + sqrt(((b1 + n) ^ 2) - 4 * b2 * (b0 - 1 / (D * D)))) / (2 * b2)

    pval <- (- 0.37782822932809
             + 1.67819837908004 * A
             - 3.02959249450445 * A ^ 2
             + 2.80015798142101 * A ^ 3
             - 1.39874347510845 * A ^ 4
             + 0.40466213484419 * A ^ 5
             - 0.06353440854207 * A ^ 6
             + 0.00287462087623 * A ^ 7
             + 0.00069650013110 * A ^ 8
             - 0.00011872227037 * A ^ 9
             + 0.00000575586834 * A ^ 10)

    A_alpha <- (+  6.32207539843126
                - 17.13988700061480 * beta
                + 38.42812675101057 * beta ^ 2
                - 45.93241384693391 * beta ^ 3
                +  7.88697700041829 * beta ^ 4
                + 29.79317711037858 * beta ^ 5
                - 18.48090137098585 * beta ^ 6)

    B_alpha <- (+  12.940399038404
                -  53.458334259532 * beta
                + 186.923866119699 * beta ^ 2
                - 410.582178349305 * beta ^ 3
                + 517.377862566267 * beta ^ 4
                - 343.581476222384 * beta ^ 5
                +  92.123451358715 * beta ^ 6)

    a_alpha <- 1 / sqrt(A_alpha)
    b_alpha <- B_alpha / A_alpha

    D_crit <- a_alpha / sqrt(n + b_alpha)

    ret <- normality_standard_output(
        method = "Lilliefors normality test",
        is_normal = (pval > alpha),
        alpha = alpha,
        alternative = "two.sided",
        statistic = c("D" = D),
        pvalue = pval
    )

    if (isTRUE(summary))
    {
        ret[["summary"]] <- normality_standard_summary_table(
            method = "Lilliefors (D)",
            statistic = D,
            critical_value = D_crit,
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
        ret[["misc"]] <- list("A" = A, "A(alpha)" = A_alpha, "B(alpha)" = B_alpha)

    if (isFALSE(silent))
    {
        cat("\n--------------------------\n")
        cat("Lilliefors normality test", "\n\n")
        cat("Statistic (D) =", round(D, 4), "\n")
        cat("p-value =", round(pval, 5))
        cat("\n--------------------------\n")
    }

    invisible(ret)
}


