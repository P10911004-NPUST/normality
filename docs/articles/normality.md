# normality

``` r

library(normality)
```

## 1. Overview

The `normality` R package provides a collection of statistical tools for
assessing whether a sample is consistent with a normal distribution. It
includes:

- empirical distribution function (EDF)-based tests;
- moment-based tests;
- Shapiro-family tests;
- skewness and kurtosis assessments;
- high-level automatic normality assessment

## 2. Installation

Install the released version from
[CRAN](https://cran.r-project.org/package=normality):

``` r

install.packages("normality")
```

or the development version from
[GitHub](https://github.com/P10911004-NPUST/normality):

``` r

if (!require("pak")) install.packages("pak")
pak::pak("P10911004-NPUST/normality")
```

Then load the package:

``` r

library(normality)

# For reproducibility
set.seed(123)
```

## 3. Quick start

The simplest way to assess a numeric vector is with
[`is_normal()`](../reference/is_normal.md).

``` r

x <- rnorm(30)
is_normal(x)
#> [1] TRUE
```

For a more detailed result:

``` r

is_normal(x, summary = TRUE)
#> $summary
#>                          alpha statistic      pval signif standard_value
#> Shapiro-Wilk-Royston (W)  0.05 0.9789351 0.7965839     ns     -0.8294810
#> D'Agostino-Pearson (K2)   0.05 0.4871878 0.7838059     ns      0.4871878
#> Anderson-Darling (A2)     0.05 0.1995093 0.8730283     ns      0.2049958
#>                          critical_value SE CI_lower CI_upper  N         AVG
#> Shapiro-Wilk-Royston (W)      1.6448536 NA       NA       NA 30 -0.04710376
#> D'Agostino-Pearson (K2)       5.9914645 NA       NA       NA 30 -0.04710376
#> Anderson-Darling (A2)         0.7307448 NA       NA       NA 30 -0.04710376
#>                                  MED       MIN      MAX        SD
#> Shapiro-Wilk-Royston (W) -0.07373326 -1.966617 1.786913 0.9810307
#> D'Agostino-Pearson (K2)  -0.07373326 -1.966617 1.786913 0.9810307
#> Anderson-Darling (A2)    -0.07373326 -1.966617 1.786913 0.9810307
#> 
#> $is_normal
#> [1] TRUE
```

**If you only require a quick check for data normality, use `is_normal`
and feel free to skip the remainder of this guide.**

For explicit test selection, use
[`check_normality()`](../reference/check_normality.md):

``` r

check_normality(x, method = "SWR")
#>   x is_normal    Pvalue         W                                  method
#> 1 1      TRUE 0.7965839 0.9789351 Shapiro-Wilk-Royston (w) normality test
```

## 4. Understanding normality testing

Most formal normality tests use:

\\H_0: X \sim N(\mu, \sigma^2)\\

versus

\\H_1: X \not\sim N(\mu, \sigma^2)\\

A small p-value provides evidence against normality. A large p-value
indicates that the test did not detect sufficient evidence of departure
from normality.

A large p-value does **not** prove that the data are normally
distributed.

Different tests are sensitive to different forms of departure. For
example, skewness-based procedures focus on asymmetry, kurtosis-based
procedures focus on tail weight, and EDF procedures compare the
empirical and theoretical distributions.

## 5. Available tests

| Method | Function | Sample-size |
|----|----|----|
| AD | [`Anderson_Darling_test()`](../reference/Anderson_Darling_test.md) | ≥ 8 |
| CVM | [`Cramer_von_Mises_test()`](../reference/Cramer_von_Mises_test.md) | ≥ 8 |
| LF | [`Lilliefors_test()`](../reference/Lilliefors_test.md) | ≥ 8 |
| DAP | [`D.Agostino_Pearson_test()`](../reference/D.Agostino_Pearson_test.md) | ≥ 20 |
| JB | [`Jarque_Bera_test()`](../reference/Jarque_Bera_test.md) | ≥ 20 |
| SW | `Shapiro_Wilk_test(method = "SW")` | 3–50 |
| SF | `Shapiro_Wilk_test(method = "SF")` | 5–5000 |
| SWR | `Shapiro_Wilk_test(method = "SWR")` | 3–5000 |

### 5.1. Anderson–Darling test

The Anderson–Darling test is an EDF-based goodness-of-fit test that
places greater emphasis on discrepancies in the tails.

``` r

ad <- Anderson_Darling_test(x)
#> 
#> ------------------------------------
#> Anderson-Darling (A2) normality test 
#> 
#> Statistic (A2) = 0.1995 
#> p-value = 0.87303
#> ------------------------------------
```

The summary table is available with:

``` r

ad$summary
#>                       alpha statistic      pval signif standard_value
#> Anderson-Darling (A2)  0.05 0.1995093 0.8730283     ns      0.2049958
#>                       critical_value SE CI_lower CI_upper  N         AVG
#> Anderson-Darling (A2)      0.7307448 NA       NA       NA 30 -0.04710376
#>                               MED       MIN      MAX        SD
#> Anderson-Darling (A2) -0.07373326 -1.966617 1.786913 0.9810307
```

### 5.2. Cramér–von Mises test

The Cramér–von Mises test is also EDF-based and evaluates discrepancies
throughout the distribution.

``` r

cvm <- Cramer_von_Mises_test(x)
#> 
#> ------------------------------------
#> Cramer-von-Mises (W2) normality test 
#> 
#> Statistic (W2) = 0.0286 
#> p-value = 0.85958
#> ------------------------------------
```

Conceptually, Anderson–Darling emphasizes the tails more strongly,
whereas Cramér–von Mises gives more uniform weight to discrepancies.

### 5.3. Lilliefors test

The Lilliefors test is an EDF-based procedure derived from the
Kolmogorov–Smirnov framework and adapted for testing normality when the
population mean and standard deviation are estimated from the sample.

``` r

lf <- Lilliefors_test(x)
#> 
#> --------------------------
#> Lilliefors normality test 
#> 
#> Statistic (D) = 0.0911 
#> p-value = 0.7531
#> --------------------------
```

### 5.4. D’Agostino–Pearson test

The D’Agostino–Pearson test is an omnibus moment-based test combining
information from skewness and kurtosis.

``` r

dap <- D.Agostino_Pearson_test(x)
#> 
#> --------------------------------------
#> D'Agostino-Pearson (K2) normality test 
#> 
#> Alternative: two.sided 
#> 
#> Skewness = 0.1427 ;  p-value = 0.7094 
#> Kurtosis = 2.3627 ;  p-value = 0.55507 
#> 
#> Statistic (K2) = 0.4872 
#> p-value = 0.78381
#> --------------------------------------
```

The `alternative` argument can be used for component skewness and
kurtosis assessments:

``` r

D.Agostino_Pearson_test(x, alternative = "two.sided")
```

### 5.5. Jarque–Bera test

The Jarque–Bera test is another moment-based omnibus normality test.

``` r

jb <- Jarque_Bera_test(x)
#> 
#> ------------------------------------
#> Jarque-Bera (JB) normality test 
#> 
#> Alternative: two.sided 
#> 
#> Skewness = 0.1356 ;  p-value = 0.72474 
#> Kurtosis = 2.2078 ;  p-value = 0.22604 
#> 
#> Statistic (JB) = 0.8765 
#> p-value = 0.64518
#> ------------------------------------
```

### 5.6. Shapiro-family tests

The Shapiro-family tests are generally the most powerful. However, they
are limited by ties in the data and provide no numerical indication of
the nature of non-normality as a by-product ([D’Agostino,
1986](https://doi.org/10.1201/9780203753064); Section 9.5).

[`Shapiro_Wilk_test()`](../reference/Shapiro_Wilk_test.md) provides
three related procedures:

- `SW`: Shapiro–Wilk;
- `SF`: Shapiro–Francia;
- `SWR`: Shapiro–Wilk with Royston’s modifications (default).

#### Original Shapiro–Wilk

``` r

sw <- Shapiro_Wilk_test(x, method = "SW")
#> 
#> ---------------------------------
#>  Shapiro-Wilk (W) normality test  
#> 
#>  Statistic (W) = 0.9756
#>  p-value = 0.7146 
#> ---------------------------------
```

#### Shapiro–Francia

``` r

sf <- Shapiro_Wilk_test(x, method = "SF")
#> 
#> -------------------------------------
#>  Shapiro-Francia (W') normality test  
#> 
#>  Statistic (W) = 0.986
#>  p-value = 0.90151 
#> -------------------------------------
```

#### Shapiro–Wilk with Royston’s modifications

``` r

# Equivalent to Shapiro_Wilk_test(x)
swr <- Shapiro_Wilk_test(x, method = "SWR")
#> 
#> -----------------------------------------
#>  Shapiro-Wilk-Royston (w) normality test  
#> 
#>  Statistic (W) = 0.9789
#>  p-value = 0.79658 
#> -----------------------------------------
```

#### Very large samples

The Shapiro-family procedures have finite sample-size limits in their
direct implementations.
[`Shapiro_Wilk_test()`](../reference/Shapiro_Wilk_test.md) applies an
re-sampling mechanism by default for observations above the maximum
supported sample size.

``` r

x_large <- rnorm(10000)
Shapiro_Wilk_test(x_large, resampling = TRUE)
```

## 6. Testing multiple groups

The high-level functions support data frames and formulas.

``` r

data("iris")
check_normality(iris, Sepal.Length ~ Species, method = "SWR")
#>            x is_normal    Pvalue         W
#> 1     setosa      TRUE 0.4595132 0.9776985
#> 2 versicolor      TRUE 0.4647370 0.9778357
#> 3  virginica      TRUE 0.2583148 0.9711794
#>                                    method
#> 1 Shapiro-Wilk-Royston (w) normality test
#> 2 Shapiro-Wilk-Royston (w) normality test
#> 3 Shapiro-Wilk-Royston (w) normality test
```

The formula has the form:

``` text
response ~ group
```

The same interface is available in
[`is_normal()`](../reference/is_normal.md):

``` r

out <- is_normal(iris, Sepal.Length ~ Species, summary = TRUE)
```

For samples fewer than 8 observations, the automatic assessment relies
on Shapiro–Wilk–Royston.

For samples from 8 through 19 observations, it combines:

- Shapiro–Wilk–Royston;
- skewness; and
- Anderson–Darling.

For samples of at least 20 observations, it combines:

- Shapiro–Wilk–Royston;
- D’Agostino–Pearson; and
- Anderson–Darling.

The `sensitivity` argument controls how many component assessments must
support normality. Its allowed range is 1 to 3. A larger value makes the
criterion more conservative.

``` r

set.seed(123)
x1 <- c(rnorm(20), runif(10))

for (i in 1:3)
{
    res <- is_normal(x1, sensitivity = i)
    print(sprintf("When sensitivity is %i: %s", i, res))
}
#> [1] "When sensitivity is 1: TRUE"
#> [1] "When sensitivity is 2: TRUE"
#> [1] "When sensitivity is 3: FALSE"
```

## 7. Skewness

The [`skewness()`](../reference/skewness.md) function assesses
distributional asymmetry. Three estimators (`G1`, `b1`, `g1`) are
available ([Joanes & Gill,
1998](https://doi.org/10.1111/1467-9884.00122), [Wright & Herrington,
2011](https://doi.org/10.3758/s13428-010-0044-x)).

``` r

skewness(x, method = "G1")
#> 
#> --------------------------------------
#> Skewness test 
#> 
#> Alternative: two.sided 
#> 
#> Skewness (G1) = 0.1503
#> p-value = 0.72474
#> --------------------------------------
skewness(x, method = "b1")
#> 
#> --------------------------------------
#> Skewness test 
#> 
#> Alternative: two.sided 
#> 
#> Skewness (b1) = 0.1356
#> p-value = 0.72474
#> --------------------------------------
skewness(x, method = "g1")
#> 
#> --------------------------------------
#> Skewness test 
#> 
#> Alternative: two.sided 
#> 
#> Skewness (g1) = 0.1427
#> p-value = 0.72474
#> --------------------------------------
```

## 8. Kurtosis

The [`kurtosis()`](../reference/kurtosis.md) function assesses
tail-related distributional characteristics. Three estimators (`G2`,
`b2`, `g2`) are available ([Joanes & Gill,
1998](https://doi.org/10.1111/1467-9884.00122), [Wright & Herrington,
2011](https://doi.org/10.3758/s13428-010-0044-x)).

``` r

kurtosis(x, method = "G2")
#> 
#> --------------------------------------
#> Kurtosis test 
#> 
#> Alternative: two.sided 
#> 
#> Kurtosis (G2) = 2.4723
#> p-value = 1.47373
#> --------------------------------------
kurtosis(x, method = "b2")
#> 
#> --------------------------------------
#> Kurtosis test 
#> 
#> Alternative: two.sided 
#> 
#> Kurtosis (b2) = 2.2078
#> p-value = 1.77396
#> --------------------------------------
kurtosis(x, method = "g2")
#> 
#> --------------------------------------
#> Kurtosis test 
#> 
#> Alternative: two.sided 
#> 
#> Kurtosis (g2) = 2.3627
#> p-value = 1.63723
#> --------------------------------------
```

## 9. Interpreting results

**If a test produces a p-value of 0.12**, the appropriate conclusion is:

> The test did not provide sufficient evidence to reject the null
> hypothesis of normality.

**If the p-value is 0.003:**

> The test provided evidence against the assumption of normality.

The next step should be to investigate the nature and practical
importance of the departure.

  

## Summary

The **normality** package provides a unified toolkit for assessing
departures from normality.

The main functions are:

- [`is_normal()`](../reference/is_normal.md) for high-level automatic
  assessment;
- [`check_normality()`](../reference/check_normality.md) for selecting a
  specific normality test;
- [`Shapiro_Wilk_test()`](../reference/Shapiro_Wilk_test.md) for
  Shapiro-family procedures;
- [`Anderson_Darling_test()`](../reference/Anderson_Darling_test.md) for
  tail-sensitive EDF testing;
- [`Cramer_von_Mises_test()`](../reference/Cramer_von_Mises_test.md) for
  overall EDF discrepancy;
- [`Lilliefors_test()`](../reference/Lilliefors_test.md) for KS-type
  normality assessment;
- [`D.Agostino_Pearson_test()`](../reference/D.Agostino_Pearson_test.md)
  and [`Jarque_Bera_test()`](../reference/Jarque_Bera_test.md) for
  moment-based tests;
- [`skewness()`](../reference/skewness.md) for distributional asymmetry;
  and
- [`kurtosis()`](../reference/kurtosis.md) for tail-related
  characteristics.

Formal tests are most informative when considered together with sample
size, graphical diagnostics, and the assumptions of the statistical
method that will subsequently be applied.

  

## References

Anderson, T.W., & Darling, D.A. (1954). A test of goodness of fit.
*Journal of the American Statistical Association*, 49, 765–769.
<https://doi.org/10.1080/01621459.1954.10501232>

D’Agostino, R.B. (1986). Goodness-of-Fit-Techniques (1st ed.).
Routledge. <https://doi.org/10.1201/9780203753064>

D’Agostino, R.B., Belanger, A., & D’Agostino, R.B. (1990). A suggestion
for using powerful and informative tests of normality. *The American
Statistician*, 44, 316–321.
<https://doi.org/10.1080/00031305.1990.10475751>

Jarque, C.M., & Bera, A.K. (1987). A test for normality of observations
and regression residuals. *International Statistical Review*, 55,
163–172. <https://doi.org/10.2307/1403192>

Joanes, D.N., Gill, C.A. (1998). Comparing measures of sample skewness
and kurtosis. *Journal of the Royal Statistical Society: Series D (The
Statistician)*, 47, 183–189. <https://doi.org/10.1111/1467-9884.00122>

Molin, P. & Abdi, H. (1998). New table and numerical approximations for
Kolmogorov-Smirnov/Lilliefors/Van Soest normality test. Technical
report, University of Bourgogne.

Royston, P. (1992). Approximating the Shapiro–Wilk W-test for
non-normality. *Statistics and Computing*, 2, 117–119.
<https://doi.org/10.1007/BF01891203>

Royston, P. (1993). A pocket-calculator algorithm for the
Shapiro–Francia test for non-normality: an application to medicine.
*Statistics in Medicine*, 12, 181–184.
<https://doi.org/10.1002/sim.4780120209>

Shapiro, S.S. & Francia, R.S. (1972). An approximate analysis of
variance test for normality. *Journal of the American Statistical
Association*, 67, 215–216.
<https://doi.org/10.1080/01621459.1972.10481232>

Shapiro, S.S. & Wilk, M.B. (1965). An analysis of variance test for
normality (complete samples). *Biometrika*, 52, 591–611.
<https://doi.org/10.2307/2333709>

Thode, H.C. (2002). Testing For Normality (1st ed.). CRC Press.
<https://doi.org/10.1201/9780203910894>

Wright, D.B. & Herrington, J.A. (2011). Problematic standard errors and
confidence intervals for skewness and kurtosis. *Behavior Research
Methods*, 43, 8–17. <https://doi.org/10.3758/s13428-010-0044-x>
