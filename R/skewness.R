skewness <- function(x, population = FALSE, method = "fp")
{
    if (method == "fp")
    {
        x <- x[stats::complete.cases(x)]
        xbar <- mean(x)
        n <- length(x)
        std.p <- sqrt(sum((x - xbar) ^ 2) / n)  # Population's standard deviation

        if (isTRUE(population))
            ret <- sum((x - xbar) ^ 3) / (n * (std.p ^ 3))
        else
            ret <- Fisher_Pearson_skewness(x)
    }

    return(ret)
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
    se <- sqrt((6 * n * (n - 1)) / ((n - 2) * (n + 1) * (n + 3))) # standard error

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

    summary_table <- data.frame(
        check.names = FALSE,
        row.names = "skewness (sqrt-b1)",
        "statistic" = b1,
        "Z" = Zs,
        "Zcrit" = critical_Zs,
        "SE" = se,
        "pval" = Zs_pval,
        "CI_lower" = CI_lower,
        "CI_upper" = CI_upper
    )

    normality_standard_output(
        method = "D'Agostino's b1 skewness test",
        bool = (Zs_pval > alpha),
        alpha = alpha,
        alternative = alt,
        summary_table = summary_table,
        statistic = c("sqrt-b1" = b1, "Z(sqrt-b1)" = Zs),
        pvalue = Zs_pval,
        confidence_interval = c("lower" = CI_lower, "upper" = CI_upper)
    )
}


Pearson_mode_skewness <- function(x)
{
    # Pearson's First Coefficient of Skewness
    ## This is not reliable when the mode is only a few pieces of data
    x <- x[stats::complete.cases(x)]
    `_mode_` <- sort(x)[unname(which.max(table(x)))]
    skew <- (mean(x) - `_mode_`) / stats::sd(x)
    return(skew)
}


Pearson_median_skewness <- function(x)
{
    # Pearson's Second Coefficient of Skewness
    x <- x[stats::complete.cases(x)]
    skew <- 3 * (mean(x) - stats::median(x)) / stats::sd(x)
    return(skew)
}


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



