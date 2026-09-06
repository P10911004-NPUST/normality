# Jarque-Bera Normality Test

Performs the Jarque-Bera chi-squared test, a moment-based omnibus test
for assessing normality.

## Usage

``` r
Jarque_Bera_test(
  x,
  alpha = 0.05,
  alternative = c("two.sided", "less", "greater"),
  silent = FALSE,
  summary = TRUE
)
```

## Arguments

- x:

  Numeric vector. Must contain at least 20 observations.

- alpha:

  Numeric (default: 0.05). Significance level for hypothesis testing.
  Must be between 0 and 1.

- alternative:

  Character (default: `"two.sided"`). Specifies the alternative
  hypothesis. Available options are `c("two.sided", "less", "greater")`.
  This argument applies only to the skewness and kurtosis components and
  does not affect the Jarque-Bera omnibus test statistic itself.

- silent:

  Logical (default: `FALSE`). If `FALSE`, results are printed to the
  console.

- summary:

  Logical (default: TRUE). Produce a summary table.

## Value

A list

## Details

The test evaluates the null hypothesis that the data are drawn from a
normal distribution by combining standardized measures of skewness and
kurtosis into a single chi-squared test statistic.

## References

Jarque, C.M., Bera, A.K., 1987. A Test for Normality of Observations and
Regression Residuals. Int. Stat. Rev. 55, 163–172.
https://doi.org/10.2307/1403192

## See also

[`D.Agostino_Pearson_test()`](https://p10911004-npust.github.io/normality/reference/D.Agostino_Pearson_test.md)

## Examples

``` r
out <- Jarque_Bera_test(rnorm(50))
#> 
#> ------------------------------------
#> Jarque-Bera (JB) normality test 
#> 
#> Alternative: two.sided 
#> 
#> Skewness = -0.388 ;  p-value = 0.22048 
#> Kurtosis = 2.9852 ;  p-value = 0.97944 
#> 
#> Statistic (JB) = 1.255 
#> p-value = 0.53391
#> ------------------------------------
print(out$summary)
#>                  alpha  statistic      pval signif standard_value
#> skewness (b1)     0.05 -0.3880089 0.2204761     ns    -1.22526306
#> kurtosis (b2)     0.05  2.9852133 0.9794439     ns    -0.02576604
#> Jarque-Bera (JB)  0.05  1.2550463 0.5339126     ns     1.25504633
#>                  critical_value        SE  CI_lower  CI_upper  N       AVG
#> skewness (b1)          1.959964 0.3166739 -1.008678 0.2326606 50 0.1411339
#> kurtosis (b2)          1.959964 0.5738823  1.860425 4.1100021 50 0.1411339
#> Jarque-Bera (JB)       5.991465        NA        NA        NA 50 0.1411339
#>                       MED       MIN     MAX        SD
#> skewness (b1)    0.243049 -2.612334 2.12685 0.9878414
#> kurtosis (b2)    0.243049 -2.612334 2.12685 0.9878414
#> Jarque-Bera (JB) 0.243049 -2.612334 2.12685 0.9878414
```
