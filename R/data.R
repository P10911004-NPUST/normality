#' Shapiro-Wilk normality test (coefficients)
#'
#' Coefficients (a<sub>i</sub>) for the W test for normality.
#'
#' @format A data frame with 50 rows and 25 variables:
#' \describe{
#'  rownames is the sample size (n);
#'  colnames is the corresponding coefficients (a<sub>i</sub>).
#' }
#'
#' @references
#' Shapiro, S.S., Wilk, M.B., 1965.
#' An Analysis of Variance Test for Normality (Complete Samples).
#' Biometrika 52, 591–611.
#' https://doi.org/10.2307/2333709
"Shapiro_Wilk_coef_table"


#' Shapiro-Wilk normality test (p-values)
#'
#' The percentage points (critical values of W) of the W test for n = 3(1)50.
#'
#' @format A data frame with 50 rows and 10 variables:
#' \describe{
#'  rownames is the sample size (n);
#'  colnames is the corresponding p-values.
#' }
#'
#' @references
#' Shapiro, S.S., Wilk, M.B., 1965.
#' An Analysis of Variance Test for Normality (Complete Samples).
#' Biometrika 52, 591–611.
#' https://doi.org/10.2307/2333709
"Shapiro_Wilk_pval_table"
