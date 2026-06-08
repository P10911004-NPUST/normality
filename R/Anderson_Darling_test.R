#' Anderson-Darling Normality Test
#'
#' @param x A numeric vector.
#' @param alpha Numeric (default: 0.05). Significance threshold, range from 0 to 1.
#' @param verbose Logical (default: FALSE). Show messages.
#' @param min_n Integer. The minimum observations required (default: 8).
#'
#' @returns A list:
#' - is_normal: Is the input data normally distributed?
#' - method: The name of the test.
#' - alpha: Significance threshold (default: 0.05).
#' - alternative: The alternative hypothesis (H1) to test.
#' - summary_table: Statistic summary, if any. Mostly output as a data frame.
#' - statistic: The value used to calculate p-value.
#' - pvalue: The <i>p</i> value.
#' - confidence_interval: The lower and upper bound of confidence interval (CI).
#'
#' @examples
#' Anderson_Darling_test(leghorn_chick)
#'
#' @references
#' D’Agostino, R.B., 2017. Tests for the Normal Distribution.
#' In: D’Agostino, R.B., Stephens, M.A. (Eds.),
#' Goodness-of-Fit Techniques, 1st ed. Routledge, New York,
#' pp. 372–373.
#' https://doi.org/10.1201/9780203753064
#'
#' Stephens, M.A., 2017. Tests Based on EDF Statistics.
#' In: D’Agostino, R.B., Stephens, M.A. (Eds.),
#' Goodness-of-Fit Techniques, 1st ed. Routledge, New York,
#' pp. 126–128.
#' https://doi.org/10.1201/9780203753064
#'
#' Anderson, T.W., Darling, D.A., 1954.
#' A Test of Goodness of Fit.
#' J. Am. Stat. Assoc. 49, 765–769.
#' https://doi.org/10.1080/01621459.1954.10501232

#' @export
Anderson_Darling_test <- function(
        x,
        alpha = 0.05,
        min_n = 8,
        verbose = FALSE
) {
    x <- sort(x[stats::complete.cases(x)], decreasing = FALSE)
    n <- length(x)
    i <- seq_along(x)
    avg <- mean(x)
    std <- stats::sd(x)
    Z <- (x - avg) / std # Y(i) in formula 9.9

    if (n < min_n)
        warning(sprintf("Anderson-Darling test is inappropriate for n < %s", min_n))

    Pi_lower <- stats::pnorm(Z)
    Pi_upper <- rev(stats::pnorm(Z, lower.tail = FALSE))

    A2 <- -n - mean((2 * i - 1) * (log(Pi_lower) + log(Pi_upper)))
    mA2 <- A2 * ( 1 + (0.75 / n) + (2.25 / (n * n)) )

    if (mA2 < 0.2)
        pval <- 1 - exp(-13.436 + (101.14 * mA2) - (223.73 * mA2 * mA2))
    else if (mA2 < 0.34)
        pval <- 1 - exp(-8.318 + (42.796 * mA2) - (59.938 * mA2 * mA2))
    else if (mA2 < 0.6)
        pval <- exp(0.9177 - (4.279 * mA2) - (1.38 * mA2 * mA2))
    else if (mA2 < 8)
        pval <- exp(1.2937 - (5.709 * mA2) + (0.0186 * mA2 * mA2))
    else {
        # If the modified A2 (mA2) is too large, the output pval may be smaller than the
        # smallest positive floating-point that the machine usually can handle precisely.
        # for (i in 1:20) {
        #     ret <- exp(1.2937 - (5.709 * i) + (0.0186 * i * i))
        #     print(sprintf("%s: %e", i, ret))
        #     if (ret < .Machine$double.eps) break
        # }
        if (isTRUE(verbose)) message("The p-value is too small.")
        pval <- 0
    }

    A2crit <- .calc_A2_crit(pval, n, verbose)

    # tab <- data.frame(
    #     check.names = FALSE,
    #     row.names = sprintf("Anderson-Darling (A2)"),
    #     "statistic" = A2,
    #     "modified-A2" = mA2,
    #     "A2crit" = A2crit,
    #     "SE" = NA_real_,
    #     "pval" = pval,
    #     "CI_lower" = NA_real_,
    #     "CI_upper" = NA_real_
    # )

    tab <- normality_standard_summary_table(
        row_names = "Anderson-Darling (A2)",
        statistic = A2,
        critical_value = A2crit,
        pval = pval,
        "modified-A2" = mA2
    )

    normality_standard_output(
        method = "Anderson-Darling normality test",
        is_normal = (pval > alpha),
        alpha = alpha,
        alternative = "greater",
        summary_table = tab,
        statistic = c("A2" = A2),
        pvalue = pval
    )
}


.calc_A2_crit <- function(pval, n, verbose = FALSE)
{
    if (pval > 0.95) {
        if (isTRUE(verbose))
            message("p-value is too-large, the critical value is not precise.")
        pval <- 0.95
    }

    if (pval < 0.005) {
        if (isTRUE(verbose))
            message("p-value is too small, the critical value is not precise.")
        pval <- 0.005
    }

    q_ <- round(c(seq(0.05, 0.95, 0.05), .975, .99, .995), 4)

    b0_ <- c(-0.512, -0.552, -0.608, -0.643, -0.707,
             -0.735, -0.772, -0.770, -0.778, -0.779,
             -0.803, -0.818, -0.818, -0.801, -0.800,
             -0.756, -0.749, -0.750, -0.795, -0.881,
             -1.013, -1.063)

    b1_ <- c(2.10,  1.25,  1.07,  0.93,  1.03,
             1.02,  1.04,  0.90,  0.80,  0.67,
             0.70,  0.58,  0.42,  0.12, -0.09,
             -0.39, -0.59, -0.80, -0.89, -0.94,
             -0.93, -1.34)

    asymp_ <- c(0.1674, 0.1938, 0.2147, 0.2333, 0.2509,
                0.2681, 0.2853, 0.3030, 0.3213, 0.3405,
                0.3612, 0.3836, 0.4085, 0.4367, 0.4695,
                0.5091, 0.5597, 0.6305, 0.7514, 0.8728,
                1.0348, 1.1578)

    qval <- round(1 - pval, 4)
    ind <- which(qval == q_)
    if (length(ind) == 0)
    {
        ind <- sum(qval > q_)
        b0 <- mean(c(b0_[ind], b0_[ind + 1]))
        b1 <- mean(c(b0_[ind], b0_[ind + 1]))
        # asymp <- mean(c(asymp_[ind], asymp_[ind + 1]))

        # interpolate() <<< from utils.R
        asymp <- interpolate(idx_i = qval,
                             idx_1 = q_[ind],
                             idx_2 = q_[ind + 1],
                             val_1 = asymp_[ind],
                             val_2 = asymp_[ind + 1])
    } else {
        b0 <- b0_[ind]
        b1 <- b1_[ind]
        asymp <- asymp_[ind]
    }

    A2crit <- asymp * (1 + (b0 / n) + (b1 / (n * n)))
    return(A2crit)
}



