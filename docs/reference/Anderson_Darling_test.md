# Anderson-Darling Normality Test

Performs the Anderson–Darling (A²) normality test, an EDF-based
goodness-of-fit test that gives greater weight to deviations in the
tails of the distribution.

## Usage

``` r
Anderson_Darling_test(
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

D’Agostino, R.B., 2017. Tests for the Normal Distribution. In:
D'Agostino, R.B., Stephens, M.A. (Eds.), Goodness-of-Fit Techniques, 1st
ed. Routledge, New York, pg. 372–373.
https://doi.org/10.1201/9780203753064

Stephens, M.A., 2017. Tests Based on EDF Statistics. In: D'Agostino,
R.B., Stephens, M.A. (Eds.), Goodness-of-Fit Techniques, 1st ed.
Routledge, New York, (Table 4.8 & 4.9) pg. 126–128.
https://doi.org/10.1201/9780203753064

Anderson, T.W., Darling, D.A., 1954. A Test of Goodness of Fit. J. Am.
Stat. Assoc. 49, 765–769. https://doi.org/10.1080/01621459.1954.10501232

## Examples

``` r
out <- Anderson_Darling_test(rnorm(10))
#> 
#> ------------------------------------
#> Anderson-Darling (A2) normality test 
#> 
#> Statistic (A2) = 0.3621 
#> p-value = 0.36758
#> ------------------------------------
print(out$summary)
#>                       alpha statistic      pval signif standard_value
#> Anderson-Darling (A2)  0.05 0.3621118 0.3675821     ns      0.3974177
#>                       critical_value SE CI_lower CI_upper  N        AVG
#> Anderson-Darling (A2)      0.6849762 NA       NA       NA 10 -0.4413645
#>                              MED       MIN      MAX       SD
#> Anderson-Darling (A2) -0.2457625 -2.437264 1.148412 1.117661
```
