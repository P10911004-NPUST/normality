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
#> Skewness = 0.2137 ;  p-value = 0.4948 
#> Kurtosis = 3.5746 ;  p-value = 0.22623 
#> 
#> Statistic (K2) = 1.9305 
#> p-value = 0.3809
#> --------------------------------------
print(out$summary)
#>                         alpha statistic      pval signif standard_value
#> skewness (sqrt-b1)       0.05 0.2137053 0.4948003     ns      0.6826939
#> kurtosis (b2)            0.05 3.5745950 0.2262337     ns      1.2101177
#> D'Agostino-Pearson (K2)  0.05 1.9304559 0.3808964     ns      1.9304559
#>                         critical_value        SE  CI_lower  CI_upper  N
#> skewness (sqrt-b1)            1.959964 0.3366007 -0.446020 0.8734306 50
#> kurtosis (b2)                 1.959964 0.6619084  2.277278 4.8719116 50
#> D'Agostino-Pearson (K2)       5.991465        NA        NA        NA 50
#>                                AVG        MED       MIN      MAX       SD
#> skewness (sqrt-b1)      0.03656361 0.03804607 -2.274115 2.755418 1.050075
#> kurtosis (b2)           0.03656361 0.03804607 -2.274115 2.755418 1.050075
#> D'Agostino-Pearson (K2) 0.03656361 0.03804607 -2.274115 2.755418 1.050075
```
