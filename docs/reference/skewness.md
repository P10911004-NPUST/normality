# Skewness test

The test evaluates whether the population skewness is equal to zero.
Under the null hypothesis, the data are assumed to originate from a
symmetric distribution. Significant positive or negative skewness
indicates asymmetry in the distribution and may suggest a departure from
normality.

## Usage

``` r
skewness(
  x,
  alpha = 0.05,
  alternative = c("two.sided", "less", "greater"),
  method = c("G1", "b1", "g1"),
  silent = FALSE,
  summary = TRUE
)
```

## Arguments

- x:

  Numeric vector containing the input data.

- alpha:

  Numeric (default: 0.05). Significance level for hypothesis testing.
  Must be between 0 and 1.

- alternative:

  Character (default: "two.sided"). Specifies the alternative
  hypothesis. Available options are c("two.sided", "less", "greater").

- method:

  Character (default: "G1"). Formula used to estimate skewness.
  Available options are c("G1", "b1", "g1"). The "g1" statistic is the
  conventional moment-based sample skewness. The "G1" and "b1"
  statistics apply finite-sample corrections to reduce the bias of "g1".

- silent:

  Logical (default: FALSE). If `FALSE`, the test results are printed to
  the console.

- summary:

  Logical (default: TRUE). Produce a summary table.

## Value

A list

## References

Joanes, D.N., Gill, C.A., 1998. Comparing measures of sample skewness
and kurtosis. J. R. Stat. Soc. D (The Statistician) 47, 183–189.
https://doi.org/10.1111/1467-9884.00122

Wright, D.B., Herrington, J.A., 2011. Problematic standard errors and
confidence intervals for skewness and kurtosis. Behav. Res. Methods 43,
8–17. https://doi.org/10.3758/s13428-010-0044-x

## Examples

``` r
skewness(rnorm(30))
#> 
#> --------------------------------------
#> Skewness test 
#> 
#> Alternative: two.sided 
#> 
#> Skewness (G1) = -0.2446
#> p-value = 1.43333
#> --------------------------------------
```
