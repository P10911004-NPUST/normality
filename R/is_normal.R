#' Normality test
#'
#' A handy wrapper for data normality assessment using the Shapiro-Wilk-Royston,
#' D'Agostino-Pearson, and Anderson-Darling tests.
#'
#' @param data A data frame or a numeric vector.
#' @param formula Formula (default: NULL). If `data` is a data frame, define the val ~ group.
#' @param alpha Significance threshold, range from 0 to 1 (default: 0.05).
#' @param sensitivity Numeric, range from 1 to 3 (default: 2).
#'        The greater the value, the greater chance to consider as non-normal.
#' @param summary Logical (default: FALSE). If `TRUE`, show the summary table.
#'
#' @returns A boolean value (or a list if `summary = TRUE`).
#'
#' @examples
#' is_normal(iris, Sepal.Length ~ Species)
#' @export
is_normal <- function(
        data,
        formula = NULL,
        alpha = 0.05,
        sensitivity = 2,
        summary = FALSE
) {
    stopifnot(alpha >= 0 & alpha <= 1)
    if (is.data.frame(data) & (missing(formula) || is.null(formula)))
        stop("Please specify `formula`")

    if (is.null(dim(data)) & is.atomic(data))
    {
        out <- .is_normal(data, alpha, sensitivity)
        bool <- out[["bool"]]
        tab_lst <- out[["summary"]]
    } else {
        df0 <- tidy_to_dataframe(data, formula)
        lst0 <- split(df0[["y"]], df0[["x"]])
        out <- lapply(lst0, function(`_`) .is_normal(`_`, alpha, sensitivity))
        tab_lst <- lapply(out, function(`_`) `_`[["summary"]])
        bool_lst <- unlist(lapply(out, function(`_`) `_`[["bool"]]))
        bool <- all(unlist(bool_lst))
    }

    if (isTRUE(summary))
        return(list("summary" = tab_lst, "is_normal" = bool))
    else
        return(bool)
}


.is_normal <- function(x, alpha = 0.05, sensitivity = 2)
{
    n <- length(x)

    if (n <= 3)
    {
        warning("Sample size should be greater than 3")
        return(list("bool" = FALSE, "summary" = NULL))
    }

    if (n < 8)
    {
        SWR <- Shapiro_Wilk_test(x, alpha, silent = TRUE)
        tab <- SWR[["summary"]]
        pval <- SWR[["pvalue"]]
        bool <- (pval > alpha)
    }

    if (n >= 8 & n < 20)
    {
        SWR <- Shapiro_Wilk_test(x, alpha, silent = TRUE)
        skew <- skewness(x, alpha, silent = TRUE)
        AD <- Anderson_Darling_test(x, alpha, silent = TRUE)
        tab <- rbind(SWR[["summary"]], skew[["summary"]], AD[["summary"]])
        pval <- tab[["pval"]]
        bool <- (sum(pval > alpha) >= sensitivity)
    }

    if (n >= 20)
    {
        SWR <- Shapiro_Wilk_test(x, alpha, silent = TRUE)
        DAP <- D.Agostino_Pearson_test(x, alpha, silent = TRUE)
        AD <- Anderson_Darling_test(x, alpha, silent = TRUE)
        tab <- rbind(SWR[["summary"]], DAP[["summary"]], AD[["summary"]])
        tab <- tab[grep("skew|kurt", rownames(tab), invert = TRUE), ]
        pval <- tab[["pval"]]
        bool <- (sum(pval > alpha) >= sensitivity)
    }

    return(list("bool" = bool, "summary" = tab))
}


