# Normality test

A wrapper function for the normality tests available in this package.

## Usage

``` r
check_normality(
  data,
  formula = NULL,
  alpha = 0.05,
  method = "SWR",
  summary = TRUE
)
```

## Arguments

- data:

  A data frame or a numeric vector.

- formula:

  Formula (default: NULL). If `data` is a data frame, define the val ~
  group.

- alpha:

  Numeric (default: `0.05`). Significance level used to determine
  whether the null hypothesis is rejected. Must be between 0 and 1.

- method:

  Character. Abbreviation specifying the normality test to perform.
  Available options are
  `c("AD", "CVM", "DAP", "JB", "LF", "SW", "SF", "SWR")`.

- summary:

  Logical (default: `TRUE`). If `TRUE`, return a summary table of the
  test results.

## Value

A list.

## Details

The `method` argument specifies the statistical procedure used to assess
whether a sample is consistent with a normal distribution. Different
tests emphasize different characteristics of departures from normality,
such as skewness, kurtosis, or discrepancies in the tails of the
distribution. Because no single test performs optimally under all
circumstances, the choice of method may depend on sample size and the
expected type of non-normality.

Available methods are:

- `"AD"`: Anderson–Darling test. A modification of the empirical
  distribution function (EDF) approach that gives greater weight to
  observations in the tails of the distribution. Compared with several
  alternative normality tests, the Anderson–Darling procedure is often
  more sensitive to deviations occurring in extreme values and tail
  behavior. This test is applicable only for sample sizes `n >= 8`.

- `"CVM"`: Cramér–von Mises test. An empirical distribution function
  (EDF)-based goodness-of-fit test that measures the overall discrepancy
  between the empirical and theoretical cumulative distribution
  functions by assigning relatively uniform weight across the entire
  distribution. Compared with the Anderson–Darling test, the Cramér–von
  Mises test is generally less sensitive to deviations in the tails but
  performs well for detecting overall departures from normality. This
  test is applicable only for sample sizes `n >= 8`.

- `"DAP"`: D'Agostino–Pearson test. A combined omnibus moment test based
  on sample skewness and kurtosis. The procedure transforms the skewness
  and kurtosis statistics into approximately standard normal variables
  and combines them into a single test statistic. This method is
  designed to detect a broad range of departures from normality rather
  than emphasizing any particular feature. This test is applicable only
  for sample sizes `n >= 20`.

- `"JB"`: Jarque–Bera test. An omnibus moment test based on sample
  skewness and kurtosis. The test evaluates whether the observed
  skewness and kurtosis differ significantly from the values expected
  under a normal distribution. The method is commonly used in
  econometrics and is generally more appropriate for moderate to large
  sample sizes.

- `"LF"`: Lilliefors test. The Lilliefors test is an EDF omnibus test
  modified from Kolmogorov-Smirnov test for the composite hypothesis of
  normality. The test statistic is the maximal absolute difference
  between empirical and hypothetical cumulative distribution function.

- `"SW"`: Shapiro–Wilk test. The original normality test proposed by
  Shapiro and Wilk (1965), based on the correlation between ordered
  observations and their expected values under normality. It is widely
  regarded as one of the most powerful tests for detecting departures
  from normality in small samples. Applicable only for sample sizes
  `3 <= n <= 50`.

- `"SF"`: Shapiro–Francia test. Proposed by Shapiro and Francia (1972)
  and subsequently simplified and extended by Royston (1993). This
  method is a computationally simpler modification of the Shapiro–Wilk
  procedure that performs particularly well for detecting departures
  associated with heavier-tailed distributions. Applicable only for
  sample sizes `5 <= n <= 5000`.

- `"SWR"`: Shapiro–Wilk test with Royston's modifications. Uses
  Royston's (1992) approximations for the null distribution of the
  Shapiro–Wilk statistic and extends applicability to larger samples
  while maintaining behavior similar to the original test. Applicable
  only for sample sizes `3 <= n <= 5000`.

In all methods, the null hypothesis is that the sample is drawn from a
normal distribution. Small p-values indicate evidence against the
assumption of normality.

## Examples

``` r
out_AD <- check_normality(rnorm(20), method = "AD")
out_DAP <- check_normality(rnorm(20), method = "DAP")
out_SW <- check_normality(rnorm(20), method = "SW")
```
