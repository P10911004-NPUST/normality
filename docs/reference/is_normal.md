# Normality test

A handy wrapper for data normality assessment using the
Shapiro-Wilk-Royston, D'Agostino-Pearson, and Anderson-Darling tests.

## Usage

``` r
is_normal(data, formula = NULL, alpha = 0.05, sensitivity = 2, summary = FALSE)
```

## Arguments

- data:

  A data frame or a numeric vector.

- formula:

  Formula (default: NULL). If `data` is a data frame, define the val ~
  group.

- alpha:

  Significance threshold, range from 0 to 1 (default: 0.05).

- sensitivity:

  Numeric, range from 1 to 3 (default: 2). The greater the value, the
  greater chance to consider as non-normal.

- summary:

  Logical (default: FALSE). If `TRUE`, show the summary table.

## Value

A boolean value (or a list if `summary = TRUE`).

## Examples

``` r
is_normal(iris, Sepal.Length ~ Species)
#> [1] TRUE
```
