#' Jarque-Bera Normality Test
#'
#' Performs the Jarque-Bera chi-squared test, a moment-based omnibus test for
#' assessing normality.
#'
#' The test evaluates the null hypothesis that the data are drawn from a
#' normal distribution by combining standardized measures of skewness and
#' kurtosis into a single chi-squared test statistic.
#'
#' @param x Numeric vector. Must contain at least 20 observations.
#' @param alpha Numeric (default: 0.05). Significance level for hypothesis
#'        testing. Must be between 0 and 1.
#' @param alternative Character (default: `"two.sided"`). Specifies the
#'        alternative hypothesis. Available options are
#'        `c("two.sided", "less", "greater")`. This argument applies only to the
#'        skewness and kurtosis components and does not affect the Jarque-Bera
#'        omnibus test statistic itself.
#' @param silent Logical (default: `FALSE`). If `FALSE`, results are printed
#'        to the console.
#' @param summary Logical (default: TRUE). Produce a summary table.
#'
#' @returns A list
#'
#' @examples
#' out <- Jarque_Bera_test(rnorm(50))
#' print(out$summary)
#'
#' @references
#' Jarque, C.M., Bera, A.K., 1987.
#' A Test for Normality of Observations and Regression Residuals.
#' Int. Stat. Rev. 55, 163–172.
#' https://doi.org/10.2307/1403192
#' @seealso [D.Agostino_Pearson_test()]
#' @export
Jarque_Bera_test <- function(
        x,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater"),
        silent = FALSE,
        summary = TRUE
) {
    alt <- match.arg(alternative[1], c("two.sided", "less", "greater"))

    x <- x[stats::complete.cases(x)]
    n <- length(x)

    if (x[1] - x[n] == 0) stop("All values are identical.")

    skew_out <- skewness(x, alpha, alt, "b1", silent = TRUE, summary)
    kurt_out <- kurtosis(x, alpha, alt, "b2", silent = TRUE, summary)

    skew <- unname(skew_out[["statistic"]])
    kurt <- unname(kurt_out[["statistic"]]) - 3

    JB <- (n / 6) * (skew * skew + (kurt * kurt / 4))
    pval <- stats::pchisq(JB, df = 2, lower.tail = FALSE)
    JB_crit <- stats::qchisq(alpha, df = 2, lower.tail = FALSE)

    ret <- normality_standard_output(
        method = "Jarque-Bera normality test",
        is_normal = (pval > 0.05),
        alpha = alpha,
        alternative = alt,
        statistic = c("JB" = JB),
        pvalue = pval
    )

    if (isTRUE(summary))
    {
        tab <- normality_standard_summary_table(
            method = "Jarque-Bera (JB)",
            alpha = alpha,
            statistic = JB,
            pval = pval,
            signif = pval2asterisk(pval, c(alpha, 0.01, 0.001)),
            standard_value = JB,
            critical_value = JB_crit,
            N = n,
            AVG = mean(x),
            MED = stats::median(x),
            MIN = min(x),
            MAX = max(x),
            SD = stats::sd(x)
        )

        ret[["summary"]] <- rbind(skew_out[["summary"]],
                                  kurt_out[["summary"]],
                                  tab)
    }

    if (isFALSE(silent))
    {
        cat("\n------------------------------------\n")
        cat("Jarque-Bera (JB) normality test", "\n\n")
        cat("Alternative:", alt, "\n\n")
        cat("Skewness =", round(skew_out[["statistic"]], 4), "; ",
            "p-value =", round(skew_out[["pvalue"]], 5), "\n")
        cat("Kurtosis =", round(kurt_out[["statistic"]], 4), "; ",
            "p-value =", round(kurt_out[["pvalue"]], 5), "\n\n")
        cat("Statistic (JB) =", round(JB, 4), "\n")
        cat("p-value =", round(pval, 5))
        cat("\n------------------------------------\n")
    }

    invisible(ret)
}
