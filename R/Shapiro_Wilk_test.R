Shapiro_Wilk_test <- function(x)
{
    return(0)
}




.Shapiro_Wilk_original <- function(x)
{
    # Shapiro, S.S., Wilk, M.B., 1965.
    # An Analysis of Variance Test for Normality (Complete Samples).
    # Biometrika 52, 591. https://doi.org/10.2307/2333709
    return(0)
}


#' Shapiro-Francia Normality Test
#'
#' Performs the Shapiro-Francia test of normality.
#'
#' @param x Numeric vector.
#'
#' @returns A list.
#'
#' @references
#' Shapiro, S.S., Francia, R.S., 1972.
#' An Approximate Analysis of Variance Test for Normality.
#' Journal of the American Statistical Association 67, 215–216.
#' https://doi.org/10.1080/01621459.1972.10481232
#'
#' Royston, P., 1993.
#' A pocket‐calculator algorithm for the shapiro‐francia test for non‐normality: An application to medicine.
#' Statistics in Medicine 12, 181–184. https://doi.org/10.1002/sim.4780120209
.Shapiro_Francia <- function(x)
{
    return(0)
}


.Shapiro_Wilk_Royston <- function(x)
{
    return(0)
}


testing <- function()
{
    m1 <- matrix(1:6, ncol = 2, byrow = TRUE)
    m1m2 <- crossprod(m1)


    return(0)
}

SS <- function(x)
{
    sum((x - mean(x)) ^ 2)
}
