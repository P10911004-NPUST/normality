#' Normality test
#'
#' A wrapper function for the normality tests available in this package.
#'
#' @param x A numeric vector containing the sample observations.
#' @param alpha Numeric (default: `0.05`). Significance level used to determine
#'        whether the null hypothesis is rejected. Must be between 0 and 1.
#' @param silent Logical (default: `FALSE`). If `FALSE`, print the test
#'        results to the console.
#' @param summary Logical (default: `TRUE`). If `TRUE`, return a summary
#'        table of the test results.
#' @param method Character. Abbreviation specifying the normality test to perform.
#'        Available options are `c("AD", "DAP", "JB", "SW", "SF", "SWR")`.
#' @param ... Additional arguments passed to the selected test function.
#'
#' @details
#' The `method` argument specifies the statistical procedure used to
#' assess whether a sample is consistent with a normal distribution.
#' Different tests emphasize different characteristics of departures
#' from normality, such as skewness, kurtosis, or discrepancies in the
#' tails of the distribution. Because no single test performs optimally
#' under all circumstances, the choice of method may depend on sample
#' size and the expected type of non-normality.
#'
#' Available methods are:
#'
#' - `"AD"`: Anderson–Darling test.
#'   A modification of the empirical distribution function (EDF)
#'   approach that gives greater weight to observations in the tails
#'   of the distribution. Compared with several alternative normality
#'   tests, the Anderson–Darling procedure is often more sensitive to
#'   deviations occurring in extreme values and tail behavior. This test is
#'   applicable only for sample sizes `n >= 8`.
#'
#' - `"DAP"`: D'Agostino–Pearson test.
#'   A combined omnibus moment test based on sample skewness and kurtosis.
#'   The procedure transforms the skewness and kurtosis statistics into
#'   approximately standard normal variables and combines them into a
#'   single test statistic. This method is designed to detect a broad
#'   range of departures from normality rather than emphasizing any
#'   particular feature. This test is applicable only for sample sizes
#'   `n >= 20`.
#'
#' - `"JB"`: Jarque–Bera test.
#'   An omnibus moment test based on sample skewness and kurtosis.
#'   The test evaluates whether the observed skewness and kurtosis
#'   differ significantly from the values expected under a normal
#'   distribution. The method is commonly used in econometrics and is
#'   generally more appropriate for moderate to large sample sizes.
#'
#' - `"SW"`: Shapiro–Wilk test.
#'   The original normality test proposed by Shapiro and Wilk (1965),
#'   based on the correlation between ordered observations and their
#'   expected values under normality. It is widely regarded as one of
#'   the most powerful tests for detecting departures from normality in
#'   small samples. Applicable only for sample sizes
#'   `3 <= n <= 50`.
#'
#' - `"SF"`: Shapiro–Francia test.
#'   Proposed by Shapiro and Francia (1972) and subsequently simplified
#'   and extended by Royston (1993). This method is a computationally
#'   simpler modification of the Shapiro–Wilk procedure that performs
#'   particularly well for detecting departures associated with
#'   heavier-tailed distributions. Applicable only for sample sizes
#'   `5 <= n <= 5000`.
#'
#' - `"SWR"`: Shapiro–Wilk test with Royston's modifications.
#'   Uses Royston's (1992) approximations for the null distribution of
#'   the Shapiro–Wilk statistic and extends applicability to larger
#'   samples while maintaining behavior similar to the original test.
#'   Applicable only for sample sizes `3 <= n <= 5000`.
#'
#' In all methods, the null hypothesis is that the sample is drawn from
#' a normal distribution. Small p-values indicate evidence against the
#' assumption of normality.
#'
#' @returns A list.
#'
#' @examples
#' check_normality(rnorm(20), method = "AD")
#' check_normality(rnorm(20), method = "DAP")
#' check_normality(rnorm(20), method = "SW")
#' @export
check_normality <- function(
        x,
        alpha = 0.05,
        silent = FALSE,
        summary = TRUE,
        method = "SWR",
        ...
) {
    tests <- c("AD", "DAP", "JB", "SW", "SF", "SWR")
    method <- toupper(method)
    method <- match.arg(method, tests)
    m <- match(method, tests)
    stopifnot(alpha >= 0 & alpha <= 1)

    func <- switch(m,
                   Anderson_Darling_test,
                   D.Agostino_Pearson_test,
                   Jarque_Bera_test,
                   Shapiro_Wilk_test,
                   Shapiro_Wilk_test,
                   Shapiro_Wilk_test)

    if (method %in% c("SW", "SF", "SWR"))
        ret <- func(x, alpha, method, silent = silent, summary = summary, ...)
    else
        ret <- func(x, alpha, silent = silent, summary = summary, ...)

    invisible(ret)
}
