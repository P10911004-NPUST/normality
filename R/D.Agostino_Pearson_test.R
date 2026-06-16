#' D'Agostino–Pearson K<sup>2</sup> Normality Test
#'
#' The D'Agostino–Pearson chi-squared (K<sup>2</sup>) test is a moment-based
#' omnibus test for normality.
#'
#' It evaluates the null hypothesis that the data come from a normal distribution
#' by combining standardized measures of skewness and kurtosis into a single
#' chi-squared test statistic.
#'
#' @param x Numeric vector. Must have length at least 20.
#' @param alpha Numeric (default: 0.05). Significance level for hypothesis testing.
#'        Must be between 0 and 1.
#' @param alternative Character (default: "two.sided").
#'        Specifies the alternative hypothesis. Available options are
#'        c("two.sided", "less", "greater"). Note that this option is only applied
#'        to the skewness and kurtosis components of the test.
#' @param silent Logical (default: FALSE). If `FALSE`, results are printed
#'        to the console.
#' @param summary Logical (default: TRUE). Produce a summary table.
#' @param misc Logical (default: FALSE). Output other unimportant parameters.
#'
#' @returns A list
#'
#' @examples
#' out <- D.Agostino_Pearson_test(rnorm(50))
#' print(out$summary)
#'
#' @references
#' D’Agostino, R.B., Belanger, A., D’Agostino, R.B., 1990.
#' A Suggestion for Using Powerful and Informative Tests of Normality.
#' Am. Stat. 44, 316–321.
#' https://doi.org/10.1080/00031305.1990.10475751
#' @export
D.Agostino_Pearson_test <- function(
        x,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater"),
        silent = FALSE,
        summary = TRUE,
        misc = FALSE
) {
    alt <- match.arg(alternative[1], c("two.sided", "less", "greater"))

    x <- x[stats::complete.cases(x)]
    n <- length(x)
    avg <- mean(x)

    #-------------------------------- skewness --------------------------------#
    skew_out <- D.Agostino_skewness(x, alpha, alt, summary)
    Zs <- skew_out[["misc"]][["Z(b1)"]]

    #-------------------------------- kurtosis --------------------------------#
    kurt_out <- D.Agostino_kurtosis(x, alpha, alt, summary)
    Zk <- kurt_out[["misc"]][["Z(b2)"]]

    #-------------------------- K-square omnibus test -------------------------#
    K2 <- (Zs ^ 2) + (Zk ^ 2)
    pval <- stats::pchisq(K2, df = 2, lower.tail = FALSE)
    critical_K2 <- stats::qchisq(alpha, df = 2, lower.tail = FALSE)

    ret <- normality_standard_output(
        method = "D'Agostino-Pearson K2 normality test",
        is_normal = (pval > 0.05),
        alpha = alpha,
        alternative = alt,
        statistic = c("K2" = K2),
        pvalue = pval
    )

    if (isTRUE(summary))
    {
        tab <- normality_standard_summary_table(
            method = "D'Agostino-Pearson (K2)",
            alpha = alpha,
            statistic = K2,
            pval = pval,
            signif = pval2asterisk(pval, c(alpha, 0.01, 0.001)),
            standard_value = K2,
            critical_value = critical_K2,
            N = n,
            AVG = avg,
            MED = stats::median(x),
            MIN = min(x),
            MAX = max(x),
            SD = stats::sd(x)
        )

        tab <- rbind(skew_out[["summary"]],
                     kurt_out[["summary"]],
                     tab)

        ret[["summary"]] <- tab
    }

    if (isTRUE(misc))
    {
        ret[["misc"]] <- list(
            "skewness (sqrt-b1)" = skew_out[["misc"]],
            "kurtosis (b2)" = kurt_out[["misc"]]
        )
    }


    if (isFALSE(silent))
    {
        cat("\n--------------------------------------\n")
        cat("D'Agostino-Pearson (K2) normality test", "\n\n")
        cat("Alternative:", alt, "\n\n")
        cat("Skewness =", round(skew_out[["statistic"]], 4), "; ",
            "p-value =", round(skew_out[["pvalue"]], 5), "\n")
        cat("Kurtosis =", round(kurt_out[["statistic"]], 4), "; ",
            "p-value =", round(kurt_out[["pvalue"]], 5), "\n\n")
        cat("Statistic (K2) =", round(K2, 4), "\n")
        cat("p-value =", round(pval, 5))
        cat("\n--------------------------------------\n")
    }

    invisible(ret)
}


D.Agostino_skewness <- function(
        x,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater"),
        summary = TRUE
) {
    alt <- match.arg(alternative)
    x <- x[stats::complete.cases(x)]
    n <- length(x)
    avg <- mean(x)
    se <- sqrt((6 * n * (n - 1)) / ((n - 2) * (n + 1) * (n + 3))) # SE(G1)

    if (n < 9)
        warning("D'Agostino-Pearson skewness test may be inappropriate for n < 9")

    #----------------------------- Sample moments -----------------------------#
    m2 <- sum((x - avg) ^ 2) / n # formula 6
    m3 <- sum((x - avg) ^ 3) / n # formula 6

    b1 <- m3 / sqrt(m2 ^ 3) # formula 4, skewness, the symbol is square-rooted b1

    #---------------------------- Test of skewness ----------------------------#
    Y <- b1 * sqrt( (n + 1) * (n + 3) / (6 * (n - 2)) ) # formula 8

    beta2 <- 3 * (n ^ 2 + 27 * n - 70) * (n + 1) * (n + 3) # formula 9
    beta2 <- beta2 / ((n - 2) * (n + 5) * (n + 7) * (n + 9)) # formula 9

    W2 <- sqrt(2 * (beta2 - 1)) - 1 # formula 10
    delta <- 1 / sqrt(log(sqrt(W2))) # formula 11
    alpha_2 <- sqrt(2 / (W2 - 1)) # formula 12

    # Z-value of the skewness
    Zs <- delta * log( (Y / alpha_2) + sqrt((Y / alpha_2) ^ 2 + 1) ) # formula 13

    pval <- stats::pnorm(Zs, lower.tail = FALSE) * 2

    if (alt == "two.sided")
    {
        Zs_pval <- if (pval > 1) 2 - pval else pval
        critical_Zs <- stats::qnorm(1 - alpha / 2)
    }

    if (alt == "less") # skewness < 0, the peak towards right
    {
        Zs_pval <- pval / 2
        critical_Zs <- stats::qnorm(1 - alpha)
    }

    if (alt == "greater") # skewness > 0, the peak towards left
    {
        Zs_pval <- 1 - pval / 2
        critical_Zs <- stats::qnorm(alpha)
    }

    ret <- normality_standard_output(
        method = "D'Agostino b1 skewness test",
        is_normal = (Zs_pval > alpha),
        alpha = alpha,
        alternative = alt,
        statistic = c("sqrt-b1" = b1),
        pvalue = Zs_pval,
        misc = c("Y" = Y,
                 "beta2(b1)" = beta2,
                 "W2" = W2,
                 "delta" = delta,
                 "alpha_" = alpha_2,
                 "Z(b1)" = Zs,
                 "Zs_crit" = critical_Zs)
    )

    if (isTRUE(summary))
    {
        CI_lower <- b1 - se * critical_Zs
        CI_upper <- b1 + se * critical_Zs

        ret[["summary"]] <- normality_standard_summary_table(
            method = "skewness (sqrt-b1)",
            alpha = alpha,
            statistic = b1,
            pval = Zs_pval,
            signif = pval2asterisk(pval, c(alpha, 0.01, 0.001)),
            standard_value = Zs,
            critical_value = critical_Zs,
            SE = se,
            CI_lower = CI_lower,
            CI_upper = CI_upper,
            N = n,
            AVG = avg,
            MED = stats::median(x),
            MIN = min(x),
            MAX = max(x),
            SD = stats::sd(x)
        )
    }

    return(ret)
}


D.Agostino_kurtosis <- function(
        x,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater"),
        summary = TRUE
) {
    alt <- match.arg(alternative[1], c("two.sided", "less", "greater"))

    x <- x[stats::complete.cases(x)]
    n <- length(x)
    avg <- mean(x)

    if (x[1] - x[n] == 0)
        stop("All values are identical.")
    if (n < 20)
        warning("D'Agostino-Pearson test is inappropriate for n < 20")

    #----------------------------- Sample moments -----------------------------#
    m2 <- sum((x - avg) ^ 2) / n
    m4 <- sum((x - avg) ^ 4) / n

    b2 <- m4 / (m2 ^ 2) # formula 5, kurtosis

    #---------------------------- Test of kurtosis ----------------------------#
    mean_b2 <- 3 * (n - 1) / (n + 1)
    var_b2 <- 24 * n * (n - 2) * (n - 3) / ((n + 1) * (n + 1) * (n + 3) * (n + 5))

    standardized_b2 <- (b2 - mean_b2) / sqrt(var_b2)

    beta1 <- 6 * ((n ^ 2) - (5 * n) + 2) / ((n + 7) * (n + 9))
    beta1 <- beta1 * sqrt(6 * (n + 3) * (n + 5) / (n * (n - 2) * (n - 3)))

    # Be careful, the above `beta1` is square-rooted beta1
    # The last part of A, the `beta1` in the denominator is not square-rooted.
    A <- 6 + (8 / beta1) * ((2 / beta1) + sqrt(1 + (4 / (beta1 ^ 2))))

    Zk_1 <- 1 - (2 / (9 * A))
    Zk_2 <- (1 - (2 / A)) / (1 + standardized_b2 * sqrt(2 / (A - 4)))
    Zk_3 <- sqrt(2 / (9 * A))
    Zk <- (Zk_1 - (Zk_2 ^ (1 / 3))) / Zk_3 # kurtosis Z-value

    pval <- stats::pnorm(Zk, lower.tail = FALSE) * 2

    if (alt == "two.sided")
    {
        Zk_pval <- if (pval > 1) 2 - pval else pval
        critical_Zk <- stats::qnorm(1 - alpha / 2)
    }

    if (alt == "less") # kurtosis < 3, the peak become rounder
    {
        Zk_pval <- pval / 2
        critical_Zk <- stats::qnorm(1 - alpha)
    }

    if (alt == "greater") # kurtosis > 3, the peak become sharper
    {
        Zk_pval <- 1 - pval / 2
        critical_Zk <- stats::qnorm(alpha)
    }

    # D.Agostino use g2 as the kurtosis measure, but generally
    # the unbiased version, i.e. G2, is applied to calculate the SE.
    # Therefore, the SE(b2) is not calculated from var_b2, instead
    # it is equal to kurtosis(x, method = "G2")
    se_b2 <- 2 * (n - 1) * sqrt(6 * n / ((n - 2) * (n - 3) * (n + 3) * (n + 5)))

    ret <- normality_standard_output(
        method = "D'Agostino b2 kurtosis test",
        is_normal = (Zk_pval > alpha),
        alpha = alpha,
        alternative = alt,
        statistic = c("b2" = b2),
        pvalue = Zk_pval,
        misc = c("standardized-b2" = standardized_b2,
                 "beta1(b2)" = beta1,
                 "A" = A,
                 "Z(b2)" = Zk,
                 "Zk_crit" = critical_Zk)
    )

    if (isTRUE(summary))
    {
        CI_lower <- b2 - se_b2 * critical_Zk
        CI_upper <- b2 + se_b2 * critical_Zk

        ret[["summary"]] <- normality_standard_summary_table(
            method = "kurtosis (b2)",
            alpha = alpha,
            statistic = b2,
            pval = Zk_pval,
            signif = pval2asterisk(pval, c(alpha, 0.01, 0.001)),
            standard_value = Zk,
            critical_value = critical_Zk,
            SE = se_b2,
            CI_lower = CI_lower,
            CI_upper = CI_upper,
            N = n,
            AVG = avg,
            MED = stats::median(x),
            MIN = min(x),
            MAX = max(x),
            SD = stats::sd(x)
        )
    }

    return(ret)
}
