#' Anderson-Darling Normality Test
#'
#' Performs the Anderson–Darling (A<sup>2</sup>) normality test, an EDF-based
#' goodness-of-fit test that gives greater weight to deviations in the tails
#' of the distribution.
#'
#' @param x A numeric vector, at least length of 8.
#' @param alpha Numeric (default: 0.05). Significance threshold, range from 0 to 1.
#' @param silent Logical (default: FALSE). If `FALSE`, print out the results.
#'
#' @returns A list.
#'
#' @examples
#' out <- Anderson_Darling_test(rnorm(10))
#' print(out$summary)
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
        silent = FALSE
) {
    x <- sort(x[stats::complete.cases(x)], decreasing = FALSE)
    n <- length(x)
    i <- seq_along(x)
    avg <- mean(x)
    std <- stats::sd(x)
    Z <- (x - avg) / std # Y(i) in formula 9.9

    if (x[1] - x[n] == 0) stop("All values are identical.")
    if (n < 8) warning("Anderson-Darling test is inappropriate for n < 8")

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
    else if (mA2 < 20)
        # If the modified A2 (mA2) is too large, the output pval may be smaller
        # than the smallest positive floating-point that the machine usually can
        # handle precisely. See `.Machine[["double.xmin"]]`.
        pval <- exp(1.2937 - (5.709 * mA2) + (0.0186 * mA2 * mA2))
    else {
        # # When mA2 >= 20, the pval <= 1.604182e-46, directly assign as zero
        # for (i in 1:20) {
        #     ret <- exp(1.2937 - (5.709 * i) + (0.0186 * i * i))
        #     # if (ret < .Machine$double.eps) break
        #     print(sprintf("%s: %e", i, ret))
        # }
        pval <- 0
    }

    A2crit <- .calc_A2_crit(alpha, n)

    tab <- normality_standard_summary_table(
        method = "Anderson-Darling (A2)",
        statistic = A2,
        standard_value = mA2,
        critical_value = A2crit,
        pval = pval,
        signif = pval2asterisk(pval, c(alpha, 0.01, 0.001)),
        N = n,
        AVG = avg,
        MED = stats::median(x),
        MIN = min(x),
        MAX = max(x),
        SD = stats::sd(x)
    )

    ret <- normality_standard_output(
        method = "Anderson-Darling normality test",
        is_normal = (pval > alpha),
        alpha = alpha,
        alternative = "greater",
        summary = tab,
        statistic = c("A2" = A2),
        pvalue = pval
    )

    if (isFALSE(silent))
    {
        cat("\n------------------------------------\n")
        cat("Anderson-Darling (A2) normality test", "\n\n")
        cat("Statistic (A2) =", round(A2, 4), "\n")
        cat("p-value =", round(pval, 5))
        cat("\n------------------------------------\n")
    }

    invisible(ret)
}


.calc_A2_crit <- function(alpha, n)
{
    alpha <- round(alpha, 4)
    q_ref <- round(c(seq(0.05, 0.95, 0.05), .975, .99, .995), 4)
    p_ref <- round(1 - q_ref, 4)

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

    if (any(alpha == p_ref))
    {
        ind <- which(alpha == p_ref)
        b0 <- b0_[ind]
        b1 <- b1_[ind]
        asymp <- asymp_[ind]
    } else {
        ind <- sum(alpha < p_ref)
        b0 <- interpolate(idx_i = alpha,
                          idx_1 = p_ref[ind],
                          idx_2 = p_ref[ind + 1],
                          val_1 = b0_[ind],
                          val_2 = b0_[ind + 1])

        b1 <- interpolate(idx_i = alpha,
                          idx_1 = p_ref[ind],
                          idx_2 = p_ref[ind + 1],
                          val_1 = b1_[ind],
                          val_2 = b1_[ind + 1])

        asymp <- interpolate(idx_i = alpha,
                             idx_1 = p_ref[ind],
                             idx_2 = p_ref[ind + 1],
                             val_1 = asymp_[ind],
                             val_2 = asymp_[ind + 1])
    }

    A2crit <- asymp * (1 + (b0 / n) + (b1 / (n * n)))
    return(A2crit)
}



