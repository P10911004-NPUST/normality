#' Shapiro-Wilk Normality Test
#'
#' Performs the Shapiro–Wilk normality test, which assesses whether a sample
#' originates from a normally distributed population using a regression-based
#' correlation method.
#'
#' @param x A numeric vector.
#' @param alpha Significance threshold (default: 0.05).
#' @param method Character (default: "SWR"). Use which modification of the test?
#'        Available options are c("SWR", "SF", "SW").
#' @param resampling Logical (default: TRUE).
#'        If `TRUE`, unlock the sample size limitation of the test by using
#'        sample resampling method.
#' @param silent Logical (default: FALSE). If `FALSE`, print out the results.
#' @param summary Logical (default: TRUE). Produce a summary table.
#' @param misc Logical (default: FALSE). Output other unimportant parameters.
#'
#' @details
#' method
#'  - "SW": Shapiro–Wilk test, the original normality test proposed by
#'          Shapiro and Wilk (1965). Applicable only for sample sizes
#'          3 <= n <= 50.
#'  - "SF": Shapiro–Francia test, proposed by Shapiro and Francia (1972)
#'          and subsequently simplified and extended by Royston (1993).
#'          Applicable only for sample sizes 5 <= n <= 5000.
#'  - "SWR": Shapiro–Wilk test with Royston's (1992) modifications for
#'           approximating the null distribution and extending the test
#'           to larger sample sizes. Applicable only for sample sizes
#'           3 <= n <= 5000.
#'
#' @returns A list.
#'
#' @examples
#' sw <- Shapiro_Wilk_test(rnorm(20), method = "SW")
#' print(sw$summary)
#' sf <- Shapiro_Wilk_test(rnorm(100) ^ 2, method = "SF")
#' print(sf$summary)
#' swr <- Shapiro_Wilk_test(rnorm(1e6), method = "SWR")
#' print(swr$summary)
#' @references
#' Shapiro, S.S., Wilk, M.B., 1965.
#' An Analysis of Variance Test for Normality (Complete Samples).
#' Biometrika 52, 591–611.
#' https://doi.org/10.2307/2333709
#'
#' Shapiro, S.S., Francia, R.S., 1972.
#' An Approximate Analysis of Variance Test for Normality.
#' J. Am. Stat. Assoc. 67, 215–216.
#' https://doi.org/10.1080/01621459.1972.10481232
#'
#' Royston, P., 1993.
#' A pocket-calculator algorithm for the Shapiro–Francia test for non-normality:
#' an application to medicine.
#' Stat. Med. 12, 181–184.
#' https://doi.org/10.1002/sim.4780120209
#'
#' Royston, P., 1992.
#' Approximating the Shapiro–Wilk W-test for non-normality.
#' Stat. Comput. 2, 117–119.
#' https://doi.org/10.1007/BF01891203
#' @export
Shapiro_Wilk_test <- function(
        x,
        alpha = 0.05,
        method = c("SWR", "SF", "SW"),
        resampling = TRUE,
        silent = FALSE,
        summary = TRUE,
        misc = FALSE
) {
    method <- toupper(method)
    method <- match.arg(method, c("SWR", "SF", "SW"))
    m <- match(method, c("SWR", "SF", "SW"))

    x <- sort(x[stats::complete.cases(x)])
    n <- length(x)

    test_name <- switch(m,
                        "Shapiro-Wilk-Royston (w) normality test  ",
                        "Shapiro-Francia (W') normality test  ",
                        "Shapiro-Wilk (W) normality test  ")

    test_symbol <- switch(m, "w", "W'", "W")

    func <- switch(m,
                   .Shapiro_Wilk_Royston,
                   .Shapiro_Francia,
                   .Shapiro_Wilk_original)

    max_n <- switch(m, 5000, 5000, 50)

    if (n > max_n)
    {
        if (isTRUE(resampling))
        {
            nsub <- ceiling(n / max_n)
            isub <- rep(1:nsub, length.out = n)

            tab_lst <- vector("list", nsub)
            misc_lst <- vector("list", nsub)
            Z_vct <- vector("numeric", nsub)
            for (i in 1:nsub)
            {
                if (isFALSE(silent))
                    cat(sprintf("Resampling: %s/%s\n", i, nsub))

                xi <- x[isub == i]

                out <- func(xi, alpha, silent = TRUE, summary)
                Z_vct[[i]] <- out[["misc"]][["Z"]]

                if (isTRUE(summary))
                {
                    tab <- out[["summary"]]
                    rownames(tab) <- sprintf("resample_%s", i)
                    tab_lst[[i]] <- tab
                }

                if (isTRUE(misc))
                    misc_lst[[i]] <- out[["misc"]]
            }

            names(misc_lst) <- paste("resample", 1:nsub, sep = "_")

            W <- mean(out[["statistic"]])
            Z <- mean(Z_vct)
            pval <- stats::pnorm(Z, lower.tail = FALSE)

            ret <- normality_standard_output(
                method = test_name,
                is_normal = (pval > alpha),
                alpha = alpha,
                alternative = "greater",
                statistic = stats::setNames(W, test_symbol),
                pvalue = pval
            )

            if (isTRUE(summary))
                ret[["summary"]] <- do.call(rbind.data.frame, tab_lst)

            if (isTRUE(misc))
                ret[["misc"]] <- misc_lst

        } else
            stop(sprintf("Sample size should be n <= %s", max_n))
    }

    if (n <= max_n)
        ret <- func(x, alpha, silent)

    if (isFALSE(silent))
    {
        statistic <- round(unname(ret[["statistic"]]), 4)
        pval <- round(ret[["pvalue"]], 5)
        cat(
            sprintf("\n%s\n", paste(rep("-", nchar(test_name)), collapse = "")),
            sprintf("%s\n\n", test_name),
            sprintf("Statistic (%s) = %s\n", test_symbol, statistic),
            sprintf("p-value = %s", pval),
            sprintf("\n%s\n", paste(rep("-", nchar(test_name)), collapse = ""))
        )
    }

    invisible(ret)
}


#==============================================================================#
#                              Internal function                               #
#==============================================================================#

.Shapiro_Wilk_original <- function(x, alpha = 0.05, silent = FALSE, summary = TRUE)
{
    x <- sort(x[stats::complete.cases(x)])
    n <- length(x)
    avg <- mean(x)
    SS <- sum((x - avg) ^ 2)

    if (x[1] - x[n] == 0) stop("All values are identical.")
    if (n < 3 || n > 50) stop("Sample size should be 3 <= n <= 50.")
    if (is_tied(x)) warning("Too many tied-values.")

    # If n is odd, remove the middle one, then x will become even
    if (n %% 2 != 0)
        x <- x[-((n + 1) / 2)]

    x1 <- sort(x)
    x2 <- rev(x1)

    a_ref <- unname(unlist(Shapiro_Wilk_coef_table[n, , drop = TRUE]))

    b <- vapply(X = 1:(n / 2),
                FUN = function(i) a_ref[[i]] * (x2[i] - x1[i]),
                FUN.VALUE = numeric(1))
    b <- sum(b)
    W <- (b ^ 2) / SS

    p_ref <- c(0, 0.01, 0.02, 0.05, 0.1, 0.5, 0.9, 0.95, 0.98, 0.99, 1)
    W_crit <- Shapiro_Wilk_pval_table[n, , drop = TRUE] # this is a list

    imin <- sum(W >= unlist(W_crit))

    pval <- interpolate(idx_i = W,
                        idx_1 = W_crit[[imin]],
                        idx_2 = W_crit[[imin + 1]],
                        val_1 = p_ref[imin],
                        val_2 = p_ref[imin + 1])

    ret <- normality_standard_output(
        method = "Shapiro-Wilk (W) normality test",
        is_normal = (pval > alpha),
        alpha = alpha,
        alternative = "greater",
        statistic = c("W" = W),
        pvalue = pval,
        misc = list("b" = b, "Wcrit" = W_crit)
    )

    if (isTRUE(summary))
    {
        ret[["summary"]] <- normality_standard_summary_table(
            method = "Shapiro-Wilk (W)",
            statistic = W,
            standard_value = W,
            critical_value = unname(W_crit[[match(alpha, p_ref)]]),
            pval = pval,
            signif = pval2asterisk(pval, c(alpha, 0.01, 0.001)),
            N = n,
            AVG = avg,
            MED = stats::median(x),
            MIN = min(x),
            MAX = max(x),
            SD = stats::sd(x)
        )
    }

    invisible(ret)
}


.Shapiro_Francia <- function(x, alpha = 0.05, silent = FALSE, summary = TRUE)
{
    x <- sort(x[stats::complete.cases(x)])
    n <- length(x)
    avg = mean(x)

    if (x[1] - x[n] == 0) stop("All values are identical.")
    if (n < 5 || n > 5000) stop("Sample size should be 5 <= n <= 5000.")
    if (is_tied(x)) warning("Too many tied-values.")

    m <- stats::qnorm(((1:n) - 0.375) / (n + 0.25))
    W <- stats::cor(x, m) ^ 2

    u <- log(n)
    v <- log(u)
    mu_hat <- 1.0521 * (v - u) - 1.2725
    sigma_hat <- 1.0308 - 0.26758 * (v + 2 / u)
    Z <- (log(1 - W) - mu_hat) / sigma_hat # refer to N(0, 1) upper tail
    pval <- stats::pnorm(Z, lower.tail = FALSE)
    Zcrit <- stats::qnorm(alpha, lower.tail = FALSE)

    ret <- normality_standard_output(
        method = "Shapiro-Francia (W') normality test",
        is_normal = (pval > 0.05),
        alpha = alpha,
        alternative = "greater",
        statistic = c("W'" = W),
        pvalue = pval,
        misc = c("m" = m, "mu_hat" = mu_hat, "sigma_hat" = sigma_hat,
                 "Z" = Z, "Zcrit" = Zcrit)
    )

    if (isTRUE(summary))
    {
        ret[["summary"]] <- normality_standard_summary_table(
            method = "Shapiro-Francia (W')",
            alpha = alpha,
            statistic = W,
            pval = pval,
            signif = pval2asterisk(pval, c(alpha, 0.01, 0.001)),
            standard_value = Z,
            critical_value = Zcrit,
            N = n,
            AVG = avg,
            MED = stats::median(x),
            MIN = min(x),
            MAX = max(x),
            SD = stats::sd(x)
        )
    }

    invisible(ret)
}



.Shapiro_Wilk_Royston <- function(x, alpha = 0.05, silent = FALSE, summary = TRUE)
{
    x <- sort(x[stats::complete.cases(x)])
    n <- length(x)
    avg <- mean(x)
    SS <- sum((x - avg) ^ 2)
    Zcrit <- stats::qnorm(alpha, lower.tail = FALSE)

    #----------------------- Error Message -----------------------#
    if (x[1] - x[n] == 0) stop("All values are identical.")
    if (is.na(n) || n < 3) stop("Sample size should be at least 3.")
    if (is_tied(x)) warning("Too many tied-values.")

    mi <- stats::qnorm(((1:n) - 0.375) / (n + 0.25))
    m2 <- sum(mi ^ 2) # equivalent to sum(t(mi) %*% mi)
    ci <- mi / sqrt(m2)

    .x <- 1 / sqrt(n)

    an <- (ci[n]
           + (0.221157 * .x)
           - (0.147981 * .x * .x)
           - (2.071190 * .x * .x * .x)
           + (4.434685 * .x * .x * .x * .x)
           - (2.706056 * .x * .x * .x * .x * .x))

    an1 <- (ci[n - 1]
            + (0.042981 * .x)
            - (0.293762 * .x * .x)
            - (1.752461 * .x * .x * .x)
            + (5.682633 * .x * .x * .x * .x)
            - (3.582663 * .x * .x * .x * .x * .x))

    if (n <= 5)
    {
        mn <- mi[n] ^ 2
        phi <- (m2 - 2 * mn) / (1 - 2 * an * an)
        ai <- mi / sqrt(phi)
        ai[1] <- -an
        ai[n] <- an
        if (n == 3) ai[2] <- 0
    } else {
        mn <- (mi[n]) ^ 2
        mn1 <- (mi[n - 1]) ^ 2
        phi <- (m2 - (2 * mn) - (2 * mn1)) / (1 - (2 * an * an) - (2 * an1 * an1))
        ai <- mi / sqrt(phi)
        ai[1] <- -an
        ai[2] <- -an1
        ai[n] <- an
        ai[n - 1] <- an1
    }

    W <- stats::cor(x, ai) ^ 2 # equivalent to (sum(ai * x) ^ 2) / SS

    if (n >= 3 & n <= 11) {
        gamma <- 0.459 * n - 2.273
        w <- -log(gamma - log(1 - W))
        mu <- 0.544 - (0.39978 * n) + (0.025054 * n * n) - (0.0006714 * n * n * n)
        sigma <- exp(1.3822 - 0.77857 * n + 0.062767 * n * n - 0.0020322 * n * n * n)
        Z <- (w - mu) / sigma
        pval <- stats::pnorm(Z, lower.tail = FALSE)
    }

    if (n >= 12 & n <= 5000)
    {
        gamma <- NA_real_
        e <- log(n)
        w <- log(1 - W)
        mu <- -1.5861 - (0.31082 * e) - (0.083751 * e * e) + (0.0038915 * e * e * e)
        sigma <- exp(-0.4803 - (0.082676 * e) + (0.0030302 * e * e))
        Z <- (w - mu) / sigma
        pval <- stats::pnorm(Z, lower.tail = FALSE)
    }

    Z <- (w - mu) / sigma
    pval <- stats::pnorm(Z, lower.tail = FALSE)

    ret <- normality_standard_output(
        method = "Shapiro-Wilk-Royston (w) normality test",
        is_normal = (pval > 0.05),
        alpha = alpha,
        alternative = "greater",
        statistic = c("W" = W, "normalized-W (w)" = w),
        pvalue = pval,
        misc = list("mTm" = m2, "ci" = ci,
                    "m(n)^2" = mn, "m(n-1)^2" = mn1, "m(i)" = mi,
                    "phi" = phi,
                    "a(n)" = an, "a(n-1)" = an1, "ai" = ai,
                    "gamma" = gamma, "mu" = mu, "sigma" = sigma,
                    "Z" = Z, "Zcrit" = Zcrit)
    )

    if (isTRUE(summary))
    {
        ret[["summary"]] <- normality_standard_summary_table(
            method = "Shapiro-Wilk-Royston (w)",
            alpha = alpha,
            statistic = w,
            pval = pval,
            signif = pval2asterisk(pval, c(alpha, 0.01, 0.001)),
            standard_value = Z,
            critical_value = Zcrit,
            N = n,
            AVG = avg,
            MED = stats::median(x),
            MIN = min(x),
            MAX = max(x),
            SD = stats::sd(x)
        )
    }

    return(ret)
}

