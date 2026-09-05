# Standard output format

The standard output format for `normality` package.

## Usage

``` r
normality_standard_output(
  method = "what test?",
  is_normal = NA,
  alpha = NA_real_,
  alternative = c("two.sided", "less", "greater"),
  summary = NULL,
  statistic = NA_real_,
  pvalue = NA_real_,
  misc = NULL
)
```

## Arguments

- method:

  Character. The name of the test.

- is_normal:

  Logical. Is the input data normally distributed?

- alpha:

  Numeric (default: 0.05). Significance threshold.

- alternative:

  Character. The alternative hypothesis (H1) to test. Available options
  are c("two.sided", "less", "greater").

- summary:

  Statistic summary, if any.

- statistic:

  Numeric. The value used to calculate p-value.

- pvalue:

  Numeric. The p-value of the test.

- misc:

  List. Miscellaneous elements.

## Value

A list.
