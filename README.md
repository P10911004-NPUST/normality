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
[`Rita`](https://cran.r-project.org/package=Rita), 
[`moments`](https://cran.r-project.org/package=moments), 
[`cmstatr`](https://cran.r-project.org/package=cmstatr), 
and other friends.

# Installation

<!-- You can install the package from [CRAN](https://cran.r-project.org/package=normality) with:

``` r
install.packages("normality")
``` -->

or the developmental version from [GitHub](https://github.com/P10911004-NPUST/normality) with:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("P10911004-NPUST/normality")
```


# Quick start
```r
D.Agostino_Pearson_test(cholesterol)
```

<br>

# TODO
- Implement functions:  
  - [x] `skewness()`
  - [x] `kurtosis()`
  - [x] `Anderson_Darling_test()`
  - [ ] `Cramer_von_Mises_test()`
  - [ ] `Lilliefors_test()`
  - [x] `D.Agostino_Pearson_test()`
  - [ ] `Jarque_Bera_test()`
  - [ ] `Shapiro_Wilk_test()` with 3 alternatives:
    - [Shapiro-Wilk](https://doi.org/10.2307/2333709)
    - [Shapiro-Francia](https://doi.org/10.1080/01621459.1972.10481232)
    - [Shapiro-Wilk-Royston](https://doi.org/10.1007/BF01891203)
  - [ ] `Ryan_Joiner_test()` [pdf](https://www.additive-net.de/de/component/jdownloads/send/70-support/236-normal-probability-plots-and-tests-for-normality-thomas-a-ryan-jr-bryan-l-joiner)