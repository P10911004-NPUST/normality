# Cramer-von Mises Normality Test

An empirical distribution function (EDF)-based goodness-of-fit test that
measures the overall discrepancy between the empirical and theoretical
cumulative distribution functions by assigning relatively uniform weight
across the entire distribution.

## Usage

``` r
Cramer_von_Mises_test(
  x,
  alpha = 0.05,
  silent = FALSE,
  summary = TRUE,
  misc = FALSE
)
```

## Arguments

- x:

  A numeric vector, at least length of 8.

- alpha:

  Numeric (default: 0.05). Significance threshold, range from 0 to 1.

- silent:

  Logical (default: FALSE). If `FALSE`, print out the results.

- summary:

  Logical (default: TRUE). Produce a summary table.

- misc:

  Logical (default: FALSE). Output other unimportant parameters.

## Value

A list.

## References

Thode, H. C., Jr., 2002. Goodness of fit tests. Testing for normality.
Marcel Dekker, New York. (Section 5.1.3, pg. 103)

Stephens, M.A., 2017. Tests Based on EDF Statistics. In: D'Agostino,
R.B., Stephens, M.A. (Eds.), Goodness-of-Fit Techniques, 1st ed.
Routledge, New York, (Table 4.9, pg. 127).
https://doi.org/10.1201/9780203753064

## Examples

``` r
out <- Cramer_von_Mises_test(rnorm(10))
#> 
#> ------------------------------------
#> Cramer-von-Mises (W2) normality test 
#> 
#> Statistic (W2) = 0.0672 
#> p-value = 0.27505
#> ------------------------------------
print(out$summary)
#>                       alpha  statistic      pval signif standard_value
#> Cramer-von-Mises (W2)  0.05 0.06719868 0.2750472     ns     0.07055862
#>                       critical_value SE CI_lower CI_upper  N       AVG
#> Cramer-von-Mises (W2)             NA NA       NA       NA 10 0.2808301
#>                             MED       MIN     MAX        SD
#> Cramer-von-Mises (W2) 0.2604233 -1.470736 1.33732 0.7979151
```
