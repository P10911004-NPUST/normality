#' Standard output format
#'
#' The standard output format for `normality` package.
#'
#' @param method Character. The name of the test.
#' @param bool Logical. Is the input data normally distributed?
#' @param alpha Numeric (default: 0.05). Significance threshold.
#' @param alternative Character. The alternative hypothesis (H1) to test.
#'      Available options are c("two.sided", "less", "greater").
#' @param summary_table Statistic summary, if any.
#' @param statistic Numeric. The value used to calculate p-value.
#' @param pvalue Numeric. The p-value of the test.
#' @param confidence_interval Numeric vector of length 2. The lower and upper bound of CI.
#'
#' @returns A list contains 8 vectors.
normality_standard_output <- function(
        method = "what test?",
        bool = NA,
        alpha = NA_real_,
        alternative = c("two.sided", "less", "greater"),
        summary_table = NULL,
        statistic = NA_real_,
        pvalue = NA_real_,
        confidence_interval = c("lower" = NA_real_, "upper" = NA_real_)
) {
    structure(
        .Data = list(
            "method" = method,
            "bool" = bool,
            "alpha" = alpha,
            "alternative" = alternative,
            "summary_table" = summary_table,
            "statistic" = statistic,
            "pvalue" = pvalue,
            "confidence_interval" = confidence_interval
        ),
        class = c("normality", "list")
    )
}


available_tests <- function()
{
    c(
        "Anderson-Darling" = "ad",
        "Cramer-von-Mises" = "cvm",
        "D'Agostino-Pearson" = "dap"
    )
}
