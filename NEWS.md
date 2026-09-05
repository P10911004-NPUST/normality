# normality 0.0.5

* Modified `is_normal()` to allow data frame and formula as input
* Added vignettes
* Added pkgdown branch and built site on that branch

# normality 0.0.4

* Modified `check_normality()`, accepts both atomic input and data frame + formula input.
* Implement `Cramer_von_Mises_test()`.
* bugfixed: `.Shapiro_Wilk_Royston()` didn't create `mn1` variable when n &le; 5. 
* bugfixed: sort all input `x` before analysis.

# normality 0.0.3

* Implement `Lilliefors_test()`

# normality 0.0.2

Submission failed: 
The submission failed because the CRAN package was being updated too frequently. 
Therefore, I cancelled this submission and will wait for the next patch release before resubmitting.

* Modified output format and improved functions documentation.
* Implement `Shapiro_Wilk_test()` (original, Francia, and Royston versions).
* Implement a handy wrapper: `is_normal()`.

# normality 0.0.1

* Initial CRAN submission.
