# Shapiro-Wilk Normality Test

Performs the Shapiro–Wilk normality test, which assesses whether a
sample originates from a normally distributed population using a
regression-based correlation method.

## Usage

``` r
Shapiro_Wilk_test(
  x,
  alpha = 0.05,
  method = c("SWR", "SF", "SW"),
  silent = FALSE,
  summary = TRUE,
  misc = FALSE,
  resampling = TRUE
)
```

## Arguments

- x:

  A numeric vector.

- alpha:

  Significance threshold (default: 0.05).

- method:

  Character (default: "SWR"). Use which modification of the test?
  Available options are c("SWR", "SF", "SW").

- silent:

  Logical (default: FALSE). If `FALSE`, print out the results.

- summary:

  Logical (default: TRUE). Produce a summary table.

- misc:

  Logical (default: FALSE). Output other unimportant parameters.

- resampling:

  Logical (default: TRUE). If `TRUE`, unlock the sample size limitation
  of the test by using sample resampling method.

## Value

A list.

## Details

method

- "SW": Shapiro–Wilk test, the original normality test proposed by
  Shapiro and Wilk (1965). Applicable only for sample sizes 3 \<= n \<=
  50.

- "SF": Shapiro–Francia test, proposed by Shapiro and Francia (1972) and
  subsequently simplified and extended by Royston (1993). Applicable
  only for sample sizes 5 \<= n \<= 5000.

- "SWR": Shapiro–Wilk test with Royston's (1992) modifications for
  approximating the null distribution and extending the test to larger
  sample sizes. Applicable only for sample sizes 3 \<= n \<= 5000.

## References

Shapiro, S.S., Wilk, M.B., 1965. An Analysis of Variance Test for
Normality (Complete Samples). Biometrika 52, 591–611.
https://doi.org/10.2307/2333709

Shapiro, S.S., Francia, R.S., 1972. An Approximate Analysis of Variance
Test for Normality. J. Am. Stat. Assoc. 67, 215–216.
https://doi.org/10.1080/01621459.1972.10481232

Royston, P., 1993. A pocket-calculator algorithm for the Shapiro–Francia
test for non-normality: an application to medicine. Stat. Med. 12,
181–184. https://doi.org/10.1002/sim.4780120209

Royston, P., 1992. Approximating the Shapiro–Wilk W-test for
non-normality. Stat. Comput. 2, 117–119.
https://doi.org/10.1007/BF01891203

## Examples

``` r
sw <- Shapiro_Wilk_test(rnorm(20), method = "SW")
#> 
#> ---------------------------------
#>  Shapiro-Wilk (W) normality test  
#> 
#>  Statistic (W) = 0.9505
#>  p-value = 0.41261 
#> ---------------------------------
print(sw$summary)
#>                  alpha statistic      pval signif standard_value critical_value
#> Shapiro-Wilk (W)  0.05 0.9504793 0.4126078     ns      0.9504793          0.905
#>                  SE CI_lower CI_upper  N        AVG        MED     MIN      MAX
#> Shapiro-Wilk (W) NA       NA       NA 20 0.05897066 0.07451203 -1.5091 1.876506
#>                        SD
#> Shapiro-Wilk (W) 1.027541
sf <- Shapiro_Wilk_test(rnorm(100) ^ 2, method = "SF")
#> 
#> -------------------------------------
#>  Shapiro-Francia (W') normality test  
#> 
#>  Statistic (W) = 0.7412
#>  p-value = 0 
#> -------------------------------------
print(sf$summary)
#>                      alpha statistic         pval signif standard_value
#> Shapiro-Francia (W')  0.05 0.7412324 2.135711e-10    ***       6.243772
#>                      critical_value SE CI_lower CI_upper   N      AVG       MED
#> Shapiro-Francia (W')       1.644854 NA       NA       NA 100 1.109753 0.6198591
#>                               MIN      MAX       SD
#> Shapiro-Francia (W') 9.771503e-06 7.016841 1.409735
swr <- Shapiro_Wilk_test(rnorm(1e6), method = "SWR")
#> Resampling: 1/200
#> Resampling: 2/200
#> Resampling: 3/200
#> Resampling: 4/200
#> Resampling: 5/200
#> Resampling: 6/200
#> Resampling: 7/200
#> Resampling: 8/200
#> Resampling: 9/200
#> Resampling: 10/200
#> Resampling: 11/200
#> Resampling: 12/200
#> Resampling: 13/200
#> Resampling: 14/200
#> Resampling: 15/200
#> Resampling: 16/200
#> Resampling: 17/200
#> Resampling: 18/200
#> Resampling: 19/200
#> Resampling: 20/200
#> Resampling: 21/200
#> Resampling: 22/200
#> Resampling: 23/200
#> Resampling: 24/200
#> Resampling: 25/200
#> Resampling: 26/200
#> Resampling: 27/200
#> Resampling: 28/200
#> Resampling: 29/200
#> Resampling: 30/200
#> Resampling: 31/200
#> Resampling: 32/200
#> Resampling: 33/200
#> Resampling: 34/200
#> Resampling: 35/200
#> Resampling: 36/200
#> Resampling: 37/200
#> Resampling: 38/200
#> Resampling: 39/200
#> Resampling: 40/200
#> Resampling: 41/200
#> Resampling: 42/200
#> Resampling: 43/200
#> Resampling: 44/200
#> Resampling: 45/200
#> Resampling: 46/200
#> Resampling: 47/200
#> Resampling: 48/200
#> Resampling: 49/200
#> Resampling: 50/200
#> Resampling: 51/200
#> Resampling: 52/200
#> Resampling: 53/200
#> Resampling: 54/200
#> Resampling: 55/200
#> Resampling: 56/200
#> Resampling: 57/200
#> Resampling: 58/200
#> Resampling: 59/200
#> Resampling: 60/200
#> Resampling: 61/200
#> Resampling: 62/200
#> Resampling: 63/200
#> Resampling: 64/200
#> Resampling: 65/200
#> Resampling: 66/200
#> Resampling: 67/200
#> Resampling: 68/200
#> Resampling: 69/200
#> Resampling: 70/200
#> Resampling: 71/200
#> Resampling: 72/200
#> Resampling: 73/200
#> Resampling: 74/200
#> Resampling: 75/200
#> Resampling: 76/200
#> Resampling: 77/200
#> Resampling: 78/200
#> Resampling: 79/200
#> Resampling: 80/200
#> Resampling: 81/200
#> Resampling: 82/200
#> Resampling: 83/200
#> Resampling: 84/200
#> Resampling: 85/200
#> Resampling: 86/200
#> Resampling: 87/200
#> Resampling: 88/200
#> Resampling: 89/200
#> Resampling: 90/200
#> Resampling: 91/200
#> Resampling: 92/200
#> Resampling: 93/200
#> Resampling: 94/200
#> Resampling: 95/200
#> Resampling: 96/200
#> Resampling: 97/200
#> Resampling: 98/200
#> Resampling: 99/200
#> Resampling: 100/200
#> Resampling: 101/200
#> Resampling: 102/200
#> Resampling: 103/200
#> Resampling: 104/200
#> Resampling: 105/200
#> Resampling: 106/200
#> Resampling: 107/200
#> Resampling: 108/200
#> Resampling: 109/200
#> Resampling: 110/200
#> Resampling: 111/200
#> Resampling: 112/200
#> Resampling: 113/200
#> Resampling: 114/200
#> Resampling: 115/200
#> Resampling: 116/200
#> Resampling: 117/200
#> Resampling: 118/200
#> Resampling: 119/200
#> Resampling: 120/200
#> Resampling: 121/200
#> Resampling: 122/200
#> Resampling: 123/200
#> Resampling: 124/200
#> Resampling: 125/200
#> Resampling: 126/200
#> Resampling: 127/200
#> Resampling: 128/200
#> Resampling: 129/200
#> Resampling: 130/200
#> Resampling: 131/200
#> Resampling: 132/200
#> Resampling: 133/200
#> Resampling: 134/200
#> Resampling: 135/200
#> Resampling: 136/200
#> Resampling: 137/200
#> Resampling: 138/200
#> Resampling: 139/200
#> Resampling: 140/200
#> Resampling: 141/200
#> Resampling: 142/200
#> Resampling: 143/200
#> Resampling: 144/200
#> Resampling: 145/200
#> Resampling: 146/200
#> Resampling: 147/200
#> Resampling: 148/200
#> Resampling: 149/200
#> Resampling: 150/200
#> Resampling: 151/200
#> Resampling: 152/200
#> Resampling: 153/200
#> Resampling: 154/200
#> Resampling: 155/200
#> Resampling: 156/200
#> Resampling: 157/200
#> Resampling: 158/200
#> Resampling: 159/200
#> Resampling: 160/200
#> Resampling: 161/200
#> Resampling: 162/200
#> Resampling: 163/200
#> Resampling: 164/200
#> Resampling: 165/200
#> Resampling: 166/200
#> Resampling: 167/200
#> Resampling: 168/200
#> Resampling: 169/200
#> Resampling: 170/200
#> Resampling: 171/200
#> Resampling: 172/200
#> Resampling: 173/200
#> Resampling: 174/200
#> Resampling: 175/200
#> Resampling: 176/200
#> Resampling: 177/200
#> Resampling: 178/200
#> Resampling: 179/200
#> Resampling: 180/200
#> Resampling: 181/200
#> Resampling: 182/200
#> Resampling: 183/200
#> Resampling: 184/200
#> Resampling: 185/200
#> Resampling: 186/200
#> Resampling: 187/200
#> Resampling: 188/200
#> Resampling: 189/200
#> Resampling: 190/200
#> Resampling: 191/200
#> Resampling: 192/200
#> Resampling: 193/200
#> Resampling: 194/200
#> Resampling: 195/200
#> Resampling: 196/200
#> Resampling: 197/200
#> Resampling: 198/200
#> Resampling: 199/200
#> Resampling: 200/200
#> 
#> -----------------------------------------
#>  Shapiro-Wilk-Royston (w) normality test  
#> 
#>  Statistic (W) = 0.9999
#>  p-value = 1 
#> -----------------------------------------
print(swr$summary)
#>              alpha statistic      pval signif standard_value critical_value SE
#> resample_1    0.05 0.9995387 0.2791191     ns      0.5854604       1.644854 NA
#> resample_2    0.05 0.9995685 0.3408555     ns      0.4101296       1.644854 NA
#> resample_3    0.05 0.9998277 0.9772006     ns     -1.9990876       1.644854 NA
#> resample_4    0.05 0.9998568 0.9934898     ns     -2.4832112       1.644854 NA
#> resample_5    0.05 0.9998624 0.9951878     ns     -2.5890416       1.644854 NA
#> resample_6    0.05 0.9998759 0.9978839     ns     -2.8603217       1.644854 NA
#> resample_7    0.05 0.9998886 0.9991668     ns     -3.1440107       1.644854 NA
#> resample_8    0.05 0.9999040 0.9997958     ns     -3.5346601       1.644854 NA
#> resample_9    0.05 0.9999058 0.9998304     ns     -3.5834306       1.644854 NA
#> resample_10   0.05 0.9999206 0.9999724     ns     -4.0327272       1.644854 NA
#> resample_11   0.05 0.9999244 0.9999841     ns     -4.1595266       1.644854 NA
#> resample_12   0.05 0.9999279 0.9999908     ns     -4.2831062       1.644854 NA
#> resample_13   0.05 0.9999324 0.9999958     ns     -4.4540662       1.644854 NA
#> resample_14   0.05 0.9999336 0.9999966     ns     -4.4999763       1.644854 NA
#> resample_15   0.05 0.9999341 0.9999969     ns     -4.5208686       1.644854 NA
#> resample_16   0.05 0.9999354 0.9999976     ns     -4.5717429       1.644854 NA
#> resample_17   0.05 0.9999434 0.9999996     ns     -4.9209176       1.644854 NA
#> resample_18   0.05 0.9999449 0.9999997     ns     -4.9915240       1.644854 NA
#> resample_19   0.05 0.9999453 0.9999997     ns     -5.0069350       1.644854 NA
#> resample_20   0.05 0.9999496 0.9999999     ns     -5.2246568       1.644854 NA
#> resample_21   0.05 0.9999508 0.9999999     ns     -5.2847087       1.644854 NA
#> resample_22   0.05 0.9999528 1.0000000     ns     -5.3983923       1.644854 NA
#> resample_23   0.05 0.9999536 1.0000000     ns     -5.4382671       1.644854 NA
#> resample_24   0.05 0.9999564 1.0000000     ns     -5.6045588       1.644854 NA
#> resample_25   0.05 0.9999581 1.0000000     ns     -5.7072530       1.644854 NA
#> resample_26   0.05 0.9999604 1.0000000     ns     -5.8556569       1.644854 NA
#> resample_27   0.05 0.9999608 1.0000000     ns     -5.8843598       1.644854 NA
#> resample_28   0.05 0.9999614 1.0000000     ns     -5.9223013       1.644854 NA
#> resample_29   0.05 0.9999620 1.0000000     ns     -5.9635196       1.644854 NA
#> resample_30   0.05 0.9999625 1.0000000     ns     -5.9999726       1.644854 NA
#> resample_31   0.05 0.9999629 1.0000000     ns     -6.0305923       1.644854 NA
#> resample_32   0.05 0.9999634 1.0000000     ns     -6.0608863       1.644854 NA
#> resample_33   0.05 0.9999641 1.0000000     ns     -6.1146134       1.644854 NA
#> resample_34   0.05 0.9999655 1.0000000     ns     -6.2218430       1.644854 NA
#> resample_35   0.05 0.9999663 1.0000000     ns     -6.2806950       1.644854 NA
#> resample_36   0.05 0.9999667 1.0000000     ns     -6.3097971       1.644854 NA
#> resample_37   0.05 0.9999671 1.0000000     ns     -6.3454900       1.644854 NA
#> resample_38   0.05 0.9999676 1.0000000     ns     -6.3818121       1.644854 NA
#> resample_39   0.05 0.9999682 1.0000000     ns     -6.4363625       1.644854 NA
#> resample_40   0.05 0.9999696 1.0000000     ns     -6.5492359       1.644854 NA
#> resample_41   0.05 0.9999699 1.0000000     ns     -6.5775581       1.644854 NA
#> resample_42   0.05 0.9999703 1.0000000     ns     -6.6117165       1.644854 NA
#> resample_43   0.05 0.9999708 1.0000000     ns     -6.6593855       1.644854 NA
#> resample_44   0.05 0.9999713 1.0000000     ns     -6.7053955       1.644854 NA
#> resample_45   0.05 0.9999725 1.0000000     ns     -6.8108662       1.644854 NA
#> resample_46   0.05 0.9999734 1.0000000     ns     -6.9012840       1.644854 NA
#> resample_47   0.05 0.9999737 1.0000000     ns     -6.9305568       1.644854 NA
#> resample_48   0.05 0.9999744 1.0000000     ns     -6.9992352       1.644854 NA
#> resample_49   0.05 0.9999747 1.0000000     ns     -7.0296077       1.644854 NA
#> resample_50   0.05 0.9999749 1.0000000     ns     -7.0551457       1.644854 NA
#> resample_51   0.05 0.9999751 1.0000000     ns     -7.0754282       1.644854 NA
#> resample_52   0.05 0.9999753 1.0000000     ns     -7.0976888       1.644854 NA
#> resample_53   0.05 0.9999760 1.0000000     ns     -7.1699567       1.644854 NA
#> resample_54   0.05 0.9999763 1.0000000     ns     -7.1984408       1.644854 NA
#> resample_55   0.05 0.9999766 1.0000000     ns     -7.2367856       1.644854 NA
#> resample_56   0.05 0.9999768 1.0000000     ns     -7.2579650       1.644854 NA
#> resample_57   0.05 0.9999775 1.0000000     ns     -7.3427322       1.644854 NA
#> resample_58   0.05 0.9999778 1.0000000     ns     -7.3702336       1.644854 NA
#> resample_59   0.05 0.9999778 1.0000000     ns     -7.3752392       1.644854 NA
#> resample_60   0.05 0.9999780 1.0000000     ns     -7.3949789       1.644854 NA
#> resample_61   0.05 0.9999781 1.0000000     ns     -7.4112144       1.644854 NA
#> resample_62   0.05 0.9999786 1.0000000     ns     -7.4687286       1.644854 NA
#> resample_63   0.05 0.9999788 1.0000000     ns     -7.5006671       1.644854 NA
#> resample_64   0.05 0.9999789 1.0000000     ns     -7.5084254       1.644854 NA
#> resample_65   0.05 0.9999794 1.0000000     ns     -7.5733092       1.644854 NA
#> resample_66   0.05 0.9999797 1.0000000     ns     -7.6065920       1.644854 NA
#> resample_67   0.05 0.9999799 1.0000000     ns     -7.6302200       1.644854 NA
#> resample_68   0.05 0.9999802 1.0000000     ns     -7.6717116       1.644854 NA
#> resample_69   0.05 0.9999803 1.0000000     ns     -7.6886470       1.644854 NA
#> resample_70   0.05 0.9999804 1.0000000     ns     -7.7019004       1.644854 NA
#> resample_71   0.05 0.9999811 1.0000000     ns     -7.7936847       1.644854 NA
#> resample_72   0.05 0.9999812 1.0000000     ns     -7.8114917       1.644854 NA
#> resample_73   0.05 0.9999816 1.0000000     ns     -7.8691013       1.644854 NA
#> resample_74   0.05 0.9999821 1.0000000     ns     -7.9393435       1.644854 NA
#> resample_75   0.05 0.9999822 1.0000000     ns     -7.9563446       1.644854 NA
#> resample_76   0.05 0.9999823 1.0000000     ns     -7.9716692       1.644854 NA
#> resample_77   0.05 0.9999825 1.0000000     ns     -8.0001292       1.644854 NA
#> resample_78   0.05 0.9999828 1.0000000     ns     -8.0391486       1.644854 NA
#> resample_79   0.05 0.9999825 1.0000000     ns     -8.0053672       1.644854 NA
#> resample_80   0.05 0.9999827 1.0000000     ns     -8.0226505       1.644854 NA
#> resample_81   0.05 0.9999828 1.0000000     ns     -8.0496733       1.644854 NA
#> resample_82   0.05 0.9999831 1.0000000     ns     -8.0877693       1.644854 NA
#> resample_83   0.05 0.9999832 1.0000000     ns     -8.1005210       1.644854 NA
#> resample_84   0.05 0.9999833 1.0000000     ns     -8.1165770       1.644854 NA
#> resample_85   0.05 0.9999835 1.0000000     ns     -8.1492980       1.644854 NA
#> resample_86   0.05 0.9999836 1.0000000     ns     -8.1691917       1.644854 NA
#> resample_87   0.05 0.9999838 1.0000000     ns     -8.2095511       1.644854 NA
#> resample_88   0.05 0.9999840 1.0000000     ns     -8.2389921       1.644854 NA
#> resample_89   0.05 0.9999841 1.0000000     ns     -8.2481872       1.644854 NA
#> resample_90   0.05 0.9999846 1.0000000     ns     -8.3324387       1.644854 NA
#> resample_91   0.05 0.9999847 1.0000000     ns     -8.3559406       1.644854 NA
#> resample_92   0.05 0.9999851 1.0000000     ns     -8.4141762       1.644854 NA
#> resample_93   0.05 0.9999851 1.0000000     ns     -8.4225844       1.644854 NA
#> resample_94   0.05 0.9999846 1.0000000     ns     -8.3402170       1.644854 NA
#> resample_95   0.05 0.9999846 1.0000000     ns     -8.3338248       1.644854 NA
#> resample_96   0.05 0.9999846 1.0000000     ns     -8.3332941       1.644854 NA
#> resample_97   0.05 0.9999849 1.0000000     ns     -8.3857780       1.644854 NA
#> resample_98   0.05 0.9999853 1.0000000     ns     -8.4553143       1.644854 NA
#> resample_99   0.05 0.9999855 1.0000000     ns     -8.4966344       1.644854 NA
#> resample_100  0.05 0.9999855 1.0000000     ns     -8.4983918       1.644854 NA
#> resample_101  0.05 0.9999855 1.0000000     ns     -8.4972068       1.644854 NA
#> resample_102  0.05 0.9999853 1.0000000     ns     -8.4617700       1.644854 NA
#> resample_103  0.05 0.9999851 1.0000000     ns     -8.4216095       1.644854 NA
#> resample_104  0.05 0.9999847 1.0000000     ns     -8.3470886       1.644854 NA
#> resample_105  0.05 0.9999843 1.0000000     ns     -8.2805864       1.644854 NA
#> resample_106  0.05 0.9999843 1.0000000     ns     -8.2794450       1.644854 NA
#> resample_107  0.05 0.9999844 1.0000000     ns     -8.3060173       1.644854 NA
#> resample_108  0.05 0.9999845 1.0000000     ns     -8.3101066       1.644854 NA
#> resample_109  0.05 0.9999846 1.0000000     ns     -8.3384467       1.644854 NA
#> resample_110  0.05 0.9999846 1.0000000     ns     -8.3277619       1.644854 NA
#> resample_111  0.05 0.9999847 1.0000000     ns     -8.3517342       1.644854 NA
#> resample_112  0.05 0.9999847 1.0000000     ns     -8.3472721       1.644854 NA
#> resample_113  0.05 0.9999845 1.0000000     ns     -8.3201878       1.644854 NA
#> resample_114  0.05 0.9999838 1.0000000     ns     -8.2092673       1.644854 NA
#> resample_115  0.05 0.9999840 1.0000000     ns     -8.2342120       1.644854 NA
#> resample_116  0.05 0.9999845 1.0000000     ns     -8.3099430       1.644854 NA
#> resample_117  0.05 0.9999846 1.0000000     ns     -8.3275879       1.644854 NA
#> resample_118  0.05 0.9999848 1.0000000     ns     -8.3693740       1.644854 NA
#> resample_119  0.05 0.9999847 1.0000000     ns     -8.3557733       1.644854 NA
#> resample_120  0.05 0.9999845 1.0000000     ns     -8.3151574       1.644854 NA
#> resample_121  0.05 0.9999846 1.0000000     ns     -8.3345925       1.644854 NA
#> resample_122  0.05 0.9999847 1.0000000     ns     -8.3529692       1.644854 NA
#> resample_123  0.05 0.9999847 1.0000000     ns     -8.3457614       1.644854 NA
#> resample_124  0.05 0.9999847 1.0000000     ns     -8.3455482       1.644854 NA
#> resample_125  0.05 0.9999847 1.0000000     ns     -8.3454977       1.644854 NA
#> resample_126  0.05 0.9999848 1.0000000     ns     -8.3763590       1.644854 NA
#> resample_127  0.05 0.9999850 1.0000000     ns     -8.4037416       1.644854 NA
#> resample_128  0.05 0.9999851 1.0000000     ns     -8.4153526       1.644854 NA
#> resample_129  0.05 0.9999848 1.0000000     ns     -8.3642075       1.644854 NA
#> resample_130  0.05 0.9999845 1.0000000     ns     -8.3098456       1.644854 NA
#> resample_131  0.05 0.9999846 1.0000000     ns     -8.3303137       1.644854 NA
#> resample_132  0.05 0.9999846 1.0000000     ns     -8.3278435       1.644854 NA
#> resample_133  0.05 0.9999845 1.0000000     ns     -8.3113479       1.644854 NA
#> resample_134  0.05 0.9999844 1.0000000     ns     -8.3005945       1.644854 NA
#> resample_135  0.05 0.9999843 1.0000000     ns     -8.2789623       1.644854 NA
#> resample_136  0.05 0.9999843 1.0000000     ns     -8.2839168       1.644854 NA
#> resample_137  0.05 0.9999844 1.0000000     ns     -8.2937193       1.644854 NA
#> resample_138  0.05 0.9999844 1.0000000     ns     -8.2955391       1.644854 NA
#> resample_139  0.05 0.9999842 1.0000000     ns     -8.2641987       1.644854 NA
#> resample_140  0.05 0.9999841 1.0000000     ns     -8.2551428       1.644854 NA
#> resample_141  0.05 0.9999840 1.0000000     ns     -8.2313158       1.644854 NA
#> resample_142  0.05 0.9999839 1.0000000     ns     -8.2122153       1.644854 NA
#> resample_143  0.05 0.9999834 1.0000000     ns     -8.1358092       1.644854 NA
#> resample_144  0.05 0.9999831 1.0000000     ns     -8.0837052       1.644854 NA
#> resample_145  0.05 0.9999831 1.0000000     ns     -8.0947647       1.644854 NA
#> resample_146  0.05 0.9999832 1.0000000     ns     -8.0990776       1.644854 NA
#> resample_147  0.05 0.9999836 1.0000000     ns     -8.1720120       1.644854 NA
#> resample_148  0.05 0.9999834 1.0000000     ns     -8.1408043       1.644854 NA
#> resample_149  0.05 0.9999831 1.0000000     ns     -8.0953938       1.644854 NA
#> resample_150  0.05 0.9999831 1.0000000     ns     -8.0875826       1.644854 NA
#> resample_151  0.05 0.9999829 1.0000000     ns     -8.0563276       1.644854 NA
#> resample_152  0.05 0.9999827 1.0000000     ns     -8.0286363       1.644854 NA
#> resample_153  0.05 0.9999824 1.0000000     ns     -7.9887278       1.644854 NA
#> resample_154  0.05 0.9999824 1.0000000     ns     -7.9850526       1.644854 NA
#> resample_155  0.05 0.9999823 1.0000000     ns     -7.9728488       1.644854 NA
#> resample_156  0.05 0.9999823 1.0000000     ns     -7.9648065       1.644854 NA
#> resample_157  0.05 0.9999819 1.0000000     ns     -7.9052359       1.644854 NA
#> resample_158  0.05 0.9999815 1.0000000     ns     -7.8521495       1.644854 NA
#> resample_159  0.05 0.9999814 1.0000000     ns     -7.8328921       1.644854 NA
#> resample_160  0.05 0.9999811 1.0000000     ns     -7.7973867       1.644854 NA
#> resample_161  0.05 0.9999808 1.0000000     ns     -7.7501132       1.644854 NA
#> resample_162  0.05 0.9999804 1.0000000     ns     -7.7061357       1.644854 NA
#> resample_163  0.05 0.9999800 1.0000000     ns     -7.6556769       1.644854 NA
#> resample_164  0.05 0.9999797 1.0000000     ns     -7.6089491       1.644854 NA
#> resample_165  0.05 0.9999794 1.0000000     ns     -7.5706639       1.644854 NA
#> resample_166  0.05 0.9999793 1.0000000     ns     -7.5563342       1.644854 NA
#> resample_167  0.05 0.9999790 1.0000000     ns     -7.5162200       1.644854 NA
#> resample_168  0.05 0.9999786 1.0000000     ns     -7.4776395       1.644854 NA
#> resample_169  0.05 0.9999786 1.0000000     ns     -7.4702287       1.644854 NA
#> resample_170  0.05 0.9999782 1.0000000     ns     -7.4174047       1.644854 NA
#> resample_171  0.05 0.9999776 1.0000000     ns     -7.3570829       1.644854 NA
#> resample_172  0.05 0.9999774 1.0000000     ns     -7.3300593       1.644854 NA
#> resample_173  0.05 0.9999770 1.0000000     ns     -7.2822466       1.644854 NA
#> resample_174  0.05 0.9999767 1.0000000     ns     -7.2432225       1.644854 NA
#> resample_175  0.05 0.9999763 1.0000000     ns     -7.2018817       1.644854 NA
#> resample_176  0.05 0.9999759 1.0000000     ns     -7.1583431       1.644854 NA
#> resample_177  0.05 0.9999755 1.0000000     ns     -7.1205014       1.644854 NA
#> resample_178  0.05 0.9999748 1.0000000     ns     -7.0427410       1.644854 NA
#> resample_179  0.05 0.9999743 1.0000000     ns     -6.9865326       1.644854 NA
#> resample_180  0.05 0.9999728 1.0000000     ns     -6.8464800       1.644854 NA
#> resample_181  0.05 0.9999721 1.0000000     ns     -6.7795725       1.644854 NA
#> resample_182  0.05 0.9999717 1.0000000     ns     -6.7370112       1.644854 NA
#> resample_183  0.05 0.9999710 1.0000000     ns     -6.6754388       1.644854 NA
#> resample_184  0.05 0.9999703 1.0000000     ns     -6.6151156       1.644854 NA
#> resample_185  0.05 0.9999675 1.0000000     ns     -6.3725585       1.644854 NA
#> resample_186  0.05 0.9999659 1.0000000     ns     -6.2518340       1.644854 NA
#> resample_187  0.05 0.9999654 1.0000000     ns     -6.2080635       1.644854 NA
#> resample_188  0.05 0.9999650 1.0000000     ns     -6.1827574       1.644854 NA
#> resample_189  0.05 0.9999642 1.0000000     ns     -6.1179897       1.644854 NA
#> resample_190  0.05 0.9999637 1.0000000     ns     -6.0822015       1.644854 NA
#> resample_191  0.05 0.9999630 1.0000000     ns     -6.0368095       1.644854 NA
#> resample_192  0.05 0.9999624 1.0000000     ns     -5.9962754       1.644854 NA
#> resample_193  0.05 0.9999534 1.0000000     ns     -5.4291079       1.644854 NA
#> resample_194  0.05 0.9999499 0.9999999     ns     -5.2390185       1.644854 NA
#> resample_195  0.05 0.9999455 0.9999997     ns     -5.0210135       1.644854 NA
#> resample_196  0.05 0.9999401 0.9999991     ns     -4.7704244       1.644854 NA
#> resample_197  0.05 0.9999296 0.9999931     ns     -4.3477811       1.644854 NA
#> resample_198  0.05 0.9999273 0.9999899     ns     -4.2636530       1.644854 NA
#> resample_199  0.05 0.9999010 0.9997211     ns     -3.4513365       1.644854 NA
#> resample_200  0.05 0.9998529 0.9921155     ns     -2.4142191       1.644854 NA
#>              CI_lower CI_upper    N           AVG          MED       MIN
#> resample_1         NA       NA 5000 -1.199237e-03 -0.001746917 -5.339639
#> resample_2         NA       NA 5000 -1.180961e-03 -0.001743506 -5.287884
#> resample_3         NA       NA 5000 -1.056454e-03 -0.001740522 -4.702157
#> resample_4         NA       NA 5000 -1.030421e-03 -0.001739585 -4.608625
#> resample_5         NA       NA 5000 -1.019583e-03 -0.001737876 -4.589538
#> resample_6         NA       NA 5000 -1.002567e-03 -0.001735504 -4.541207
#> resample_7         NA       NA 5000 -9.855318e-04 -0.001730487 -4.491477
#> resample_8         NA       NA 5000 -9.645432e-04 -0.001728383 -4.425886
#> resample_9         NA       NA 5000 -9.561510e-04 -0.001725680 -4.418752
#> resample_10        NA       NA 5000 -9.347160e-04 -0.001724486 -4.345208
#> resample_11        NA       NA 5000 -9.239521e-04 -0.001718344 -4.328513
#> resample_12        NA       NA 5000 -9.132693e-04 -0.001716193 -4.309326
#> resample_13        NA       NA 5000 -9.004575e-04 -0.001715437 -4.283795
#> resample_14        NA       NA 5000 -8.915510e-04 -0.001712890 -4.282030
#> resample_15        NA       NA 5000 -8.839186e-04 -0.001712518 -4.280437
#> resample_16        NA       NA 5000 -8.751149e-04 -0.001710912 -4.273743
#> resample_17        NA       NA 5000 -8.563293e-04 -0.001704195 -4.220920
#> resample_18        NA       NA 5000 -8.477086e-04 -0.001703191 -4.210686
#> resample_19        NA       NA 5000 -8.406293e-04 -0.001701940 -4.210024
#> resample_20        NA       NA 5000 -8.267468e-04 -0.001700468 -4.176450
#> resample_21        NA       NA 5000 -8.181922e-04 -0.001698916 -4.167878
#> resample_22        NA       NA 5000 -8.078075e-04 -0.001698274 -4.150007
#> resample_23        NA       NA 5000 -7.999705e-04 -0.001697654 -4.147907
#> resample_24        NA       NA 5000 -7.877442e-04 -0.001694535 -4.124231
#> resample_25        NA       NA 5000 -7.771480e-04 -0.001693288 -4.108253
#> resample_26        NA       NA 5000 -7.654943e-04 -0.001693122 -4.083190
#> resample_27        NA       NA 5000 -7.576177e-04 -0.001688223 -4.079785
#> resample_28        NA       NA 5000 -7.499488e-04 -0.001688034 -4.077277
#> resample_29        NA       NA 5000 -7.422995e-04 -0.001687487 -4.073478
#> resample_30        NA       NA 5000 -7.344522e-04 -0.001685377 -4.068973
#> resample_31        NA       NA 5000 -7.266481e-04 -0.001684423 -4.066269
#> resample_32        NA       NA 5000 -7.189072e-04 -0.001680015 -4.062316
#> resample_33        NA       NA 5000 -7.104020e-04 -0.001676304 -4.056479
#> resample_34        NA       NA 5000 -6.997371e-04 -0.001674515 -4.039766
#> resample_35        NA       NA 5000 -6.913557e-04 -0.001673473 -4.037651
#> resample_36        NA       NA 5000 -6.839905e-04 -0.001670031 -4.035776
#> resample_37        NA       NA 5000 -6.756460e-04 -0.001668594 -4.032000
#> resample_38        NA       NA 5000 -6.676994e-04 -0.001663825 -4.028427
#> resample_39        NA       NA 5000 -6.596716e-04 -0.001660392 -4.023787
#> resample_40        NA       NA 5000 -6.483806e-04 -0.001650246 -4.004583
#> resample_41        NA       NA 5000 -6.410268e-04 -0.001648426 -4.001214
#> resample_42        NA       NA 5000 -6.328242e-04 -0.001644579 -3.997698
#> resample_43        NA       NA 5000 -6.239892e-04 -0.001642286 -3.990283
#> resample_44        NA       NA 5000 -6.155911e-04 -0.001640811 -3.989083
#> resample_45        NA       NA 5000 -6.042670e-04 -0.001635816 -3.968141
#> resample_46        NA       NA 5000 -5.939283e-04 -0.001634608 -3.955319
#> resample_47        NA       NA 5000 -5.858651e-04 -0.001634038 -3.955113
#> resample_48        NA       NA 5000 -5.752067e-04 -0.001630752 -3.939586
#> resample_49        NA       NA 5000 -5.669758e-04 -0.001627185 -3.933637
#> resample_50        NA       NA 5000 -5.590247e-04 -0.001625811 -3.929024
#> resample_51        NA       NA 5000 -5.516765e-04 -0.001623479 -3.927118
#> resample_52        NA       NA 5000 -5.444372e-04 -0.001622063 -3.927117
#> resample_53        NA       NA 5000 -5.352975e-04 -0.001620875 -3.920254
#> resample_54        NA       NA 5000 -5.277747e-04 -0.001620427 -3.920009
#> resample_55        NA       NA 5000 -5.200596e-04 -0.001617866 -3.917952
#> resample_56        NA       NA 5000 -5.124123e-04 -0.001617381 -3.916937
#> resample_57        NA       NA 5000 -5.013250e-04 -0.001610533 -3.899840
#> resample_58        NA       NA 5000 -4.906629e-04 -0.001608846 -3.881852
#> resample_59        NA       NA 5000 -4.828011e-04 -0.001607131 -3.874809
#> resample_60        NA       NA 5000 -4.746710e-04 -0.001605020 -3.871397
#> resample_61        NA       NA 5000 -4.667408e-04 -0.001601585 -3.865413
#> resample_62        NA       NA 5000 -4.584714e-04 -0.001599551 -3.865099
#> resample_63        NA       NA 5000 -4.508642e-04 -0.001596200 -3.862207
#> resample_64        NA       NA 5000 -4.430355e-04 -0.001591517 -3.857484
#> resample_65        NA       NA 5000 -4.335518e-04 -0.001590370 -3.854791
#> resample_66        NA       NA 5000 -4.251394e-04 -0.001585100 -3.852338
#> resample_67        NA       NA 5000 -4.171085e-04 -0.001580646 -3.849123
#> resample_68        NA       NA 5000 -4.092775e-04 -0.001578021 -3.847579
#> resample_69        NA       NA 5000 -4.013639e-04 -0.001574843 -3.845277
#> resample_70        NA       NA 5000 -3.940111e-04 -0.001574484 -3.844185
#> resample_71        NA       NA 5000 -3.851901e-04 -0.001572993 -3.841991
#> resample_72        NA       NA 5000 -3.766421e-04 -0.001567502 -3.835498
#> resample_73        NA       NA 5000 -3.692018e-04 -0.001564550 -3.835338
#> resample_74        NA       NA 5000 -3.600934e-04 -0.001560487 -3.832666
#> resample_75        NA       NA 5000 -3.527449e-04 -0.001557283 -3.831857
#> resample_76        NA       NA 5000 -3.453733e-04 -0.001557118 -3.830687
#> resample_77        NA       NA 5000 -3.378971e-04 -0.001554189 -3.829363
#> resample_78        NA       NA 5000 -3.301632e-04 -0.001553668 -3.829153
#> resample_79        NA       NA 5000 -3.206373e-04 -0.001552850 -3.815205
#> resample_80        NA       NA 5000 -3.136505e-04 -0.001552086 -3.815023
#> resample_81        NA       NA 5000 -3.052618e-04 -0.001550587 -3.810992
#> resample_82        NA       NA 5000 -2.976946e-04 -0.001548485 -3.809532
#> resample_83        NA       NA 5000 -2.906554e-04 -0.001544094 -3.807995
#> resample_84        NA       NA 5000 -2.830750e-04 -0.001543072 -3.807751
#> resample_85        NA       NA 5000 -2.757157e-04 -0.001541031 -3.807136
#> resample_86        NA       NA 5000 -2.682180e-04 -0.001535346 -3.806807
#> resample_87        NA       NA 5000 -2.600063e-04 -0.001533630 -3.802386
#> resample_88        NA       NA 5000 -2.524995e-04 -0.001532205 -3.802348
#> resample_89        NA       NA 5000 -2.454468e-04 -0.001531020 -3.801098
#> resample_90        NA       NA 5000 -2.359349e-04 -0.001530132 -3.799154
#> resample_91        NA       NA 5000 -2.277703e-04 -0.001529275 -3.797727
#> resample_92        NA       NA 5000 -2.195969e-04 -0.001528476 -3.796379
#> resample_93        NA       NA 5000 -2.121541e-04 -0.001525439 -3.794229
#> resample_94        NA       NA 5000 -2.017619e-04 -0.001522916 -3.779512
#> resample_95        NA       NA 5000 -1.931494e-04 -0.001520232 -3.772302
#> resample_96        NA       NA 5000 -1.828645e-04 -0.001514947 -3.764507
#> resample_97        NA       NA 5000 -1.746833e-04 -0.001512817 -3.763452
#> resample_98        NA       NA 5000 -1.658725e-04 -0.001508281 -3.761226
#> resample_99        NA       NA 5000 -1.586918e-04 -0.001501603 -3.761198
#> resample_100       NA       NA 5000 -1.515093e-04 -0.001499325 -3.760663
#> resample_101       NA       NA 5000 -1.432530e-04 -0.001495488 -3.757176
#> resample_102       NA       NA 5000 -1.348507e-04 -0.001492029 -3.750920
#> resample_103       NA       NA 5000 -1.263095e-04 -0.001489979 -3.743326
#> resample_104       NA       NA 5000 -1.181163e-04 -0.001487774 -3.735419
#> resample_105       NA       NA 5000 -1.087384e-04 -0.001485401 -3.727975
#> resample_106       NA       NA 5000 -1.016559e-04 -0.001482331 -3.727017
#> resample_107       NA       NA 5000 -9.312192e-05 -0.001480667 -3.725370
#> resample_108       NA       NA 5000 -8.600641e-05 -0.001477653 -3.725050
#> resample_109       NA       NA 5000 -7.844322e-05 -0.001476636 -3.724896
#> resample_110       NA       NA 5000 -7.097830e-05 -0.001473341 -3.723011
#> resample_111       NA       NA 5000 -6.297463e-05 -0.001472063 -3.721701
#> resample_112       NA       NA 5000 -5.514671e-05 -0.001468972 -3.720658
#> resample_113       NA       NA 5000 -4.855959e-05 -0.001465304 -3.718167
#> resample_114       NA       NA 5000 -3.905504e-05 -0.001464507 -3.707864
#> resample_115       NA       NA 5000 -3.061712e-05 -0.001463374 -3.707690
#> resample_116       NA       NA 5000 -2.216121e-05 -0.001460367 -3.707623
#> resample_117       NA       NA 5000 -1.237600e-05 -0.001458646 -3.701323
#> resample_118       NA       NA 5000 -4.475145e-06 -0.001456935 -3.700625
#> resample_119       NA       NA 5000  2.975758e-06 -0.001453581 -3.698825
#> resample_120       NA       NA 5000  1.170919e-05 -0.001452069 -3.694647
#> resample_121       NA       NA 5000  1.906762e-05 -0.001450732 -3.693574
#> resample_122       NA       NA 5000  2.656595e-05 -0.001446487 -3.692502
#> resample_123       NA       NA 5000  3.539473e-05 -0.001445870 -3.689411
#> resample_124       NA       NA 5000  4.274467e-05 -0.001442429 -3.688343
#> resample_125       NA       NA 5000  4.979478e-05 -0.001442095 -3.687853
#> resample_126       NA       NA 5000  5.879262e-05 -0.001437804 -3.687809
#> resample_127       NA       NA 5000  6.650925e-05 -0.001435442 -3.687274
#> resample_128       NA       NA 5000  7.527570e-05 -0.001433941 -3.684233
#> resample_129       NA       NA 5000  8.311769e-05 -0.001429819 -3.680632
#> resample_130       NA       NA 5000  9.160267e-05 -0.001428407 -3.675784
#> resample_131       NA       NA 5000  1.006054e-04 -0.001426085 -3.674472
#> resample_132       NA       NA 5000  1.074369e-04 -0.001425687 -3.674144
#> resample_133       NA       NA 5000  1.153491e-04 -0.001424151 -3.671407
#> resample_134       NA       NA 5000  1.232557e-04 -0.001421322 -3.669956
#> resample_135       NA       NA 5000  1.316349e-04 -0.001419725 -3.666922
#> resample_136       NA       NA 5000  1.390481e-04 -0.001418910 -3.666314
#> resample_137       NA       NA 5000  1.466036e-04 -0.001414369 -3.665150
#> resample_138       NA       NA 5000  1.544035e-04 -0.001409314 -3.663860
#> resample_139       NA       NA 5000  1.620198e-04 -0.001407840 -3.662064
#> resample_140       NA       NA 5000  1.714493e-04 -0.001405144 -3.657497
#> resample_141       NA       NA 5000  1.805906e-04 -0.001403780 -3.654982
#> resample_142       NA       NA 5000  1.888562e-04 -0.001401650 -3.652887
#> resample_143       NA       NA 5000  1.972790e-04 -0.001398937 -3.647896
#> resample_144       NA       NA 5000  2.059557e-04 -0.001397459 -3.643731
#> resample_145       NA       NA 5000  2.135996e-04 -0.001396906 -3.643651
#> resample_146       NA       NA 5000  2.222961e-04 -0.001395503 -3.642542
#> resample_147       NA       NA 5000  2.338695e-04 -0.001391910 -3.642248
#> resample_148       NA       NA 5000  2.423883e-04 -0.001390404 -3.640131
#> resample_149       NA       NA 5000  2.501378e-04 -0.001389128 -3.637483
#> resample_150       NA       NA 5000  2.576830e-04 -0.001387000 -3.637109
#> resample_151       NA       NA 5000  2.673098e-04 -0.001386395 -3.633214
#> resample_152       NA       NA 5000  2.748463e-04 -0.001384911 -3.631911
#> resample_153       NA       NA 5000  2.856533e-04 -0.001381920 -3.628634
#> resample_154       NA       NA 5000  2.943068e-04 -0.001381289 -3.628351
#> resample_155       NA       NA 5000  3.038233e-04 -0.001377866 -3.627833
#> resample_156       NA       NA 5000  3.120808e-04 -0.001376715 -3.627789
#> resample_157       NA       NA 5000  3.212119e-04 -0.001375034 -3.624512
#> resample_158       NA       NA 5000  3.290445e-04 -0.001374564 -3.621615
#> resample_159       NA       NA 5000  3.371698e-04 -0.001372543 -3.621226
#> resample_160       NA       NA 5000  3.460314e-04 -0.001370680 -3.620233
#> resample_161       NA       NA 5000  3.545430e-04 -0.001367288 -3.618350
#> resample_162       NA       NA 5000  3.626477e-04 -0.001365743 -3.616621
#> resample_163       NA       NA 5000  3.719128e-04 -0.001363444 -3.614819
#> resample_164       NA       NA 5000  3.799707e-04 -0.001362706 -3.612490
#> resample_165       NA       NA 5000  3.894725e-04 -0.001360507 -3.612296
#> resample_166       NA       NA 5000  3.963881e-04 -0.001355583 -3.612086
#> resample_167       NA       NA 5000  4.037936e-04 -0.001351761 -3.609975
#> resample_168       NA       NA 5000  4.120486e-04 -0.001350262 -3.608712
#> resample_169       NA       NA 5000  4.184699e-04 -0.001346873 -3.608660
#> resample_170       NA       NA 5000  4.287793e-04 -0.001345719 -3.608249
#> resample_171       NA       NA 5000  4.374670e-04 -0.001344683 -3.605063
#> resample_172       NA       NA 5000  4.448791e-04 -0.001344246 -3.603769
#> resample_173       NA       NA 5000  4.544997e-04 -0.001339979 -3.603745
#> resample_174       NA       NA 5000  4.631786e-04 -0.001335687 -3.603540
#> resample_175       NA       NA 5000  4.710573e-04 -0.001331332 -3.602696
#> resample_176       NA       NA 5000  4.795142e-04 -0.001327076 -3.600904
#> resample_177       NA       NA 5000  4.872901e-04 -0.001324926 -3.598943
#> resample_178       NA       NA 5000  4.966804e-04 -0.001324120 -3.596994
#> resample_179       NA       NA 5000  5.059085e-04 -0.001323569 -3.596608
#> resample_180       NA       NA 5000  5.174176e-04 -0.001318850 -3.592841
#> resample_181       NA       NA 5000  5.257188e-04 -0.001317074 -3.590578
#> resample_182       NA       NA 5000  5.338898e-04 -0.001313950 -3.589893
#> resample_183       NA       NA 5000  5.427430e-04 -0.001309357 -3.588360
#> resample_184       NA       NA 5000  5.513832e-04 -0.001306051 -3.586814
#> resample_185       NA       NA 5000  5.659569e-04 -0.001305495 -3.586183
#> resample_186       NA       NA 5000  5.762235e-04 -0.001300308 -3.584759
#> resample_187       NA       NA 5000  5.840682e-04 -0.001298727 -3.581442
#> resample_188       NA       NA 5000  5.916703e-04 -0.001298392 -3.581041
#> resample_189       NA       NA 5000  6.004476e-04 -0.001296476 -3.580128
#> resample_190       NA       NA 5000  6.082401e-04 -0.001292676 -3.579091
#> resample_191       NA       NA 5000  6.159831e-04 -0.001291121 -3.575704
#> resample_192       NA       NA 5000  6.243354e-04 -0.001289051 -3.573042
#> resample_193       NA       NA 5000  6.475745e-04 -0.001282788 -3.572062
#> resample_194       NA       NA 5000  6.598677e-04 -0.001280618 -3.570103
#> resample_195       NA       NA 5000  6.730160e-04 -0.001276494 -3.567820
#> resample_196       NA       NA 5000  6.871539e-04 -0.001275460 -3.566900
#> resample_197       NA       NA 5000  7.067193e-04 -0.001273583 -3.565921
#> resample_198       NA       NA 5000  7.168095e-04 -0.001272958 -3.564643
#> resample_199       NA       NA 5000  7.483611e-04 -0.001271878 -3.563582
#> resample_200       NA       NA 5000  7.919239e-04 -0.001268941 -3.562775
#>                   MAX        SD
#> resample_1   3.532265 1.0012059
#> resample_2   3.533722 1.0011504
#> resample_3   3.534160 1.0005659
#> resample_4   3.534343 1.0004807
#> resample_5   3.534606 1.0004607
#> resample_6   3.536013 1.0004163
#> resample_7   3.536026 1.0003719
#> resample_8   3.536708 1.0003130
#> resample_9   3.537325 1.0003059
#> resample_10  3.537701 1.0002406
#> resample_11  3.542142 1.0002290
#> resample_12  3.542353 1.0002107
#> resample_13  3.542605 1.0001842
#> resample_14  3.547840 1.0001847
#> resample_15  3.548945 1.0001833
#> resample_16  3.549228 1.0001780
#> resample_17  3.550101 1.0001308
#> resample_18  3.550267 1.0001220
#> resample_19  3.550916 1.0001214
#> resample_20  3.551506 1.0000930
#> resample_21  3.551640 1.0000849
#> resample_22  3.551713 1.0000697
#> resample_23  3.553910 1.0000672
#> resample_24  3.556550 1.0000494
#> resample_25  3.556967 1.0000350
#> resample_26  3.557575 1.0000143
#> resample_27  3.557753 1.0000116
#> resample_28  3.559957 1.0000107
#> resample_29  3.561713 1.0000077
#> resample_30  3.561932 1.0000044
#> resample_31  3.562437 1.0000004
#> resample_32  3.562725 0.9999970
#> resample_33  3.564624 0.9999933
#> resample_34  3.566401 0.9999802
#> resample_35  3.569961 0.9999804
#> resample_36  3.571166 0.9999782
#> resample_37  3.571685 0.9999743
#> resample_38  3.572697 0.9999714
#> resample_39  3.575345 0.9999711
#> resample_40  3.577162 0.9999558
#> resample_41  3.577903 0.9999528
#> resample_42  3.579043 0.9999501
#> resample_43  3.579578 0.9999435
#> resample_44  3.581528 0.9999388
#> resample_45  3.583458 0.9999245
#> resample_46  3.586945 0.9999158
#> resample_47  3.587866 0.9999201
#> resample_48  3.588949 0.9999096
#> resample_49  3.589337 0.9999073
#> resample_50  3.589918 0.9999039
#> resample_51  3.590616 0.9999027
#> resample_52  3.591495 0.9999029
#> resample_53  3.595614 0.9999003
#> resample_54  3.596912 0.9998997
#> resample_55  3.598600 0.9998988
#> resample_56  3.599231 0.9998987
#> resample_57  3.603651 0.9998885
#> resample_58  3.604178 0.9998745
#> resample_59  3.604209 0.9998691
#> resample_60  3.604494 0.9998629
#> resample_61  3.605579 0.9998593
#> resample_62  3.608577 0.9998591
#> resample_63  3.610418 0.9998576
#> resample_64  3.610898 0.9998533
#> resample_65  3.613702 0.9998464
#> resample_66  3.615369 0.9998432
#> resample_67  3.616844 0.9998407
#> resample_68  3.619244 0.9998405
#> resample_69  3.620297 0.9998413
#> resample_70  3.620590 0.9998398
#> resample_71  3.626649 0.9998430
#> resample_72  3.628571 0.9998395
#> resample_73  3.632271 0.9998424
#> resample_74  3.636804 0.9998426
#> resample_75  3.637524 0.9998417
#> resample_76  3.638179 0.9998396
#> resample_77  3.639766 0.9998395
#> resample_78  3.641782 0.9998405
#> resample_79  3.642386 0.9998293
#> resample_80  3.643045 0.9998306
#> resample_81  3.645305 0.9998307
#> resample_82  3.647813 0.9998336
#> resample_83  3.648848 0.9998333
#> resample_84  3.649571 0.9998332
#> resample_85  3.651394 0.9998338
#> resample_86  3.652160 0.9998338
#> resample_87  3.656134 0.9998331
#> resample_88  3.657682 0.9998351
#> resample_89  3.658426 0.9998347
#> resample_90  3.664307 0.9998384
#> resample_91  3.665790 0.9998369
#> resample_92  3.669785 0.9998385
#> resample_93  3.670907 0.9998373
#> resample_94  3.671358 0.9998267
#> resample_95  3.674161 0.9998234
#> resample_96  3.677748 0.9998187
#> resample_97  3.681549 0.9998217
#> resample_98  3.687539 0.9998215
#> resample_99  3.690134 0.9998223
#> resample_100 3.690551 0.9998237
#> resample_101 3.692214 0.9998239
#> resample_102 3.693299 0.9998191
#> resample_103 3.695537 0.9998143
#> resample_104 3.695600 0.9998084
#> resample_105 3.695997 0.9998024
#> resample_106 3.696300 0.9998017
#> resample_107 3.699728 0.9998039
#> resample_108 3.700158 0.9998045
#> resample_109 3.702752 0.9998076
#> resample_110 3.703228 0.9998063
#> resample_111 3.706334 0.9998089
#> resample_112 3.706727 0.9998079
#> resample_113 3.706761 0.9998061
#> resample_114 3.707036 0.9998005
#> resample_115 3.709133 0.9998043
#> resample_116 3.715700 0.9998108
#> resample_117 3.724249 0.9998133
#> resample_118 3.729282 0.9998174
#> resample_119 3.729920 0.9998165
#> resample_120 3.731063 0.9998114
#> resample_121 3.734342 0.9998136
#> resample_122 3.737682 0.9998149
#> resample_123 3.740787 0.9998136
#> resample_124 3.742260 0.9998146
#> resample_125 3.743013 0.9998143
#> resample_126 3.746575 0.9998159
#> resample_127 3.750588 0.9998190
#> resample_128 3.756782 0.9998220
#> resample_129 3.756960 0.9998201
#> resample_130 3.758178 0.9998163
#> resample_131 3.763408 0.9998176
#> resample_132 3.763837 0.9998181
#> resample_133 3.766847 0.9998182
#> resample_134 3.768870 0.9998183
#> resample_135 3.772150 0.9998186
#> resample_136 3.774238 0.9998188
#> resample_137 3.778209 0.9998206
#> resample_138 3.781716 0.9998232
#> resample_139 3.781742 0.9998236
#> resample_140 3.791369 0.9998276
#> resample_141 3.794788 0.9998269
#> resample_142 3.797615 0.9998279
#> resample_143 3.798256 0.9998263
#> resample_144 3.801254 0.9998262
#> resample_145 3.804643 0.9998285
#> resample_146 3.811467 0.9998339
#> resample_147 3.832832 0.9998485
#> resample_148 3.835902 0.9998503
#> resample_149 3.836128 0.9998486
#> resample_150 3.837368 0.9998496
#> resample_151 3.850100 0.9998566
#> resample_152 3.850339 0.9998570
#> resample_153 3.865182 0.9998640
#> resample_154 3.874152 0.9998715
#> resample_155 3.884615 0.9998779
#> resample_156 3.891571 0.9998831
#> resample_157 3.898250 0.9998860
#> resample_158 3.898648 0.9998862
#> resample_159 3.904620 0.9998899
#> resample_160 3.908549 0.9998958
#> resample_161 3.916502 0.9998991
#> resample_162 3.917779 0.9999021
#> resample_163 3.926112 0.9999075
#> resample_164 3.926603 0.9999095
#> resample_165 3.933528 0.9999107
#> resample_166 3.934811 0.9999138
#> resample_167 3.936950 0.9999145
#> resample_168 3.941538 0.9999161
#> resample_169 3.941853 0.9999151
#> resample_170 3.952013 0.9999230
#> resample_171 3.954234 0.9999213
#> resample_172 3.954644 0.9999203
#> resample_173 3.965079 0.9999313
#> resample_174 3.972897 0.9999375
#> resample_175 3.978307 0.9999412
#> resample_176 3.981288 0.9999422
#> resample_177 3.982624 0.9999424
#> resample_178 3.993590 0.9999487
#> resample_179 4.002394 0.9999541
#> resample_180 4.019563 0.9999664
#> resample_181 4.026229 0.9999703
#> resample_182 4.031483 0.9999745
#> resample_183 4.036868 0.9999803
#> resample_184 4.042782 0.9999861
#> resample_185 4.080379 1.0000170
#> resample_186 4.095388 1.0000311
#> resample_187 4.096718 1.0000300
#> resample_188 4.099363 1.0000325
#> resample_189 4.106527 1.0000387
#> resample_190 4.109845 1.0000409
#> resample_191 4.110795 1.0000416
#> resample_192 4.112246 1.0000420
#> resample_193 4.194489 1.0001092
#> resample_194 4.218670 1.0001287
#> resample_195 4.247214 1.0001518
#> resample_196 4.281704 1.0001813
#> resample_197 4.341693 1.0002328
#> resample_198 4.352137 1.0002447
#> resample_199 4.475621 1.0003545
#> resample_200 4.651232 1.0005177
```
