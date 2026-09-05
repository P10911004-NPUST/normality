# Lilliefors Normality Test

Performs the Lilliefors normality test, which is an empirical
distribution function (EDF)-based goodness-of-fit test derived from the
Kolmogorov–Smirnov test, using the approximation proposed by Molin and
Abdi (1998).

## Usage

``` r
Lilliefors_test(x, alpha = 0.05, silent = FALSE, summary = TRUE, misc = FALSE)
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

Molin, P., Abdi, H., 1998. New tables and numerical approximation for
the Kolmogorov-Smirnov/Lillierfors/Van Soest test of normality.
Technical report, University of Bourgogne.

## Examples

``` r
out <- Lilliefors_test(rnorm(10))
#> 
#> --------------------------
#> Lilliefors normality test 
#> 
#> Statistic (D) = 0.1569 
#> p-value = 0.68674
#> --------------------------
print(out$summary)
#>                alpha statistic      pval signif standard_value critical_value
#> Lilliefors (D)  0.05 0.1568912 0.6867364     ns             NA        0.26338
#>                SE CI_lower CI_upper  N       AVG       MED       MIN      MAX
#> Lilliefors (D) NA       NA       NA 10 0.4824697 0.8080923 -1.675327 2.564408
#>                      SD
#> Lilliefors (D) 1.434503
```
