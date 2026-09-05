# D'Agostino–Pearson K² Normality Test

The D'Agostino–Pearson chi-squared (K²) test is a moment-based omnibus
test for normality.

## Usage

``` r
D.Agostino_Pearson_test(
  x,
  alpha = 0.05,
  alternative = c("two.sided", "less", "greater"),
  silent = FALSE,
  summary = TRUE,
  misc = FALSE
)
```

## Arguments

- x:

  Numeric vector. Must have length at least 20.

- alpha:

  Numeric (default: 0.05). Significance level for hypothesis testing.
  Must be between 0 and 1.

- alternative:

  Character (default: "two.sided"). Specifies the alternative
  hypothesis. Available options are c("two.sided", "less", "greater").
  Note that this option is only applied to the skewness and kurtosis
  components of the test.

- silent:

  Logical (default: FALSE). If `FALSE`, results are printed to the
  console.

- summary:

  Logical (default: TRUE). Produce a summary table.

- misc:

  Logical (default: FALSE). Output other unimportant parameters.

## Value

A list

## Details

It evaluates the null hypothesis that the data come from a normal
distribution by combining standardized measures of skewness and kurtosis
into a single chi-squared test statistic.

## References

D’Agostino, R.B., Belanger, A., D’Agostino, R.B., 1990. A Suggestion for
Using Powerful and Informative Tests of Normality. Am. Stat. 44,
316–321. https://doi.org/10.1080/00031305.1990.10475751

## Examples

``` r
out <- D.Agostino_Pearson_test(rnorm(50))
#> 
#> --------------------------------------
#> D'Agostino-Pearson (K2) normality test 
#> 
#> Alternative: two.sided 
#> 
#> Skewness = -0.3 ;  p-value = 0.34137 
#> Kurtosis = 3.2215 ;  p-value = 0.44715 
#> 
#> Statistic (K2) = 1.4831 
#> p-value = 0.47637
#> --------------------------------------
print(out$summary)
#>                         alpha  statistic      pval signif standard_value
#> skewness (sqrt-b1)       0.05 -0.2999548 0.3413731     ns     -0.9514558
#> kurtosis (b2)            0.05  3.2215093 0.4471496     ns      0.7601756
#> D'Agostino-Pearson (K2)  0.05  1.4831351 0.4763666     ns      1.4831351
#>                         critical_value        SE   CI_lower  CI_upper  N
#> skewness (sqrt-b1)            1.959964 0.3366007 -0.9596801 0.3597705 50
#> kurtosis (b2)                 1.959964 0.6619084  1.9241927 4.5188259 50
#> D'Agostino-Pearson (K2)       5.991465        NA         NA        NA 50
#>                               AVG       MED       MIN     MAX        SD
#> skewness (sqrt-b1)      0.1738065 0.2382645 -2.612334 2.12685 0.9899914
#> kurtosis (b2)           0.1738065 0.2382645 -2.612334 2.12685 0.9899914
#> D'Agostino-Pearson (K2) 0.1738065 0.2382645 -2.612334 2.12685 0.9899914
```
