tidy_to_dataframe <- function(data, formula = NULL)
{
    ret <- NULL

    if (is.atomic(data) & is.null(dim(data)))
    {
        ret <- data.frame(y = data, x = 1)
        attr(ret, "x_name") <- "IV"
        attr(ret, "y_name") <- "DV"
        return(ret)
    }

    if (is.recursive(data) & is.null(dim(data)))
    {
        data <- lapply(data, function(x) x[stats::complete.cases(x)])
        data <- data
        isub <- seq_along(data)
        grp <- names(data)
        if (is.null(grp)) grp <- isub
        lst <- lapply(
            isub,
            function(i)
            {
                vct <- data[[i]]
                vct <- vct[stats::complete.cases(vct)]
                if (is.null(vct) || length(vct) == 0)
                    df0 <- data.frame(y = NA_real_, x = grp[i])
                else
                    df0 <- data.frame(y = vct, x = grp[i])
            }
        )
        ret <- do.call(rbind.data.frame, lst)
        ret <- ret[stats::complete.cases(ret[["y"]]), ]
        ret[["x"]] <- as.character(ret[["x"]])
        attr(ret, "x_name") <- "IV"
        attr(ret, "y_name") <- "DV"
    }

    if (is.matrix(data))
        data <- as.data.frame(data)

    if (is.data.frame(data))
    {
        if (is.null(formula)) stop("Please specify the `formula`.")
        df0 <- stats::model.frame(formula, data, drop.unused.levels = TRUE)
        x_name <- colnames(df0)[2]
        y_name <- colnames(df0)[1]
        colnames(df0) <- c("y", "x")
        df0[["x"]] <- as.character(df0[["x"]])
        ret <- df0[stats::complete.cases(df0[["y"]]), ]
        attr(ret, "x_name") <- x_name
        attr(ret, "y_name") <- y_name
    }

    ret <- ret[order(ret[["x"]]), ]

    return(ret)
}


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
#' @param summary Statistic summary, if any.
#' @param statistic Numeric. The value used to calculate p-value.
#' @param pvalue Numeric. The p-value of the test.
#' @param misc List. Miscellaneous elements.
#'
#' @returns A list.
normality_standard_output <- function(
        method = "what test?",
        is_normal = NA,
        alpha = NA_real_,
        alternative = c("two.sided", "less", "greater"),
        summary = NULL,
        statistic = NA_real_,
        pvalue = NA_real_,
        misc = NULL
) {
    structure(
        .Data = list("method" = method,
                     "is_normal" = is_normal,
                     "alpha" = alpha,
                     "alternative" = alternative,
                     "summary" = summary,
                     "statistic" = statistic,
                     "pvalue" = pvalue,
                     "misc" = misc),
        class = c("normality", "list")
    )
}


normality_standard_summary_table <- function(
        method = "what test (?)",
        alpha = 0.05,
        statistic = NA_real_,
        pval = NA_real_,
        signif = NA_character_,
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
               "signif" = signif,
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


pval2asterisk <- function(x, alpha_lvl = c(0.05, 0.01, 0.001))
{
    a <- alpha_lvl

    if (any(is.na(a)) || length(a) != 3 || !is.numeric(a))
        stop("`alpha_lvl` should be a numeric vector with length of 3.")

    vapply(
        x,
        function(`_`)
        {
            if (`_` <= a[3]) return("***")
            if (`_` <= a[2] & `_` > a[3]) return("**")
            if (`_` <= a[1] & `_` > a[2]) return("*")
            if (`_` > a[1]) return("ns")
        },
        FUN.VALUE = character(1)
    )
}



