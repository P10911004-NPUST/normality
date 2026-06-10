#' D'Agostino-Pearson K<sup>2</sup> Normality Test
#'
#' The D'Agostino–Pearson Chi-square (K<sup>2</sup>) test is a moment test for
#' assessing whether a sample comes from a normal distribution.
#' It combines information from skewness (asymmetry) and kurtosis (tail heaviness)
#' into a single omnibus test statistic.
#'
#' @param x A numeric vector.
#' @param alpha Significance threshold (default: 0.05).
#' @param alternative Character (default: "two.sided).
#'      The alternative hypothesis (H1) to test. Available options are c("two.sided", "less", "greater").
#'      Note that, this is only applied on skewness and kurtosis test.
#' @param silent Logical (default: FALSE). If `FALSE`, print out the results.
#'
#' @returns A list
#'
#' @examples
#' D.Agostino_Pearson_test(cholesterol)
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
        silent = FALSE
) {
    alt <- match.arg(alternative[1], c("two.sided", "less", "greater"))

    x <- x[stats::complete.cases(x)]
    n <- length(x)
    avg <- mean(x)

    if (n < 20)
        warning("D'Agostino-Pearson test may be inappropriate for n < 20")

    #-------------------------------- skewness --------------------------------#
    skew_out <- D.Agostino_skewness(x, alpha, alt)
    Zs <- skew_out[["summary_table"]][["standard_value"]]

    #-------------------------------- kurtosis --------------------------------#
    kurt_out <- D.Agostino_kurtosis(x, alpha, alt)
    # Zk <- kurt_out[["summary_table"]][["Z"]]
    Zk <- kurt_out[["summary_table"]][["standard_value"]]

    #-------------------------- K-square omnibus test -------------------------#
    K2 <- (Zs ^ 2) + (Zk ^ 2)
    pval <- stats::pchisq(K2, df = 2, lower.tail = FALSE)
    critical_K2 <- stats::qchisq(alpha, df = 2, lower.tail = FALSE)

    tab <- normality_standard_summary_table(
        method = "D'Agostino-Pearson (K2)",
        alpha = alpha,
        statistic = K2,
        pval = pval,
        standard_value = K2,
        critical_value = critical_K2,
        N = n,
        AVG = avg,
        MED = stats::median(x),
        MIN = min(x),
        MAX = max(x),
        SD = stats::sd(x)
    )

    tab <- rbind(skew_out[["summary_table"]],
                 kurt_out[["summary_table"]],
                 tab)

    ret <- normality_standard_output(
        method = "D'Agostino-Pearson K2 normality test",
        is_normal = (pval > 0.05),
        alpha = alpha,
        alternative = alt,
        summary_table = tab,
        statistic = c("K2" = K2),
        pvalue = pval
    )

    if (isFALSE(silent))
    {
        cat("\n--------------------------------------\n")
        cat("D'Agostino-Pearson (K2) normality test", "\n\n")
        cat("Alternative:", alt, "\n\n")
        cat("Skewness =", round(skew_out[["statistic"]], 5), "; ",
            "p-value =", round(skew_out[["pvalue"]]), "\n")
        cat("Kurtosis =", round(kurt_out[["statistic"]], 5), "; ",
            "p-value =", round(kurt_out[["pvalue"]]), "\n\n")
        cat("Statistic (K2) =", round(K2, 5), "\n")
        cat("p-value =", round(pval, 6))
        cat("\n--------------------------------------\n")
    }

    invisible(ret)
}


D.Agostino_skewness <- function(
        x,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater")
) {
    alt <- match.arg(alternative)
    x <- x[stats::complete.cases(x)]
    n <- length(x)
    avg <- mean(x)
    se <- sqrt((6 * n * (n - 1)) / ((n - 2) * (n + 1) * (n + 3))) # skewness (G1)

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

    CI_lower <- b1 - se * critical_Zs
    CI_upper <- b1 + se * critical_Zs

    tab <- normality_standard_summary_table(
        method = "skewness (sqrt-b1)",
        alpha = alpha,
        statistic = b1,
        pval = Zs_pval,
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

    normality_standard_output(
        method = "D'Agostino b1 skewness test",
        is_normal = (Zs_pval > alpha),
        alpha = alpha,
        alternative = alt,
        summary_table = tab,
        statistic = c("sqrt-b1" = b1),
        pvalue = Zs_pval,
        confidence_interval = c("lower" = CI_lower, "upper" = CI_upper)
    )
}


D.Agostino_kurtosis <- function(
        x,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater")
) {
    alt <- match.arg(alternative)
    x <- x[stats::complete.cases(x)]
    n <- length(x)
    avg <- mean(x)

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

    CI_lower <- b2 - se_b2 * critical_Zk
    CI_upper <- b2 + se_b2 * critical_Zk

    tab <- normality_standard_summary_table(
        method = "kurtosis (b2)",
        alpha = alpha,
        statistic = b2,
        pval = Zk_pval,
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

    normality_standard_output(
        method = "D'Agostino b2 kurtosis test",
        is_normal = (Zk_pval > alpha),
        alpha = alpha,
        alternative = alt,
        summary_table = tab,
        statistic = c("b2" = b2),
        pvalue = Zk_pval,
        confidence_interval = c("lower" = CI_lower, "upper" = CI_upper)
    )
}
