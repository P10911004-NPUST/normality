#' Normality test
#'
#' A handy wrapper for data normality test using the Shapiro-Wilk-Royston,
#' D'Agostino-Pearson, and Anderson-Darling tests.
#'
#' @param data A data frame or a numeric vector.
#' @param formula Formula (default: NULL).
#'        If `data` is a data frame, define the val ~ group.
#' @param alpha Significance threshold, range from 0 to 1 (default: 0.05).
#' @param sensitivity Numeric, range from 1 to 3 (default: 2).
#'        The greater the value, the greater chance to consider as non-normal.
#' @param summary Logical (default: FALSE). If `TRUE`, show the summary table.
#'
#' @returns A list or a boolean.
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

    if (is.null(dim(data)) & is.atomic(data))
    {
        out <- .is_normal(data, alpha, sensitivity)
        bool <- out[["bool"]]
        tab_lst <- out[["summary"]]
    }

    if (is.matrix(data))
        data <- as.data.frame(data)

    if (is.data.frame(data) & !is.null(formula))
    {
        df0 <- stats::model.frame(formula = formula,
                                  data = data,
                                  drop.unused.levels = TRUE)

        y <- as.numeric(df0[[1]])
        x <- as.character(df0[[2]])
        grps <- unique(x)

        bool_vct <- vector("logical", length(grps))
        tab_lst <- vector("list", length(grps))
        names(tab_lst) <- grps
        for (i in seq_along(grps))
        {
            grp_name <- grps[i]
            yi <- y[x == grp_name]
            yi <- yi[stats::complete.cases(yi)]
            n <- length(yi)

            if (n < 3)
                stop(sprintf("Factor `%s`: Sample size < 3", grp_name))

            if (yi[1] - yi[n] == 0)
                stop(sprintf("Factor `%s`: All values are identical.", grp_name))

            out <- .is_normal(yi, alpha, sensitivity)
            tab_lst[[grp_name]] <- out[["summary"]]
            bool_vct[i] <- out[["bool"]]
        }

        bool <- all(bool_vct)
    }

    if (isTRUE(summary))
        return(list("summary" = tab_lst, "is_normal" = bool))
    else
        return(bool)
}


.is_normal <- function(x, alpha = 0.05, sensitivity = 2)
{
    n <- length(x)

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


