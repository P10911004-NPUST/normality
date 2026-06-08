#' Cholesterol data
#'
#' A numeric vector, the cholesterol values from a sample of 62 subjects from the
#'  Framingham Heart Study (FHS). This dataset was obtained from D'Agostino paper.
#'
#' @format A numeric vector length of 62.
#'
#' @references
#' D’Agostino, R.B., Belanger, A., D’Agostino Jr., R.B., 1990.
#' A Suggestion for Using Powerful and Informative Tests of Normality.
#' Am. Stat. 44, 316–321.
#' https://doi.org/10.1080/00031305.1990.10475751
"cholesterol"


#' Leghorn chicken data
#'
#' A numeric vector
#'
#' @format A numeric vector length of 20.
#'
#' @references
#' Stephens, M.A., 2017. Tests Based on EDF Statistics.
#' In: D’Agostino, R.B., Stephens, M.A. (Eds.),
#' Goodness-of-Fit Techniques, 1st ed. Routledge, New York,
#' pp. 98.
#' https://doi.org/10.1201/9780203753064
"leghorn_chick"


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
