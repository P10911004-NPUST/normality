#' Tied data
#'
#' @param x A numeric vector
#' @param ratio Numeric (default: 0.3).
#'        The ratio threshold of being considred as tied-data. The value range from 0 to 1.
#' @param remove_NA Logical (default: TRUE). Whether or not to remove NAs.
#'
#' @returns Logical
#'
#' @examples
#' is_tied(c(1, 1, 2, 2, 2, 3, 4, 5))
#' #> TRUE
#' @export
is_tied <- function(x, ratio = 0.3, remove_NA = FALSE)
{
    if (isTRUE(remove_NA))
        x <- x[stats::complete.cases(x)]
    prop <- sum(base::duplicated(x)) / length(x)
    return(prop > ratio)
}


interpolate <- function(idx_i, idx_1, idx_2, val_1, val_2)
{
    ref <- (val_1 - val_2) / (idx_1 - idx_2)
    val_i <- val_1 - ref * (idx_1 - idx_i)
    return(val_i)
}


#' Standard output format
#'
#' The standard output format for `normality` package.
#'
#' @param method Character. The name of the test.
#' @param is_normal Logical. Is the input data normally distributed?
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
        is_normal = NA,
        alpha = NA_real_,
        alternative = c("two.sided", "less", "greater"),
        summary_table = NULL,
        statistic = NA_real_,
        pvalue = NA_real_,
        confidence_interval = c("lower" = NA_real_, "upper" = NA_real_)
) {
    structure(
        .Data = list("method" = method,
                     "is_normal" = is_normal,
                     "alpha" = alpha,
                     "alternative" = alternative,
                     "summary_table" = summary_table,
                     "statistic" = statistic,
                     "pvalue" = pvalue,
                     "confidence_interval" = confidence_interval),
        class = c("normality", "list")
    )
}


normality_standard_summary_table <- function(
        method = "what test (?)",
        alpha = 0.05,
        statistic = NA_real_,
        pval = NA_real_,
        standard_value = NA_real_,
        critical_value = NA_real_,
        SE = NA_real_,
        CI_lower = NA_real_,
        CI_upper = NA_real_,
        N = NA_real_,
        AVG = NA_real_,
        MED = NA_real_,
        MIN = NA_real_,
        MAX = NA_real_,
        SD = NA_real_,
        ...
) {
    data.frame(check.names = FALSE,
               row.names = method,
               "alpha" = alpha,
               "statistic" = statistic,
               "pval" = pval,
               "standard_value" = standard_value,
               "critical_value" = critical_value,
               "SE" = SE,
               "CI_lower" = CI_lower,
               "CI_upper" = CI_upper,
               "N" = N,
               "AVG" = AVG,
               "MED" = MED,
               "MIN" = MIN,
               "MAX" = MAX,
               "SD" = SD,
               ...)
}


available_tests <- function()
{
    c(
        "Anderson-Darling" = "ad",
        "Cramer-von-Mises" = "cvm",
        "D'Agostino-Pearson" = "dap",
        "Shapiro-Wilk" = "sw",
        "Shapiro-Francia" = "sf",
        "Shapiro-Wilk-Royston" = "swr"
    )
}
