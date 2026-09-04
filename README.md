# **normality**

<!-- badges: start -->
[![Repo_Status_Badge](https://img.shields.io/badge/Status-Active-brightgreen.svg)](https://cran.r-project.org/package=normality)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/normality?color=brightgreen)](https://cran.r-project.org/package=normality)
[![R-CMD-check](https://github.com/P10911004-NPUST/normality/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/P10911004-NPUST/normality/actions/workflows/R-CMD-check.yaml)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/normality)](https://cranlogs.r-pkg.org/badges/normality)
[![Downloads](https://cranlogs.r-pkg.org/badges/normality?color=blue)](https://cranlogs.r-pkg.org/badges/normality)
<!-- [![License: MIT](https://img.shields.io/badge/License-MIT-maroon.svg)](https://opensource.org/licenses/MIT) -->
<!-- badges: end -->

An R package as a toolkit of statistical approaches for assessing data normality.

There are also other nice alternatives such as 
[`nortest`](https://cran.r-project.org/package=nortest),
[`moments`](https://cran.r-project.org/package=moments), 
[`cmstatr`](https://cran.r-project.org/package=cmstatr), 
and other friends.

# Installation

You can install the package from [CRAN](https://cran.r-project.org/package=normality) with:

```r
install.packages("normality")
```

or the development version from [GitHub](https://github.com/P10911004-NPUST/normality) with:

```r
if (!require("pak")) install.packages("pak")
pak::pak("P10911004-NPUST/normality")
```

# Quick start
```r
is_normal(rnorm(20), summary = TRUE)
```

<br>

# TODO

## Implement normality tests based on:

### 1. Chi-Square type (may not implemented)

### 2. Empirical distribution function (EDF):
- [ ] `Kolmogorov_Smirnov_test()`
- [ ] `Kuiper_test()`
- [x] `Anderson_Darling_test()`
- [x] `Cramer_von_Mises_test()`
- [x] `Lilliefors_test()`

### 3. Moments:
- [x] `skewness()`
- [x] `kurtosis()`
- [x] `Jarque_Bera_test()`
- [x] `D.Agostino_Pearson_test()`

### 4. Regression and correlation:
- [x] `Shapiro_Wilk_test()` with 3 alternatives:
  - [Shapiro-Wilk](https://doi.org/10.2307/2333709)
  - [Shapiro-Francia](https://doi.org/10.1080/01621459.1972.10481232)
  - [Shapiro-Wilk-Royston](https://doi.org/10.1007/BF01891203)
- [ ] `Ryan_Joiner_test()` [pdf](https://www.additive-net.de/de/component/jdownloads/send/70-support/236-normal-probability-plots-and-tests-for-normality-thomas-a-ryan-jr-bryan-l-joiner)

### Graphical analysis:
- [ ] Q-Q plot
- [ ] P-P plot

### Miscellaneous:
- [?] Searching...
