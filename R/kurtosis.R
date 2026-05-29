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
    se_b2 <- sqrt(var_b2 / n)

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

    CI_lower <- b2 - se_b2 * critical_Zk
    CI_upper <- b2 + se_b2 * critical_Zk

    summary_table <- data.frame(
        check.names = FALSE,
        row.names = "kurtosis (b2)",
        "statistic" = b2,
        "Z" = Zk,
        "Zcrit" = critical_Zk,
        "SE" = se_b2,
        "pval" = Zk_pval,
        "CI_lower" = CI_lower,
        "CI_upper" = CI_upper
    )

    normality_standard_output(
        method = "D'Agostino's b2 kurtosis test",
        bool = (Zk_pval > alpha),
        alpha = alpha,
        alternative = alt,
        summary_table = summary_table,
        statistic = c("b2" = b2, "Z(b2)" = Zk),
        pvalue = Zk_pval,
        confidence_interval = c("lower" = CI_lower, "upper" = CI_upper)
    )
}
