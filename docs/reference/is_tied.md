# Tied data

Tied data

## Usage

``` r
is_tied(x, ratio = 0.3, remove_NA = FALSE)
```

## Arguments

- x:

  A numeric vector

- ratio:

  Numeric (default: 0.3). The ratio threshold of being considred as
  tied-data. The value range from 0 to 1.

- remove_NA:

  Logical (default: TRUE). Whether or not to remove NAs.

## Value

Logical

## Examples

``` r
is_tied(c(1, 1, 2, 2, 2, 3, 4, 5))
#> [1] TRUE
#> TRUE
```
