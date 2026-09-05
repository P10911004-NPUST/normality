# **normality**

An R package as a toolkit of statistical approaches for assessing data
normality.

There are also other nice alternatives such as
[`nortest`](https://cran.r-project.org/package=nortest),
[`moments`](https://cran.r-project.org/package=moments),
[`cmstatr`](https://cran.r-project.org/package=cmstatr), and other
friends.

# Installation

You can install the package from
[CRAN](https://cran.r-project.org/package=normality) with:

``` r

install.packages("normality")
```

or the development version from
[GitHub](https://github.com/P10911004-NPUST/normality) with:

``` r

if (!require("pak")) install.packages("pak")
pak::pak("P10911004-NPUST/normality")
```

# Quick start

``` r

is_normal(rnorm(20), summary = TRUE)
```

  

# TODO

## Implement normality tests based on:

### 1. Chi-Square type (may not implemented)

### 2. Empirical distribution function (EDF):

`Kolmogorov_Smirnov_test()`

`Kuiper_test()`

[`Anderson_Darling_test()`](reference/Anderson_Darling_test.md)

[`Cramer_von_Mises_test()`](reference/Cramer_von_Mises_test.md)

[`Lilliefors_test()`](reference/Lilliefors_test.md)

### 3. Moments:

[`skewness()`](reference/skewness.md)

[`kurtosis()`](reference/kurtosis.md)

[`Jarque_Bera_test()`](reference/Jarque_Bera_test.md)

[`D.Agostino_Pearson_test()`](reference/D.Agostino_Pearson_test.md)

### 4. Regression and correlation:

[`Shapiro_Wilk_test()`](reference/Shapiro_Wilk_test.md) with 3
alternatives:

- [Shapiro-Wilk](https://doi.org/10.2307/2333709)
- [Shapiro-Francia](https://doi.org/10.1080/01621459.1972.10481232)
- [Shapiro-Wilk-Royston](https://doi.org/10.1007/BF01891203)

`Ryan_Joiner_test()`
[pdf](https://www.additive-net.de/de/component/jdownloads/send/70-support/236-normal-probability-plots-and-tests-for-normality-thomas-a-ryan-jr-bryan-l-joiner)

### Graphical analysis:

Q-Q plot

P-P plot

### Miscellaneous:

- \[?\] Searching…
