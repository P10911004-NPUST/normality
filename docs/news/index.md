# Changelog

## normality 0.0.5

## normality 0.0.4

CRAN release: 2026-08-22

- Modified
  [`check_normality()`](https://p10911004-npust.github.io/normality/reference/check_normality.md),
  accepts both atomic input and data frame + formula input.
- Implement
  [`Cramer_von_Mises_test()`](https://p10911004-npust.github.io/normality/reference/Cramer_von_Mises_test.md).
- bugfixed: `.Shapiro_Wilk_Royston()` didn’t create `mn1` variable when
  n ≤ 5.
- bugfixed: sort all input `x` before analysis.

## normality 0.0.3

CRAN release: 2026-07-07

- Implement
  [`Lilliefors_test()`](https://p10911004-npust.github.io/normality/reference/Lilliefors_test.md)

## normality 0.0.2

Submission failed: The submission failed because the CRAN package was
being updated too frequently. Therefore, I cancelled this submission and
will wait for the next patch release before resubmitting.

- Modified output format and improved functions documentation.
- Implement
  [`Shapiro_Wilk_test()`](https://p10911004-npust.github.io/normality/reference/Shapiro_Wilk_test.md)
  (original, Francia, and Royston versions).
- Implement a handy wrapper:
  [`is_normal()`](https://p10911004-npust.github.io/normality/reference/is_normal.md).

## normality 0.0.1

CRAN release: 2026-06-09

- Initial CRAN submission.
