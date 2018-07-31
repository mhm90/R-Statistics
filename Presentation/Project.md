<style>
body {
    overflow: scroll;
}
</style>
<script>
document.onreadystatechange = function () {
  if (document.readyState == "complete") {
    Reveal.addEventListener( 'slidechanged', function( event ) {
    document.body.scrollTop = document.documentElement.scrollTop = 0;
} );
  }
}

</script>

Statistics R Project
========================================================
id: cover
author: Mohammad Hossein Mahsuli
date: July 2018
autosize: true



Outline
========================================================
id: outline
* [__Basics__](#/basics)
  + Data Set Info
  + Data Clearing
  + PCA
* [__Regression__](#/reg)
  + Simple Linear Regression
  + Multiple Linear Regression
  + Subset Selectiong (Validation Set)
  + Ridge & Lasso Regression
  

Outline
========================================================
* [__Classification__](#/classification)
  + Logestic Regression
  + KNN
  + LDA
  + QDA
  + SVM
* __Trees__
* __Clustering__
  + K-Means
  + Hierarchial Clustering

Basics - Dataset
========================================================
id:basics

### Dataset: [Absenteeism at work](https://archive.ics.uci.edu/ml/datasets/Absenteeism+at+work)

The database was created with records of absenteeism at work from July 2007 to July 2010 at a courier company in Brazil.
It is used in academic research at the Universidade Nove de Julho - Postgraduate Program in Informatics and Knowledge Management.

### Features
1. Individual identification (ID)
2. Reason for absence (ICD): Absences attested by the International Code of Diseases (ICD) stratified into 21 categories (I to XXI) as follows:
  * I Certain infectious and parasitic diseases  
  * II Neoplasms  
  * III Diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism  
  * IV Endocrine, nutritional and metabolic diseases  
  * V Mental and behavioural disorders  
  * VI Diseases of the nervous system  
  * VII Diseases of the eye and adnexa  
  * VIII Diseases of the ear and mastoid process  
  * IX Diseases of the circulatory system  
  * X Diseases of the respiratory system  
  * XI Diseases of the digestive system  
  * XII Diseases of the skin and subcutaneous tissue  
  * XIII Diseases of the musculoskeletal system and connective tissue  
  * XIV Diseases of the genitourinary system  
  * XV Pregnancy, childbirth and the puerperium  
  * XVI Certain conditions originating in the perinatal period
  * XVII Congenital malformations, deformations and chromosomal abnormalities  
  * XVIII Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified  
  * XIX Injury, poisoning and certain other consequences of external causes  
  * XX External causes of morbidity and mortality  
  * XXI Factors influencing health status and contact with health services.
And 7 categories without ICD:
  * Patient follow-up (22)
  * Medical consultation (23)
  * Blood donation (24)
  * Laboratory examination (25)
  * Unjustified absence (26)
  * Physiotherapy (27)
  * Dental consultation (28)
3. Month of absence
4. Day of the week (Monday (2), Tuesday (3), Wednesday (4), Thursday (5), Friday (6))
5. Seasons (summer (1), autumn (2), winter (3), spring (4))
6. Transportation expense
7. Distance from Residence to Work (kilometers)
8. Service time
9. Age
10. Work load Average/day 
11. Hit target
12. Disciplinary failure (yes=1; no=0)
13. Education (high school (1), graduate (2), postgraduate (3), master and doctor (4))
14. Son (number of children)
15. Social drinker (yes=1; no=0)
16. Social smoker (yes=1; no=0)
17. Pet (number of pet)
18. Weight
19. Height
20. Body mass index
21. Absenteeism time in hours (target)

Basics - Data Info
========================================================
<img src="Project-figure/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-1-2.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="100%" angle=90 style="display: block; margin: auto;" />
* Number of records

```r
NROW(data)
```

```
[1] 740
```
* Number of participants

```r
length(unique(data$ID))
```

```
[1] 36
```
* It means that there is too many record for any person
* But,
* Data has same feature value for the same person's records on these features:
  + Transportation expense
  + Distance from Residence to Work
  + Service time
  + Age
  + Education
  + Son
  + Social drinker
  + Social smoker
  + Pet
  + Weight
  + Height
  + Body mass index
* This makes feature dependent on eachother and some difficulties on matrice operations


Basics - Data Clearing
========================================================
id:basics-clearing
source: ../Src/Basics.R

## Categorical Features

Dataset has following categorical features:
* ID
* Reason for absence
* Month of absence
* Day of the week
* Season
* Education

But Education value somehow is showing the score of that person in education and so we don't consider it as categorical feature in our models.

For other categorical features we use `factor()` function to build new features from them in order to fit a better model, and finally removing original features

## Preprocess

Each statistical method (Regression, Classification, Clustering, ...) has some tecniques which makes us to have some preprocess on data in order to change raw data to a suitable data for fitting a model. We perform a suitable preprocess at the beggining of each method

It is always better to have less redundant features and avoiding to have a model with many estimators. There is two features in our dataset which can be exactly evaluated by other features:
* _Season_ - can be evaluated by _Month_
* _Body mass index_ - can be evaluated by _Weigth_ and _Height_

We remove these features to make our models more responsive

Regression
========================================================
id:reg
source: ../Src/Regression.R

## Single Linear Regression

### Categorical Data
* Wrong Way:

```r
regFitWrong = lm(`Absenteeism time in hours` ~ `Reason for absence`, data = data)
summary(regFitWrong)
```

```

Call:
lm(formula = `Absenteeism time in hours` ~ `Reason for absence`, 
    data = data)

Residuals:
    Min      1Q  Median      3Q     Max 
-12.183  -3.889  -2.521   0.472 111.375 

Coefficients:
                     Estimate Std. Error t value Pr(>|t|)    
(Intercept)          12.18285    1.20252  10.131  < 2e-16 ***
`Reason for absence` -0.27365    0.05731  -4.775 2.17e-06 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 13.14 on 738 degrees of freedom
Multiple R-squared:  0.02997,	Adjusted R-squared:  0.02865 
F-statistic:  22.8 on 1 and 738 DF,  p-value: 2.168e-06
```

* Right Way

```r
regFit = lm(`Absenteeism time in hours` ~ `Reason.f.`, data = data)
summary(regFit)
```

```

Call:
lm(formula = `Absenteeism time in hours` ~ Reason.f., data = data)

Residuals:
    Min      1Q  Median      3Q     Max 
-34.000  -2.333  -0.789   0.289 108.577 

Coefficients:
                               Estimate Std. Error t value Pr(>|t|)    
(Intercept)                   6.759e-14  1.837e+00   0.000 1.000000    
Reason.f.I                    1.137e+01  3.528e+00   3.225 0.001319 ** 
Reason.f.II                   2.400e+01  1.219e+01   1.970 0.049272 *  
Reason.f.III                  8.000e+00  1.219e+01   0.657 0.511694    
Reason.f.IV                   4.500e+00  8.714e+00   0.516 0.605713    
Reason.f.V                    6.333e+00  7.193e+00   0.880 0.378911    
Reason.f.VI                   2.137e+01  4.638e+00   4.608 4.81e-06 ***
Reason.f.VII                  1.000e+01  3.612e+00   2.768 0.005780 ** 
Reason.f.VIII                 5.333e+00  5.250e+00   1.016 0.310002    
Reason.f.IX                   4.200e+01  6.297e+00   6.670 5.14e-11 ***
Reason.f.X                    1.104e+01  3.030e+00   3.644 0.000288 ***
Reason.f.XI                   1.142e+01  2.993e+00   3.817 0.000147 ***
Reason.f.XII                  2.338e+01  4.638e+00   5.040 5.92e-07 ***
Reason.f.XIII                 1.531e+01  2.452e+00   6.243 7.36e-10 ***
Reason.f.XIV                  8.789e+00  3.318e+00   2.649 0.008259 ** 
Reason.f.XV                   8.000e+00  8.714e+00   0.918 0.358876    
Reason.f.XVI                  2.000e+00  7.193e+00   0.278 0.781064    
Reason.f.XVII                 8.000e+00  1.219e+01   0.657 0.511694    
Reason.f.XVIII                1.033e+01  3.207e+00   3.222 0.001330 ** 
Reason.f.XIX                  1.823e+01  2.646e+00   6.887 1.25e-11 ***
Reason.f.XXI                  5.833e+00  5.250e+00   1.111 0.266863    
Reason.f.patient.follow-up    7.711e+00  2.682e+00   2.875 0.004162 ** 
Reason.f.medical.consultation 2.846e+00  2.085e+00   1.365 0.172801    
Reason.f.blood.donation       8.000e+00  7.193e+00   1.112 0.266448    
Reason.f.laboratory.exam      3.484e+00  2.838e+00   1.227 0.220042    
Reason.f.unjustified.absence  7.273e+00  2.788e+00   2.609 0.009277 ** 
Reason.f.physiotherapy        2.275e+00  2.340e+00   0.972 0.331278    
Reason.f.dental.consultation  2.991e+00  2.161e+00   1.384 0.166766    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 12.05 on 712 degrees of freedom
Multiple R-squared:  0.2133,	Adjusted R-squared:  0.1835 
F-statistic: 7.151 on 27 and 712 DF,  p-value: < 2.2e-16
```

<img src="Project-figure/unnamed-chunk-6-1.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" width="100%" angle=90 style="display: block; margin: auto;" />

Note that the blue line is specifying only one of newly added predictors

Single Regression
========================================================
source: ../Src/Regression.R

## Single Linear Regression

<img src="Project-figure/unnamed-chunk-7-1.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-2.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-3.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-4.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-5.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-6.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-7.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-8.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-9.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-10.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-11.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-12.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-13.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-14.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-15.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-16.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-17.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-18.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-19.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-20.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-21.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-22.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-23.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-24.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-25.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-7-26.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="100%" angle=90 style="display: block; margin: auto;" />


Multiple Regression
========================================================
source: ../Src/Regression.R



### Regression Using Full Feature space

```r
fitFull = lm(`Absenteeism time in hours` ~ . , data = data)
summary(fitFull)
```

```

Call:
lm(formula = `Absenteeism time in hours` ~ ., data = data)

Residuals:
    Min      1Q  Median      3Q     Max 
-35.259  -3.707  -0.438   1.776 100.007 

Coefficients: (11 not defined because of singularities)
                                    Estimate Std. Error t value Pr(>|t|)  
(Intercept)                        1.902e+02  4.126e+02   0.461   0.6450  
`Transportation expense`          -2.562e-02  6.528e-02  -0.392   0.6949  
`Distance from Residence to Work` -2.982e-01  2.952e-01  -1.010   0.3128  
`Service time`                     7.659e-01  2.606e+00   0.294   0.7689  
Age                                8.239e-01  1.317e+00   0.626   0.5318  
`Work load Average/day`           -9.455e-06  1.476e-05  -0.640   0.5221  
`Hit target`                       1.417e-01  2.094e-01   0.677   0.4987  
`Disciplinary failure`             3.794e+00  1.701e+01   0.223   0.8235  
Education                          2.413e+00  7.899e+00   0.306   0.7601  
Son                               -7.267e+00  1.590e+01  -0.457   0.6478  
`Social drinker`                   1.265e+01  2.931e+01   0.432   0.6662  
`Social smoker`                    7.510e+00  1.278e+01   0.588   0.5569  
Pet                                4.619e+00  7.955e+00   0.581   0.5617  
Weight                            -7.225e-01  8.944e-01  -0.808   0.4195  
Height                            -1.027e+00  2.767e+00  -0.371   0.7107  
ID.f2                             -2.982e+01  6.450e+01  -0.462   0.6440  
ID.f3                             -3.987e+00  2.731e+01  -0.146   0.8840  
ID.f4                             -3.548e+01  8.840e+01  -0.401   0.6883  
ID.f5                              5.686e+00  4.834e+01   0.118   0.9064  
ID.f6                             -2.849e-01  2.462e+01  -0.012   0.9908  
ID.f7                             -2.097e+01  1.412e+01  -1.485   0.1381  
ID.f8                              1.077e+01  3.598e+01   0.299   0.7647  
ID.f9                              1.722e+00  3.759e+01   0.046   0.9635  
ID.f10                             5.957e+00  5.833e+01   0.102   0.9187  
ID.f11                             1.855e+01  2.240e+01   0.828   0.4080  
ID.f12                            -3.160e+01  7.376e+01  -0.428   0.6685  
ID.f13                             1.494e+01  3.483e+01   0.429   0.6681  
ID.f14                             4.609e+01  7.476e+01   0.616   0.5378  
ID.f15                            -7.284e+00  2.111e+01  -0.345   0.7301  
ID.f16                            -2.368e+01  4.179e+01  -0.567   0.5711  
ID.f17                            -1.157e+01  4.409e+01  -0.262   0.7931  
ID.f18                             2.833e+01  2.199e+01   1.288   0.1981  
ID.f19                            -1.023e+01  2.728e+01  -0.375   0.7077  
ID.f20                             1.693e+01  3.395e+01   0.499   0.6182  
ID.f21                             7.957e+00  1.312e+01   0.607   0.5444  
ID.f22                            -1.315e+01  1.352e+01  -0.973   0.3309  
ID.f23                            -3.622e+00  2.064e+01  -0.175   0.8607  
ID.f24                            -2.741e+01  2.052e+01  -1.336   0.1821  
ID.f25                             5.721e+00  8.225e+00   0.696   0.4870  
ID.f26                                    NA         NA      NA       NA  
ID.f27                                    NA         NA      NA       NA  
ID.f28                             3.756e-02  1.231e+01   0.003   0.9976  
ID.f29                                    NA         NA      NA       NA  
ID.f30                                    NA         NA      NA       NA  
ID.f31                                    NA         NA      NA       NA  
ID.f32                                    NA         NA      NA       NA  
ID.f33                                    NA         NA      NA       NA  
ID.f34                                    NA         NA      NA       NA  
ID.f35                                    NA         NA      NA       NA  
ID.f36                                    NA         NA      NA       NA  
Reason.f.I                         1.301e+01  1.736e+01   0.749   0.4538  
Reason.f.II                        2.795e+01  2.106e+01   1.327   0.1849  
Reason.f.III                       1.060e+01  2.092e+01   0.507   0.6126  
Reason.f.IV                        1.132e+01  1.928e+01   0.587   0.5574  
Reason.f.V                         9.072e+00  1.845e+01   0.492   0.6230  
Reason.f.VI                        1.868e+01  1.768e+01   1.057   0.2910  
Reason.f.VII                       1.379e+01  1.743e+01   0.791   0.4291  
Reason.f.VIII                      9.650e+00  1.786e+01   0.540   0.5892  
Reason.f.IX                        4.712e+01  1.831e+01   2.573   0.0103 *
Reason.f.X                         1.447e+01  1.727e+01   0.838   0.4024  
Reason.f.XI                        1.578e+01  1.728e+01   0.913   0.3614  
Reason.f.XII                       2.547e+01  1.765e+01   1.443   0.1494  
Reason.f.XIII                      1.923e+01  1.718e+01   1.119   0.2634  
Reason.f.XIV                       1.240e+01  1.734e+01   0.715   0.4749  
Reason.f.XV                        5.356e+00  1.932e+01   0.277   0.7817  
Reason.f.XVI                       5.081e+00  1.875e+01   0.271   0.7865  
Reason.f.XVII                      9.686e+00  2.119e+01   0.457   0.6478  
Reason.f.XVIII                     1.163e+01  1.732e+01   0.671   0.5023  
Reason.f.XIX                       2.199e+01  1.722e+01   1.277   0.2021  
Reason.f.XXI                       9.722e+00  1.785e+01   0.545   0.5861  
Reason.f.patient.follow-up         1.110e+01  1.725e+01   0.644   0.5200  
Reason.f.medical.consultation      6.720e+00  1.714e+01   0.392   0.6951  
Reason.f.blood.donation            9.674e+00  1.855e+01   0.522   0.6021  
Reason.f.laboratory.exam           6.208e+00  1.728e+01   0.359   0.7194  
Reason.f.unjustified.absence       9.862e+00  1.720e+01   0.573   0.5665  
Reason.f.physiotherapy             8.449e+00  1.721e+01   0.491   0.6237  
Reason.f.dental.consultation       6.477e+00  1.716e+01   0.378   0.7059  
Month.f1                          -4.767e+00  2.764e+00  -1.725   0.0851 .
Month.f2                          -3.574e+00  2.416e+00  -1.479   0.1395  
Month.f3                          -2.368e+00  2.276e+00  -1.040   0.2986  
Month.f4                          -2.032e+00  2.459e+00  -0.826   0.4091  
Month.f5                          -5.007e+00  2.453e+00  -2.041   0.0417 *
Month.f6                          -1.334e+00  2.536e+00  -0.526   0.5990  
Month.f7                          -4.155e-01  2.365e+00  -0.176   0.8606  
Month.f8                          -3.650e+00  2.580e+00  -1.415   0.1576  
Month.f9                          -2.202e+00  3.073e+00  -0.716   0.4740  
Month.f10                         -2.873e+00  2.572e+00  -1.117   0.2643  
Month.f11                         -1.950e+00  2.395e+00  -0.814   0.4159  
Month.f12                                 NA         NA      NA       NA  
WeekDay.f3                        -7.292e-01  1.427e+00  -0.511   0.6096  
WeekDay.f4                        -1.338e+00  1.408e+00  -0.951   0.3420  
WeekDay.f5                        -3.576e+00  1.500e+00  -2.384   0.0174 *
WeekDay.f6                        -1.931e+00  1.477e+00  -1.307   0.1915  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 11.83 on 658 degrees of freedom
Multiple R-squared:  0.2987,	Adjusted R-squared:  0.2124 
F-statistic:  3.46 on 81 and 658 DF,  p-value: < 2.2e-16
```

### Removing least significant feature

```r
fit1 = update(fitFull, . ~ . - ID.f , data = data)
summary(fit1)
```

```

Call:
lm(formula = `Absenteeism time in hours` ~ `Transportation expense` + 
    `Distance from Residence to Work` + `Service time` + Age + 
    `Work load Average/day` + `Hit target` + `Disciplinary failure` + 
    Education + Son + `Social drinker` + `Social smoker` + Pet + 
    Weight + Height + Reason.f. + Month.f + WeekDay.f, data = data)

Residuals:
    Min      1Q  Median      3Q     Max 
-32.972  -3.982  -0.631   1.763  98.993 

Coefficients: (1 not defined because of singularities)
                                    Estimate Std. Error t value Pr(>|t|)
(Intercept)                       -5.964e+01  2.773e+01  -2.151  0.03184
`Transportation expense`           1.236e-02  9.308e-03   1.328  0.18477
`Distance from Residence to Work` -4.435e-02  4.820e-02  -0.920  0.35783
`Service time`                     1.614e-01  1.898e-01   0.850  0.39536
Age                                1.723e-01  1.105e-01   1.559  0.11954
`Work load Average/day`           -1.364e-05  1.451e-05  -0.940  0.34732
`Hit target`                       1.000e-01  2.060e-01   0.486  0.62742
`Disciplinary failure`             1.063e+00  7.502e+00   0.142  0.88740
Education                         -1.694e+00  8.369e-01  -2.024  0.04339
Son                                9.662e-01  4.960e-01   1.948  0.05180
`Social drinker`                  -2.584e-01  1.462e+00  -0.177  0.85974
`Social smoker`                   -1.628e+00  1.997e+00  -0.815  0.41534
Pet                               -3.575e-01  4.736e-01  -0.755  0.45054
Weight                            -8.944e-02  5.286e-02  -1.692  0.09109
Height                             3.196e-01  1.050e-01   3.044  0.00243
Reason.f.I                         1.076e+01  7.922e+00   1.359  0.17468
Reason.f.II                        2.520e+01  1.426e+01   1.767  0.07764
Reason.f.III                       1.012e+01  1.407e+01   0.720  0.47191
Reason.f.IV                        5.376e+00  1.117e+01   0.481  0.63051
Reason.f.V                         7.108e+00  1.000e+01   0.711  0.47744
Reason.f.VI                        2.086e+01  8.391e+00   2.486  0.01317
Reason.f.VII                       1.184e+01  7.932e+00   1.492  0.13606
Reason.f.VIII                      8.359e+00  8.772e+00   0.953  0.34097
Reason.f.IX                        4.258e+01  9.472e+00   4.495 8.17e-06
Reason.f.X                         1.183e+01  7.700e+00   1.537  0.12476
Reason.f.XI                        1.339e+01  7.670e+00   1.746  0.08122
Reason.f.XII                       2.533e+01  8.302e+00   3.051  0.00237
Reason.f.XIII                      1.759e+01  7.405e+00   2.376  0.01778
Reason.f.XIV                       9.447e+00  7.687e+00   1.229  0.21955
Reason.f.XV                        4.957e+00  1.122e+01   0.442  0.65877
Reason.f.XVI                       3.558e+00  1.022e+01   0.348  0.72782
Reason.f.XVII                      9.097e+00  1.414e+01   0.643  0.52019
Reason.f.XVIII                     1.161e+01  7.619e+00   1.524  0.12797
Reason.f.XIX                       1.924e+01  7.415e+00   2.595  0.00966
Reason.f.XXI                       8.538e+00  8.838e+00   0.966  0.33436
Reason.f.patient.follow-up         9.698e+00  7.465e+00   1.299  0.19432
Reason.f.medical.consultation      4.839e+00  7.278e+00   0.665  0.50632
Reason.f.blood.donation            8.868e+00  1.006e+01   0.882  0.37824
Reason.f.laboratory.exam           5.196e+00  7.580e+00   0.685  0.49330
Reason.f.unjustified.absence       7.838e+00  7.543e+00   1.039  0.29918
Reason.f.physiotherapy             7.366e+00  7.486e+00   0.984  0.32544
Reason.f.dental.consultation       4.030e+00  7.300e+00   0.552  0.58110
Month.f1                          -4.363e+00  2.718e+00  -1.605  0.10892
Month.f2                          -3.988e+00  2.363e+00  -1.688  0.09191
Month.f3                          -2.156e+00  2.254e+00  -0.957  0.33912
Month.f4                          -1.572e+00  2.430e+00  -0.647  0.51785
Month.f5                          -4.133e+00  2.411e+00  -1.714  0.08693
Month.f6                          -1.650e+00  2.494e+00  -0.662  0.50840
Month.f7                          -4.975e-02  2.322e+00  -0.021  0.98291
Month.f8                          -3.529e+00  2.529e+00  -1.395  0.16336
Month.f9                          -2.067e+00  3.016e+00  -0.685  0.49329
Month.f10                         -2.367e+00  2.519e+00  -0.940  0.34760
Month.f11                         -1.852e+00  2.365e+00  -0.783  0.43372
Month.f12                                 NA         NA      NA       NA
WeekDay.f3                        -6.013e-01  1.394e+00  -0.431  0.66629
WeekDay.f4                        -1.444e+00  1.371e+00  -1.053  0.29263
WeekDay.f5                        -3.408e+00  1.463e+00  -2.329  0.02015
WeekDay.f6                        -2.471e+00  1.446e+00  -1.709  0.08783
                                     
(Intercept)                       *  
`Transportation expense`             
`Distance from Residence to Work`    
`Service time`                       
Age                                  
`Work load Average/day`              
`Hit target`                         
`Disciplinary failure`               
Education                         *  
Son                               .  
`Social drinker`                     
`Social smoker`                      
Pet                                  
Weight                            .  
Height                            ** 
Reason.f.I                           
Reason.f.II                       .  
Reason.f.III                         
Reason.f.IV                          
Reason.f.V                           
Reason.f.VI                       *  
Reason.f.VII                         
Reason.f.VIII                        
Reason.f.IX                       ***
Reason.f.X                           
Reason.f.XI                       .  
Reason.f.XII                      ** 
Reason.f.XIII                     *  
Reason.f.XIV                         
Reason.f.XV                          
Reason.f.XVI                         
Reason.f.XVII                        
Reason.f.XVIII                       
Reason.f.XIX                      ** 
Reason.f.XXI                         
Reason.f.patient.follow-up           
Reason.f.medical.consultation        
Reason.f.blood.donation              
Reason.f.laboratory.exam             
Reason.f.unjustified.absence         
Reason.f.physiotherapy               
Reason.f.dental.consultation         
Month.f1                             
Month.f2                          .  
Month.f3                             
Month.f4                             
Month.f5                          .  
Month.f6                             
Month.f7                             
Month.f8                             
Month.f9                             
Month.f10                            
Month.f11                            
Month.f12                            
WeekDay.f3                           
WeekDay.f4                           
WeekDay.f5                        *  
WeekDay.f6                        .  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 11.83 on 683 degrees of freedom
Multiple R-squared:  0.2719,	Adjusted R-squared:  0.2122 
F-statistic: 4.554 on 56 and 683 DF,  p-value: < 2.2e-16
```

### Removing again...

```r
fit2 = update(fit1, . ~ . - Reason.f. , data = data)
summary(fit2)
```

```

Call:
lm(formula = `Absenteeism time in hours` ~ `Transportation expense` + 
    `Distance from Residence to Work` + `Service time` + Age + 
    `Work load Average/day` + `Hit target` + `Disciplinary failure` + 
    Education + Son + `Social drinker` + `Social smoker` + Pet + 
    Weight + Height + Month.f + WeekDay.f, data = data)

Residuals:
    Min      1Q  Median      3Q     Max 
-17.167  -4.897  -1.930   1.277 107.208 

Coefficients:
                                    Estimate Std. Error t value Pr(>|t|)
(Intercept)                       -5.548e+01  2.867e+01  -1.935  0.05337
`Transportation expense`           1.347e-02  9.547e-03   1.411  0.15873
`Distance from Residence to Work` -6.593e-02  5.029e-02  -1.311  0.19028
`Service time`                     1.004e-01  1.995e-01   0.503  0.61509
Age                                2.167e-01  1.157e-01   1.872  0.06156
`Work load Average/day`            7.609e-06  1.494e-05   0.509  0.61057
`Hit target`                      -7.084e-02  2.140e-01  -0.331  0.74072
`Disciplinary failure`            -8.314e+00  2.224e+00  -3.738  0.00020
Education                         -7.922e-01  8.650e-01  -0.916  0.36007
Son                                9.173e-01  5.193e-01   1.766  0.07777
`Social drinker`                   9.150e-01  1.511e+00   0.606  0.54489
`Social smoker`                   -2.309e+00  2.067e+00  -1.117  0.26428
Pet                                2.335e-02  4.835e-01   0.048  0.96150
Weight                            -1.106e-01  5.418e-02  -2.041  0.04160
Height                             3.522e-01  1.079e-01   3.265  0.00115
Month.f1                           4.933e+00  7.890e+00   0.625  0.53198
Month.f2                           5.641e+00  7.790e+00   0.724  0.46924
Month.f3                           9.253e+00  7.766e+00   1.191  0.23389
Month.f4                           8.769e+00  7.811e+00   1.123  0.26200
Month.f5                           6.135e+00  7.822e+00   0.784  0.43308
Month.f6                           7.903e+00  7.796e+00   1.014  0.31101
Month.f7                           1.095e+01  7.790e+00   1.405  0.16047
Month.f8                           5.667e+00  7.867e+00   0.720  0.47158
Month.f9                           6.176e+00  8.029e+00   0.769  0.44205
Month.f10                          5.555e+00  7.841e+00   0.708  0.47889
Month.f11                          8.307e+00  7.800e+00   1.065  0.28728
Month.f12                          9.566e+00  7.818e+00   1.224  0.22151
WeekDay.f3                        -1.352e+00  1.477e+00  -0.915  0.36047
WeekDay.f4                        -1.639e+00  1.464e+00  -1.119  0.26334
WeekDay.f5                        -4.538e+00  1.552e+00  -2.924  0.00356
WeekDay.f6                        -4.540e+00  1.528e+00  -2.971  0.00307
                                     
(Intercept)                       .  
`Transportation expense`             
`Distance from Residence to Work`    
`Service time`                       
Age                               .  
`Work load Average/day`              
`Hit target`                         
`Disciplinary failure`            ***
Education                            
Son                               .  
`Social drinker`                     
`Social smoker`                      
Pet                                  
Weight                            *  
Height                            ** 
Month.f1                             
Month.f2                             
Month.f3                             
Month.f4                             
Month.f5                             
Month.f6                             
Month.f7                             
Month.f8                             
Month.f9                             
Month.f10                            
Month.f11                            
Month.f12                            
WeekDay.f3                           
WeekDay.f4                           
WeekDay.f5                        ** 
WeekDay.f6                        ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 12.85 on 709 degrees of freedom
Multiple R-squared:  0.1083,	Adjusted R-squared:  0.07061 
F-statistic: 2.872 on 30 and 709 DF,  p-value: 7.534e-07
```

### And again...

```r
fit3 = update(fit2, . ~ . - Month.f , data = data)
summary(fit3)
```

```

Call:
lm(formula = `Absenteeism time in hours` ~ `Transportation expense` + 
    `Distance from Residence to Work` + `Service time` + Age + 
    `Work load Average/day` + `Hit target` + `Disciplinary failure` + 
    Education + Son + `Social drinker` + `Social smoker` + Pet + 
    Weight + Height + WeekDay.f, data = data)

Residuals:
    Min      1Q  Median      3Q     Max 
-17.213  -4.591  -2.013   0.955 108.186 

Coefficients:
                                    Estimate Std. Error t value Pr(>|t|)
(Intercept)                       -5.555e+01  2.191e+01  -2.535 0.011449
`Transportation expense`           1.458e-02  9.358e-03   1.558 0.119602
`Distance from Residence to Work` -7.316e-02  5.000e-02  -1.463 0.143830
`Service time`                     8.862e-02  1.978e-01   0.448 0.654221
Age                                2.156e-01  1.147e-01   1.879 0.060636
`Work load Average/day`            2.130e-06  1.254e-05   0.170 0.865194
`Hit target`                       3.720e-02  1.306e-01   0.285 0.775866
`Disciplinary failure`            -8.483e+00  2.185e+00  -3.883 0.000113
Education                         -9.489e-01  8.552e-01  -1.110 0.267540
Son                                9.833e-01  5.122e-01   1.920 0.055287
`Social drinker`                   1.210e+00  1.505e+00   0.804 0.421488
`Social smoker`                   -2.232e+00  2.030e+00  -1.099 0.271945
Pet                               -6.007e-03  4.724e-01  -0.013 0.989858
Weight                            -1.155e-01  5.368e-02  -2.151 0.031793
Height                             3.486e-01  1.072e-01   3.252 0.001197
WeekDay.f3                        -1.423e+00  1.469e+00  -0.968 0.333287
WeekDay.f4                        -1.912e+00  1.457e+00  -1.312 0.189858
WeekDay.f5                        -4.670e+00  1.549e+00  -3.014 0.002665
WeekDay.f6                        -4.483e+00  1.519e+00  -2.952 0.003263
                                     
(Intercept)                       *  
`Transportation expense`             
`Distance from Residence to Work`    
`Service time`                       
Age                               .  
`Work load Average/day`              
`Hit target`                         
`Disciplinary failure`            ***
Education                            
Son                               .  
`Social drinker`                     
`Social smoker`                      
Pet                                  
Weight                            *  
Height                            ** 
WeekDay.f3                           
WeekDay.f4                           
WeekDay.f5                        ** 
WeekDay.f6                        ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 12.89 on 721 degrees of freedom
Multiple R-squared:  0.08847,	Adjusted R-squared:  0.06571 
F-statistic: 3.888 on 18 and 721 DF,  p-value: 1.182e-07
```

The problem is that this method does not make our remaining predictors more significant. So we shall use _**Subset Selection**_

Multiple Regression - Subset Selection
========================================================
source: ../Src/Regression.R

* We use validation set approach to test our models
* Subset selecting by
  + AIC & BIC parameters
  + Forward, Backward, and Bi-Directional

so, we have 6 combination:



### Results:
<img src="Project-figure/unnamed-chunk-14-1.png" title="plot of chunk unnamed-chunk-14" alt="plot of chunk unnamed-chunk-14" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-14-2.png" title="plot of chunk unnamed-chunk-14" alt="plot of chunk unnamed-chunk-14" width="100%" angle=90 style="display: block; margin: auto;" />

* So, Best linear regression model is:

```r
summary(bidirRegAIC)
```

```

Call:
lm(formula = bidirStepAIC[["terms"]], data = data)

Residuals:
    Min      1Q  Median      3Q     Max 
-33.618  -3.369  -0.595   1.495 100.451 

Coefficients:
                                Estimate Std. Error t value Pr(>|t|)    
(Intercept)                   -5.312e+01  1.389e+01  -3.825 0.000142 ***
Reason.f.I                     1.139e+01  3.507e+00   3.248 0.001216 ** 
Reason.f.II                    2.585e+01  1.201e+01   2.153 0.031672 *  
Reason.f.III                   8.695e+00  1.197e+01   0.726 0.467900    
Reason.f.IV                    4.736e+00  8.574e+00   0.552 0.580833    
Reason.f.V                     6.259e+00  7.072e+00   0.885 0.376443    
Reason.f.VI                    2.073e+01  4.570e+00   4.536 6.75e-06 ***
Reason.f.VII                   1.156e+01  3.580e+00   3.229 0.001298 ** 
Reason.f.VIII                  6.423e+00  5.161e+00   1.245 0.213644    
Reason.f.IX                    4.308e+01  6.222e+00   6.923 9.94e-12 ***
Reason.f.X                     1.112e+01  2.994e+00   3.713 0.000221 ***
Reason.f.XI                    1.291e+01  2.968e+00   4.349 1.57e-05 ***
Reason.f.XII                   2.395e+01  4.594e+00   5.213 2.44e-07 ***
Reason.f.XIII                  1.692e+01  2.434e+00   6.952 8.23e-12 ***
Reason.f.XIV                   8.961e+00  3.259e+00   2.749 0.006124 ** 
Reason.f.XV                    5.001e+00  8.582e+00   0.583 0.560280    
Reason.f.XVI                   2.421e+00  7.120e+00   0.340 0.733930    
Reason.f.XVII                  9.271e+00  1.201e+01   0.772 0.440347    
Reason.f.XVIII                 1.015e+01  3.164e+00   3.208 0.001397 ** 
Reason.f.XIX                   1.828e+01  2.614e+00   6.992 6.29e-12 ***
Reason.f.XXI                   8.041e+00  5.185e+00   1.551 0.121390    
Reason.f.patient.follow-up     8.815e+00  2.682e+00   3.287 0.001062 ** 
Reason.f.medical.consultation  3.800e+00  2.075e+00   1.831 0.067506 .  
Reason.f.blood.donation        8.385e+00  7.105e+00   1.180 0.238312    
Reason.f.laboratory.exam       3.824e+00  2.829e+00   1.352 0.176932    
Reason.f.unjustified.absence   8.298e+00  2.759e+00   3.007 0.002732 ** 
Reason.f.physiotherapy         4.881e+00  2.383e+00   2.048 0.040900 *  
Reason.f.dental.consultation   3.006e+00  2.139e+00   1.405 0.160421    
Height                         3.311e-01  8.340e-02   3.970 7.91e-05 ***
Son                            9.939e-01  4.503e-01   2.207 0.027617 *  
Age                            2.150e-01  8.055e-02   2.670 0.007765 ** 
Education                     -1.693e+00  7.534e-01  -2.247 0.024924 *  
`Work load Average/day`       -2.061e-05  1.164e-05  -1.770 0.077133 .  
Weight                        -7.254e-02  4.581e-02  -1.584 0.113755    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 11.81 on 706 degrees of freedom
Multiple R-squared:  0.2506,	Adjusted R-squared:  0.2156 
F-statistic: 7.154 on 33 and 706 DF,  p-value: < 2.2e-16
```

Ridge & Lasso Regression
========================================================
source: ../Src/Regression.R

* Applying Ridge & Lasso Regression by different values for lambda
* Finding best lambda with Cross Validation


```r
require(glmnet)

X = data.matrix(data[, setdiff(colnames(data), "Absenteeism time in hours")])
# Ridge
ridgeReg = glmnet(X, data$`Absenteeism time in hours`, alpha = 0)
plot(ridgeReg, main = "Ridge Regression against lambda Value")
```

<img src="Project-figure/unnamed-chunk-16-1.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" width="100%" angle=90 style="display: block; margin: auto;" />

```r
ridgeReg = cv.glmnet(X, data$`Absenteeism time in hours`, alpha = 0)
plot(ridgeReg, main = "Cross Validated MSE over Ridge lambda Value")
```

<img src="Project-figure/unnamed-chunk-16-2.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" width="100%" angle=90 style="display: block; margin: auto;" />

```r
coef.cv.glmnet(ridgeReg, s = "lambda.min")
```

```
19 x 1 sparse Matrix of class "dgCMatrix"
                                            1
(Intercept)                     -3.271662e+01
Transportation expense           2.255310e-03
Distance from Residence to Work -6.871375e-02
Service time                    -3.900634e-02
Age                              1.857101e-01
Work load Average/day           -2.114726e-06
Hit target                       1.104063e-01
Disciplinary failure            -1.555696e+01
Education                       -1.609764e+00
Son                              1.062521e+00
Social drinker                   8.729456e-01
Social smoker                   -2.409296e+00
Pet                             -2.107000e-01
Weight                          -1.018587e-01
Height                           2.716416e-01
ID.f                            -1.092817e-01
Reason.f.                       -4.257516e-01
Month.f                          1.309880e-01
WeekDay.f                       -8.170472e-01
```

```r
# Lasso
lassoReg = glmnet(X, data$`Absenteeism time in hours`, alpha = 1)
plot(lassoReg, main = "Lasso Regression against lambda Value")
```

<img src="Project-figure/unnamed-chunk-16-3.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" width="100%" angle=90 style="display: block; margin: auto;" />

```r
lassoReg = cv.glmnet(X, data$`Absenteeism time in hours`, alpha = 1)
plot(lassoReg, main = "Cross Validated MSE over Lasso lambda Value")
```

<img src="Project-figure/unnamed-chunk-16-4.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" width="100%" angle=90 style="display: block; margin: auto;" />

```r
coef.cv.glmnet(lassoReg, s = "lambda.min")
```

```
19 x 1 sparse Matrix of class "dgCMatrix"
                                            1
(Intercept)                     -3.002592e+01
Transportation expense           5.800286e-04
Distance from Residence to Work -6.782632e-02
Service time                    -6.830480e-03
Age                              1.834794e-01
Work load Average/day           -2.449581e-06
Hit target                       7.974607e-02
Disciplinary failure            -1.746605e+01
Education                       -1.751822e+00
Son                              1.107920e+00
Social drinker                   6.876934e-01
Social smoker                   -2.508493e+00
Pet                             -1.225815e-01
Weight                          -1.102823e-01
Height                           2.866331e-01
ID.f                            -1.182027e-01
Reason.f.                       -4.794782e-01
Month.f                          1.121974e-01
WeekDay.f                       -7.898483e-01
```

```r
summary(lassoReg)
```

```
           Length Class  Mode     
lambda     65     -none- numeric  
cvm        65     -none- numeric  
cvsd       65     -none- numeric  
cvup       65     -none- numeric  
cvlo       65     -none- numeric  
nzero      65     -none- numeric  
name        1     -none- character
glmnet.fit 12     elnet  list     
lambda.min  1     -none- numeric  
lambda.1se  1     -none- numeric  
```


Classification
========================================================

This dataset also provides 'Reason For Absence' which we use as target of classification


Logestic Regression
========================================================
source: ../Src/Classification.R

In logestic regression we fit probabilities over target classes (0, 1) in binary classification. In order to discuss _True positive_, _False Positive_, _True Negative_, _False Negative_ we need to use a binary classification. But our target has more classes:

```r
length(levels(data$Reason.f.))
```

```
[1] 29
```

So, we define new classification target _"Reason ICD Disease"_ which determines whether _Reason for absence_ is one of the disease coded by International Code of Disease (ICD) or not.

We also use 10-fold Cross Validation to find best coefficent for logestic regression.

When we find our best model the result of model for test data is fitted probability values between 0 and 1.

So, the default action is to assign values with probability less than 0.5 to class 0 and higher than 0.5 to class 1 respectively.

But as you can see in data, The samples with _'Other'_ label has lower frequency. so the threshold 0.5 for assigning classes may not be useful. ROC curves help us to find optimum threshold.

So, enough talking. Move on to codes...


```r
setwd("..")
source("./Src/Classification.R", local = FALSE)
```

<img src="Project-figure/unnamed-chunk-18-1.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-18-2.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-18-3.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="100%" angle=90 style="display: block; margin: auto;" />

```
Confusion Table for fold[1]       
predRes Other ICD
  ICD       4  13
  Other    49   8
Accuracy[1] = 0.837838 

Confusion Table for fold[2]       
predRes Other ICD
  ICD       3  17
  Other    38  16
Accuracy[2] = 0.743243 

Confusion Table for fold[3]       
predRes Other ICD
  ICD       5  11
  Other    49   9
Accuracy[3] = 0.810811 

Confusion Table for fold[4]       
predRes Other ICD
  ICD      12   8
  Other    44  10
Accuracy[4] = 0.702703 

Confusion Table for fold[5]       
predRes Other ICD
  ICD       3  12
  Other    40  19
Accuracy[5] = 0.702703 

Confusion Table for fold[6]       
predRes Other ICD
  ICD       7  15
  Other    38  14
Accuracy[6] = 0.716216 

Confusion Table for fold[7]       
predRes Other ICD
  ICD       6  18
  Other    45   5
Accuracy[7] = 0.851351 

Confusion Table for fold[8]       
predRes Other ICD
  ICD       3  15
  Other    42  14
Accuracy[8] = 0.770270 

Confusion Table for fold[9]       
predRes Other ICD
  ICD       4  18
  Other    42  10
Accuracy[9] = 0.810811 

Confusion Table for fold[10]       
predRes Other ICD
  ICD       6  14
  Other    38  16
Accuracy[10] = 0.702703 

CV Error: 0.235135 
```

<img src="Project-figure/unnamed-chunk-18-4.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-18-5.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="100%" angle=90 style="display: block; margin: auto;" />


KNN
========================================================
source: ../Src/KNN.R

In kNN for a new test data we consider its k nearest neighbor as the voters for this new data class. 

It is completely straight Assigning k = 15:

```
[1] "C:/Users/Xara/Desktop/R-Statistics Project"
```

```
Confusion Table
                      
knnPred                None  I II III IV  V VI VII VIII IX  X XI XII XIII
  None                    2  0  0   0  0  0  0   0    0  0  0  0   0    0
  I                       0  0  0   0  0  0  0   0    0  0  0  0   0    0
  II                      0  0  0   0  0  0  0   0    0  0  0  0   0    0
  III                     0  0  0   0  0  0  0   0    0  0  0  0   0    0
  IV                      0  0  0   0  0  0  0   0    0  0  0  0   0    0
  V                       0  0  0   0  0  0  0   0    0  0  0  0   0    0
  VI                      0  0  0   0  0  0  0   0    0  0  0  0   0    0
  VII                     0  0  0   0  0  0  0   0    0  0  0  0   0    0
  VIII                    0  0  0   0  0  0  0   0    0  0  0  0   0    0
  IX                      0  0  0   0  0  0  0   0    0  0  0  0   0    0
  X                       0  0  0   0  0  0  0   0    0  0  0  0   0    1
  XI                      0  0  0   0  0  0  0   0    0  0  0  0   0    1
  XII                     0  0  0   0  0  0  0   0    0  0  0  0   0    0
  XIII                    0  0  0   0  0  0  0   0    0  0  0  1   0    1
  XIV                     0  0  0   0  0  0  0   0    0  0  0  0   0    0
  XV                      0  0  0   0  0  0  0   0    0  0  0  0   0    0
  XVI                     0  0  0   0  0  0  0   0    0  0  0  0   0    0
  XVII                    0  0  0   0  0  0  0   0    0  0  0  0   0    0
  XVIII                   0  0  0   0  0  0  0   0    0  0  0  0   0    0
  XIX                     0  0  0   0  0  0  0   0    0  0  0  0   0    2
  XXI                     0  0  0   0  0  0  0   0    0  0  0  0   0    0
  patient.follow-up       0  0  0   0  0  0  0   0    0  0  0  0   0    0
  medical.consultation    0  0  0   0  0  0  1   0    0  0  1  3   0    3
  blood.donation          0  0  0   0  0  0  0   0    0  0  0  0   0    0
  laboratory.exam         0  0  0   0  0  0  0   0    0  0  0  0   0    0
  unjustified.absence     0  0  0   0  0  0  0   0    0  0  0  0   0    0
  physiotherapy           0  0  0   0  0  0  0   0    0  0  1  0   1    1
  dental.consultation     0  0  0   0  0  0  0   0    0  0  1  0   0    1
                      
knnPred                XIV XV XVI XVII XVIII XIX XXI patient.follow-up
  None                   0  0   0    0     0   1   0                 1
  I                      0  0   0    0     0   0   0                 0
  II                     0  0   0    0     0   0   0                 0
  III                    0  0   0    0     0   0   0                 0
  IV                     0  0   0    0     0   0   0                 0
  V                      0  0   0    0     0   0   0                 0
  VI                     0  0   0    0     0   0   0                 0
  VII                    0  0   0    0     0   0   0                 0
  VIII                   0  0   0    0     0   0   0                 0
  IX                     0  0   0    0     0   0   0                 0
  X                      0  0   0    0     0   0   0                 0
  XI                     0  0   0    0     0   0   0                 0
  XII                    0  0   0    0     0   0   0                 0
  XIII                   0  0   0    0     0   0   0                 0
  XIV                    0  0   0    0     0   0   0                 0
  XV                     0  0   0    0     0   0   0                 0
  XVI                    0  0   0    0     0   0   0                 0
  XVII                   0  0   0    0     0   0   0                 0
  XVIII                  0  0   0    0     0   0   0                 0
  XIX                    0  0   0    0     0   0   0                 0
  XXI                    0  0   0    0     0   0   0                 0
  patient.follow-up      0  0   0    0     0   0   0                 0
  medical.consultation   1  0   0    0     3   3   0                 0
  blood.donation         0  0   0    0     0   0   0                 0
  laboratory.exam        0  0   0    0     0   0   0                 0
  unjustified.absence    0  0   0    0     0   0   0                 0
  physiotherapy          1  0   1    0     1   1   0                 0
  dental.consultation    1  0   0    0     0   0   1                 2
                      
knnPred                medical.consultation blood.donation laboratory.exam
  None                                    2              0               0
  I                                       0              0               0
  II                                      0              0               0
  III                                     0              0               0
  IV                                      0              0               0
  V                                       0              0               0
  VI                                      0              0               0
  VII                                     0              0               0
  VIII                                    0              0               0
  IX                                      0              0               0
  X                                       0              0               0
  XI                                      0              0               0
  XII                                     0              0               0
  XIII                                    0              0               0
  XIV                                     0              0               0
  XV                                      0              0               0
  XVI                                     0              0               0
  XVII                                    0              0               0
  XVIII                                   0              0               0
  XIX                                     0              0               0
  XXI                                     0              0               0
  patient.follow-up                       0              0               0
  medical.consultation                   15              0               2
  blood.donation                          0              0               0
  laboratory.exam                         0              0               0
  unjustified.absence                     0              0               2
  physiotherapy                           5              0               6
  dental.consultation                     3              1               1
                      
knnPred                unjustified.absence physiotherapy
  None                                   0             0
  I                                      0             0
  II                                     0             0
  III                                    0             0
  IV                                     0             0
  V                                      0             0
  VI                                     0             0
  VII                                    0             0
  VIII                                   0             0
  IX                                     0             0
  X                                      0             0
  XI                                     0             0
  XII                                    0             0
  XIII                                   0             0
  XIV                                    0             0
  XV                                     0             0
  XVI                                    0             0
  XVII                                   0             0
  XVIII                                  0             0
  XIX                                    0             0
  XXI                                    0             0
  patient.follow-up                      0             0
  medical.consultation                   1             1
  blood.donation                         0             0
  laboratory.exam                        0             0
  unjustified.absence                    0             0
  physiotherapy                          0             6
  dental.consultation                    1             0
                      
knnPred                dental.consultation
  None                                   1
  I                                      0
  II                                     0
  III                                    0
  IV                                     0
  V                                      0
  VI                                     0
  VII                                    0
  VIII                                   0
  IX                                     0
  X                                      0
  XI                                     0
  XII                                    0
  XIII                                   0
  XIV                                    0
  XV                                     0
  XVI                                    0
  XVII                                   0
  XVIII                                  0
  XIX                                    0
  XXI                                    0
  patient.follow-up                      0
  medical.consultation                   5
  blood.donation                         0
  laboratory.exam                        0
  unjustified.absence                    0
  physiotherapy                          2
  dental.consultation                    8
[1] "Accuracy on test data: 0.320000"
```


Discriminant Analysis
========================================================
source: ../Src/DiscriminantAnalysis.R

Here we use original _"Reason for absence"_ feature for classification and because of this the problem is not binary classification anymore

## Preprocess

In discriminant analysis we assume that each class have normal distribution and then fit the model according to a score. According to what we said before, each method needs a special preprocess on data in order to work well. For discriminant analysis we need to have more than 30 instances in each class to fit a normal distrbution. So in our preprocess here we remove instances labeled by classes with less than 30 frequeny rate.

We also mentioned that in this dataset many features are dependent on eachother, because the value of these columns for a single person remains constant. This makes columns of data frame linearly dependent and model can not be fit. In order to resolve this issue we have 2 options:
* Remove these columns until we have linearly independent columns
* Project each data to a new feature space with linearly independent columns

The first option seems good and easy but it removes many important parts of data which may be relevant to the _'Reason for absence'_.

The second option also seems good in Theory, but in practice which projection is best? The best possible solution seems to be the PCA feature space. We project original feature to PCA components with higher importance and leave out the less important features until we have new columns with linear independence.

## The Code



SVM
========================================================
source: ../Src/SVM.R

We use multi class SVM which fits an SVM model for binary classification for each class (One vs. All). 

We first train a SVM model by 10-fold Cross Validation on full data set.

Then we dig into SVM details by splitting data into _Train_ and _Test_ sets (4:1 ratio) and applying a grid search for best cost parameter in SVM model by _linear_ and _radial_ kernels to find the best model and test it over _Test_ data. Here is the code:


Tree
========================================================
source: ../Src/Tree.R






Test
========================================================
The Google Play Games plugin for Unity allows you to access the Google Play Games
API through Unity's [social interface](http://docs.unity3d.com/Documentation/ScriptReference/Social.html).
The plugin provides support for the
following features of the Google Play Games API:<br/>


First Slide
========================================================

For more details on authoring R presentations please visit <https://support.rstudio.com/hc/en-us/articles/200486468>.

- Bullet 1
- Bullet 2
- Bullet 3

Slide With Code
========================================================


```r
summary(cars)
```

```
     speed           dist       
 Min.   : 4.0   Min.   :  2.00  
 1st Qu.:12.0   1st Qu.: 26.00  
 Median :15.0   Median : 36.00  
 Mean   :15.4   Mean   : 42.98  
 3rd Qu.:19.0   3rd Qu.: 56.00  
 Max.   :25.0   Max.   :120.00  
```

Slide With Plot
========================================================

![plot of chunk unnamed-chunk-21](Project-figure/unnamed-chunk-21-1.png)
