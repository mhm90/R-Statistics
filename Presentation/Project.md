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
    });
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
  + [Data Set Info](#/data-info)
  + [Data Clearing](#/clearing)
  + [PCA](#/pca)
* [__Regression__](#/reg)
  + [Simple Linear Regression](#/single-reg)
  + [Multiple Linear Regression](#/mult-reg)
  + [Subset Selectiong (Validation Set)](#/subset)
  + [Ridge & Lasso Regression](#/ridge-lasso)
  

Outline
========================================================
* [__Classification__](#/classification)
  + [Logestic Regression](#/logestic)
  + [KNN](#/knn)
  + [LDA](#/da)
  + [QDA](#/da)
  + [SVM](#/svm)
* [__Trees__](#/trees)
* [__Clustering__](#/clustering)
  + [K-Means](#/clustering)
  + [Hierarchial Clustering](#/clustering)
  + [M-Clustering](#/clustering)

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
id:data-info

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

### But,

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
id:clearing
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


PCA
========================================================
id:pca
source: ../Src/PCA.R

Accordng to what we said in [_Data Information_](#/data-info) part, there is many redundancy in our data and also there is 21 features in our dataset. Many of these features are not quite informative for our work. PCA is a good method to project feature space into another space with components that are sorted by their importance and describing most part of data variation. We use pca to select features later on [**Discriminant Analysis**](/#da). Here is more details about it:


```
Importance of components:
                          PC1    PC2     PC3     PC4     PC5     PC6
Standard deviation     1.6564 1.4882 1.22848 1.19352 1.17403 1.05737
Proportion of Variance 0.1614 0.1303 0.08877 0.08379 0.08108 0.06577
Cumulative Proportion  0.1614 0.2917 0.38045 0.46425 0.54533 0.61109
                           PC7     PC8     PC9    PC10    PC11    PC12
Standard deviation     1.03401 1.01033 0.89620 0.88123 0.84258 0.79706
Proportion of Variance 0.06289 0.06005 0.04725 0.04568 0.04176 0.03737
Cumulative Proportion  0.67399 0.73403 0.78128 0.82696 0.86872 0.90609
                          PC13    PC14   PC15    PC16    PC17
Standard deviation     0.67859 0.65507 0.5654 0.46984 0.40799
Proportion of Variance 0.02709 0.02524 0.0188 0.01299 0.00979
Cumulative Proportion  0.93318 0.95842 0.9772 0.99021 1.00000
```

<img src="Project-figure/unnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-4-2.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" width="100%" angle=90 style="display: block; margin: auto;" />

Regression
========================================================
id:reg
source: ../Src/Regression.R

## Single Linear Regression

<img src="Project-figure/unnamed-chunk-5-1.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-5-2.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" width="100%" angle=90 style="display: block; margin: auto;" />

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

<img src="Project-figure/unnamed-chunk-8-1.png" title="plot of chunk unnamed-chunk-8" alt="plot of chunk unnamed-chunk-8" width="100%" angle=90 style="display: block; margin: auto;" />

Note that the blue line is specifying only one of newly added predictors

Single Regression
========================================================
id:single-reg
source: ../Src/Regression.R

## Single Linear Regression

<img src="Project-figure/unnamed-chunk-9-1.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-2.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-3.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-4.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-5.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-6.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-7.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-8.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-9.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-10.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-11.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-12.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-13.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-14.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-15.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-16.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-17.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-18.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-19.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-20.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-21.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-22.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-23.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-24.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-25.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-9-26.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="100%" angle=90 style="display: block; margin: auto;" />


Multiple Regression
========================================================
id:mult-reg
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
id:subset
source: ../Src/Regression.R


* We use validation set approach to test our models
* Subset selecting by
  + AIC & BIC parameters
  + Forward, Backward, and Bi-Directional

so, we have 6 combination:



### Results:
<img src="Project-figure/unnamed-chunk-16-1.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-16-2.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" width="100%" angle=90 style="display: block; margin: auto;" />

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
id:ridge-lasso
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

<img src="Project-figure/unnamed-chunk-18-1.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="100%" angle=90 style="display: block; margin: auto;" />

```r
ridgeReg = cv.glmnet(X, data$`Absenteeism time in hours`, alpha = 0)
plot(ridgeReg, main = "Cross Validated MSE over Ridge lambda Value")
```

<img src="Project-figure/unnamed-chunk-18-2.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="100%" angle=90 style="display: block; margin: auto;" />

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

<img src="Project-figure/unnamed-chunk-18-3.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="100%" angle=90 style="display: block; margin: auto;" />

```r
lassoReg = cv.glmnet(X, data$`Absenteeism time in hours`, alpha = 1)
plot(lassoReg, main = "Cross Validated MSE over Lasso lambda Value")
```

<img src="Project-figure/unnamed-chunk-18-4.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="100%" angle=90 style="display: block; margin: auto;" />

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
id:classification

This dataset also provides 'Reason For Absence' which we use as target of classification


Logestic Regression
========================================================
id:logestic
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

But as you can see in data, The samples with _'Other'_ label has lower frequency. So the threshold 0.5 for assigning classes may not be useful. ROC curves help us to find optimum threshold.

Enough talking. Move on to codes...


```r
setwd("..")
source("./Src/Classification.R", local = FALSE)
```

<img src="Project-figure/unnamed-chunk-20-1.png" title="plot of chunk unnamed-chunk-20" alt="plot of chunk unnamed-chunk-20" width="100%" angle=90 style="display: block; margin: auto;" />

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

<img src="Project-figure/unnamed-chunk-20-2.png" title="plot of chunk unnamed-chunk-20" alt="plot of chunk unnamed-chunk-20" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-20-3.png" title="plot of chunk unnamed-chunk-20" alt="plot of chunk unnamed-chunk-20" width="100%" angle=90 style="display: block; margin: auto;" />


KNN
========================================================
id:knn
source: ../Src/KNN.R

In **kNN** for a new test data we consider its k nearest neighbor as the voters for this new data class. 

It is completely straight Assigning k = 15:


```r
setwd("..")
#getwd()
source("./Src/KNN.R", echo = FALSE)
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
id:da
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

```r
setwd("..")
source("./Src/DiscriminantAnalysis.R", echo = FALSE)
```


```
Importance of components:
                          PC1    PC2     PC3     PC4     PC5     PC6
Standard deviation     1.6564 1.4882 1.22848 1.19352 1.17403 1.05737
Proportion of Variance 0.1614 0.1303 0.08877 0.08379 0.08108 0.06577
Cumulative Proportion  0.1614 0.2917 0.38045 0.46425 0.54533 0.61109
                           PC7     PC8     PC9    PC10    PC11    PC12
Standard deviation     1.03401 1.01033 0.89620 0.88123 0.84258 0.79706
Proportion of Variance 0.06289 0.06005 0.04725 0.04568 0.04176 0.03737
Cumulative Proportion  0.67399 0.73403 0.78128 0.82696 0.86872 0.90609
                          PC13    PC14   PC15    PC16    PC17
Standard deviation     0.67859 0.65507 0.5654 0.46984 0.40799
Proportion of Variance 0.02709 0.02524 0.0188 0.01299 0.00979
Cumulative Proportion  0.93318 0.95842 0.9772 0.99021 1.00000
```

<img src="Project-figure/unnamed-chunk-23-1.png" title="plot of chunk unnamed-chunk-23" alt="plot of chunk unnamed-chunk-23" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-23-2.png" title="plot of chunk unnamed-chunk-23" alt="plot of chunk unnamed-chunk-23" width="100%" angle=90 style="display: block; margin: auto;" />

```
   LDA Model:
        Length Class  Mode     
prior    9     -none- numeric  
counts   9     -none- numeric  
means   72     -none- numeric  
scaling 64     -none- numeric  
lev      9     -none- character
svd      8     -none- numeric  
N        1     -none- numeric  
call     3     -none- call     
terms    3     terms  call     
xlevels  0     -none- list     


  LDA fit confusion table 
                      
                       None XIII XIX patient.follow-up
  None                   40    0   0                 0
  XIII                    0   11   9                 0
  XIX                     0    5   6                 3
  patient.follow-up       1    1   6                16
  medical.consultation    0   17  10                 8
  laboratory.exam         0    1   1                 4
  unjustified.absence     0    0   0                 0
  physiotherapy           1    9   0                 0
  dental.consultation     1   11   8                 7
                      
                       medical.consultation laboratory.exam
  None                                    1               0
  XIII                                    0               0
  XIX                                     4               1
  patient.follow-up                       5               1
  medical.consultation                   93              19
  laboratory.exam                         3               8
  unjustified.absence                     0               0
  physiotherapy                          14               0
  dental.consultation                    29               2
                      
                       unjustified.absence physiotherapy
  None                                   0             0
  XIII                                   1             0
  XIX                                    3             0
  patient.follow-up                      0             0
  medical.consultation                  18            16
  laboratory.exam                        0             0
  unjustified.absence                    0             0
  physiotherapy                          1            53
  dental.consultation                   10             0
                      
                       dental.consultation
  None                                   0
  XIII                                   1
  XIX                                    3
  patient.follow-up                      1
  medical.consultation                  51
  laboratory.exam                        2
  unjustified.absence                    0
  physiotherapy                         10
  dental.consultation                   44
[1] "  LDA model accuracy: 0.475439"



   QDA Model:
        Length Class  Mode     
prior     9    -none- numeric  
counts    9    -none- numeric  
means    72    -none- numeric  
scaling 576    -none- numeric  
ldet      9    -none- numeric  
lev       9    -none- character
N         1    -none- numeric  
call      3    -none- call     
terms     3    terms  call     
xlevels   0    -none- list     


   QDA fit confusion table 
                      
                       None XIII XIX patient.follow-up
  None                   41    0   0                 0
  XIII                    0   14   4                 0
  XIX                     0    5  10                 0
  patient.follow-up       0    0   6                19
  medical.consultation    2   10   7                 2
  laboratory.exam         0    4   0                 6
  unjustified.absence     0    3   8                 6
  physiotherapy           0    8   1                 0
  dental.consultation     0   11   4                 5
                      
                       medical.consultation laboratory.exam
  None                                    1               0
  XIII                                    2               0
  XIX                                     0               0
  patient.follow-up                       5               1
  medical.consultation                   82               8
  laboratory.exam                         9              14
  unjustified.absence                     8               2
  physiotherapy                          16               4
  dental.consultation                    26               2
                      
                       unjustified.absence physiotherapy
  None                                   0             0
  XIII                                   0             0
  XIX                                    1             0
  patient.follow-up                      0             0
  medical.consultation                   8             0
  laboratory.exam                        2             0
  unjustified.absence                   17             1
  physiotherapy                          0            68
  dental.consultation                    5             0
                      
                       dental.consultation
  None                                   1
  XIII                                   1
  XIX                                    0
  patient.follow-up                      1
  medical.consultation                  32
  laboratory.exam                        2
  unjustified.absence                    1
  physiotherapy                         12
  dental.consultation                   62
[1] "  QDA model accuracy: 0.573684"
```


SVM
========================================================
id:svm
source: ../Src/SVM.R

We use multi class SVM which fits an SVM model for binary classification for each class (One vs. All). 

We first train a SVM model by 10-fold Cross Validation on full data set.

Then we dig into SVM details by splitting data into _Train_ and _Test_ sets (4:1 ratio) and applying a grid search for best cost parameter in SVM model by _linear_ and _radial_ kernels to find the best model and test it over _Test_ data. Here is the code:


```r
setwd("..")
source("./Src/SVM.R", echo = FALSE)
```


```

Call:
svm(formula = Reason.f. ~ ., data = data, cross = 10)


Parameters:
   SVM-Type:  C-classification 
 SVM-Kernel:  radial 
       cost:  1 
      gamma:  0.01492537 

Number of Support Vectors:  717

 ( 33 36 139 15 37 40 16 26 19 6 25 55 111 21 31 3 8 65 1 6 8 3 4 2 2 1 1 3 )


Number of Classes:  28 

Levels: 
 None I II III IV V VI VII VIII IX X XI XII XIII XIV XV XVI XVII XVIII XIX XXI patient.follow-up medical.consultation blood.donation laboratory.exam unjustified.absence physiotherapy dental.consultation

10-fold cross-validation on training data:

Total Accuracy: 35.40541 
Single Accuracies:
 40.54054 32.43243 40.54054 32.43243 35.13514 36.48649 32.43243 35.13514 39.18919 29.72973 
```

<img src="Project-figure/unnamed-chunk-25-1.png" title="plot of chunk unnamed-chunk-25" alt="plot of chunk unnamed-chunk-25" width="100%" angle=90 style="display: block; margin: auto;" />

```


   Confustion Table of SVM model for Original Data (10-fold CV)
                      
pred                   None   I  II III  IV   V  VI VII VIII  IX   X  XI
  None                   40   0   0   0   0   0   0   0    0   0   0   0
  I                       0   0   0   0   0   0   0   0    0   0   0   0
  II                      0   0   0   0   0   0   0   0    0   0   0   0
  III                     0   0   0   0   0   0   0   0    0   0   0   0
  IV                      0   0   0   0   0   0   0   0    0   0   0   0
  V                       0   0   0   0   0   0   0   0    0   0   0   0
  VI                      0   0   0   0   0   0   0   0    0   0   0   0
  VII                     0   0   0   0   0   0   0   0    0   0   0   0
  VIII                    0   0   0   0   0   0   0   0    0   0   0   0
  IX                      0   0   0   0   0   0   0   0    0   0   0   0
  X                       0   0   0   0   0   0   0   0    0   0   0   0
  XI                      0   0   0   0   0   0   0   0    0   0   0   0
  XII                     0   0   0   0   0   0   0   0    0   0   0   0
  XIII                    0   1   0   0   0   0   1   2    0   1   1   0
  XIV                     0   0   0   0   0   0   0   0    0   0   0   0
  XV                      0   0   0   0   0   0   0   0    0   0   0   0
  XVI                     0   0   0   0   0   0   0   0    0   0   0   0
  XVII                    0   0   0   0   0   0   0   0    0   0   0   0
  XVIII                   0   0   0   0   0   0   0   0    0   0   0   0
  XIX                     0   0   0   0   0   0   0   0    0   1   1   2
  XXI                     0   0   0   0   0   0   0   0    0   0   0   0
  patient.follow-up       0   1   0   0   0   0   0   1    1   0   1   0
  medical.consultation    3  11   1   0   1   2   6  12    3   1  15  14
  blood.donation          0   0   0   0   0   0   0   0    0   0   0   0
  laboratory.exam         0   0   0   0   0   0   0   0    2   0   1   1
  unjustified.absence     0   0   0   0   0   0   0   0    0   0   0   0
  physiotherapy           0   0   0   0   0   1   1   0    0   0   2   2
  dental.consultation     0   3   0   1   1   0   0   0    0   1   4   7
                      
pred                   XII XIII XIV  XV XVI XVII XVIII XIX XXI
  None                   0    0   0   0   0    0     0   0   0
  I                      0    0   0   0   0    0     0   0   0
  II                     0    0   0   0   0    0     0   0   0
  III                    0    0   0   0   0    0     0   0   0
  IV                     0    0   0   0   0    0     0   0   0
  V                      0    0   0   0   0    0     0   0   0
  VI                     0    0   0   0   0    0     0   0   0
  VII                    0    0   0   0   0    0     0   0   0
  VIII                   0    0   0   0   0    0     0   0   0
  IX                     0    0   0   0   0    0     0   0   0
  X                      0    0   0   0   0    0     0   0   0
  XI                     0    0   0   0   0    0     0   0   0
  XII                    0    0   0   0   0    0     0   0   0
  XIII                   0   10   1   0   0    0     0   0   0
  XIV                    0    0   0   0   0    0     0   0   0
  XV                     0    0   0   0   0    0     0   0   0
  XVI                    0    0   0   0   0    0     0   0   0
  XVII                   0    0   0   0   0    0     0   0   0
  XVIII                  0    0   0   0   0    0     0   0   0
  XIX                    1    2   0   0   0    0     1   7   0
  XXI                    0    0   0   0   0    0     0   0   0
  patient.follow-up      1    1   2   0   0    0     1   7   0
  medical.consultation   2   20  12   0   1    0    13  16   1
  blood.donation         0    0   0   0   0    0     0   0   0
  laboratory.exam        0    0   0   0   2    1     2   0   2
  unjustified.absence    0    1   0   0   0    0     0   0   0
  physiotherapy          2   13   0   0   0    0     2   2   2
  dental.consultation    2    8   4   2   0    0     2   8   1
                      
pred                   patient.follow-up medical.consultation
  None                                 0                    0
  I                                    0                    0
  II                                   0                    0
  III                                  0                    0
  IV                                   0                    0
  V                                    0                    0
  VI                                   0                    0
  VII                                  0                    0
  VIII                                 0                    0
  IX                                   0                    0
  X                                    0                    0
  XI                                   0                    0
  XII                                  0                    0
  XIII                                 0                    0
  XIV                                  0                    0
  XV                                   0                    0
  XVI                                  0                    0
  XVII                                 0                    0
  XVIII                                0                    0
  XIX                                  0                    0
  XXI                                  0                    0
  patient.follow-up                   17                    4
  medical.consultation                17                  110
  blood.donation                       0                    0
  laboratory.exam                      1                    1
  unjustified.absence                  0                    0
  physiotherapy                        0                   13
  dental.consultation                  3                   21
                      
pred                   blood.donation laboratory.exam unjustified.absence
  None                              0               0                   0
  I                                 0               0                   0
  II                                0               0                   0
  III                               0               0                   0
  IV                                0               0                   0
  V                                 0               0                   0
  VI                                0               0                   0
  VII                               0               0                   0
  VIII                              0               0                   0
  IX                                0               0                   0
  X                                 0               0                   0
  XI                                0               0                   0
  XII                               0               0                   0
  XIII                              0               0                   0
  XIV                               0               0                   0
  XV                                0               0                   0
  XVI                               0               0                   0
  XVII                              0               0                   0
  XVIII                             0               0                   0
  XIX                               0               0                   0
  XXI                               0               0                   0
  patient.follow-up                 0               1                   0
  medical.consultation              3              20                  23
  blood.donation                    0               0                   0
  laboratory.exam                   0               6                   0
  unjustified.absence               0               0                   3
  physiotherapy                     0               3                   1
  dental.consultation               0               1                   6
                      
pred                   physiotherapy dental.consultation
  None                             0                   0
  I                                0                   0
  II                               0                   0
  III                              0                   0
  IV                               0                   0
  V                                0                   0
  VI                               0                   0
  VII                              0                   0
  VIII                             0                   0
  IX                               0                   0
  X                                0                   0
  XI                               0                   0
  XII                              0                   0
  XIII                             0                   0
  XIV                              0                   0
  XV                               0                   0
  XVI                              0                   0
  XVII                             0                   0
  XVIII                            0                   0
  XIX                              0                   0
  XXI                              0                   0
  patient.follow-up                0                   1
  medical.consultation             9                  36
  blood.donation                   0                   0
  laboratory.exam                  0                   0
  unjustified.absence              0                   0
  physiotherapy                   60                  18
  dental.consultation              0                  57
[1] "SVM model Accuracy: 0.418919"



 Tuning SVM Linear:

Parameter tuning of 'svm':

- sampling method: 10-fold cross validation 

- best parameters:
 cost
    1

- best performance: 0.5769209 

- Detailed performance results:
   cost     error dispersion
1 1e-03 0.7987571 0.04950434
2 1e-02 0.7293503 0.06089920
3 1e-01 0.6075141 0.10315065
4 1e+00 0.5769209 0.07445324
5 5e+00 0.5770056 0.07522877
6 1e+01 0.5972881 0.06863512
7 1e+02 0.5972881 0.07528850



   Best tuned Linear SVM Model by Tuning:

Call:
best.tune(method = svm, train.x = Reason.f. ~ ., data = trainSet, 
    ranges = list(cost = c(0.001, 0.01, 0.1, 1, 5, 10, 100)), 
    kernel = "linear")


Parameters:
   SVM-Type:  C-classification 
 SVM-Kernel:  linear 
       cost:  1 
      gamma:  0.01492537 

Number of Support Vectors:  559

 ( 25 22 112 12 28 32 13 21 15 5 20 87 17 25 2 44 6 48 1 5 6 2 3 2 2 1 1 2 )


Number of Classes:  28 

Levels: 
 None I II III IV V VI VII VIII IX X XI XII XIII XIV XV XVI XVII XVIII XIX XXI patient.follow-up medical.consultation blood.donation laboratory.exam unjustified.absence physiotherapy dental.consultation



[1] "Best tuned Linear SVM Model Train Accuracy: 0.698816"
[1] "Best tuned Linear SVM Model Test Accuracy: 0.476510"



 Tuning SVM Radial:

Parameter tuning of 'svm':

- sampling method: 10-fold cross validation 

- best parameters:
 cost
  100

- best performance: 0.5752542 

- Detailed performance results:
   cost     error dispersion
1 1e-03 0.7985311 0.05815533
2 1e-02 0.7985311 0.05815533
3 1e-01 0.7985311 0.05815533
4 1e+00 0.6598305 0.02894123
5 5e+00 0.5990113 0.04561003
6 1e+01 0.5955367 0.04011472
7 1e+02 0.5752542 0.05703809



   Best tuned Radial SVM Model by Tuning:

Call:
best.tune(method = svm, train.x = Reason.f. ~ ., data = trainSet, 
    ranges = list(cost = c(0.001, 0.01, 0.1, 1, 5, 10, 100)), 
    kernel = "radial")


Parameters:
   SVM-Type:  C-classification 
 SVM-Kernel:  radial 
       cost:  100 
      gamma:  0.01492537 

Number of Support Vectors:  559

 ( 25 29 114 12 29 32 13 21 15 5 20 81 17 25 2 44 6 44 1 5 6 2 3 2 2 1 1 2 )


Number of Classes:  28 

Levels: 
 None I II III IV V VI VII VIII IX X XI XII XIII XIV XV XVI XVII XVIII XIX XXI patient.follow-up medical.consultation blood.donation laboratory.exam unjustified.absence physiotherapy dental.consultation



[1] "Best tuned Radial SVM Model Train Accuracy: 0.908629"
[1] "Best tuned Radial SVM Model Test Accuracy: 0.476510"
```


Tree
========================================================
id:trees
source: ../Src/Tree.R

Here we used tree based method for multi-class classification by _'Reason for absence'_ feature. First we shuffle data and split it into train and test set.
* First we fit single tree and then we use 5-fold Cross validation to choose be tree size in order to obtain a pruned tree.

* In the next part, we use **C4.5** decision tree algorithm to classify our data.

* Our next method is **Random Forest** algorithm which grows many (1000 in our case) trees to perform prediction. We can choose best model size by changing different size for our trees according to the plot.

* Our final method in tree based methods is **Recursive Partitioning** Algorithm.

## Implementaion

```r
setwd("..")
source("./Src/Tree.R", echo = FALSE)
```


```

Classification tree:
tree(formula = trainData$Reason.f. ~ . - ID.f, data = trainData)
Variables actually used in tree construction:
[1] "Absenteeism.time.in.hours" "Month.f"                  
[3] "Son"                       "Transportation.expense"   
[5] "Social.drinker"            "Weight"                   
[7] "Height"                    "Pet"                      
[9] "Service.time"             
Number of terminal nodes:  13 
Residual mean deviance:  3.031 = 1755 / 579 
Misclassification error rate: 0.5034 = 298 / 592 
```

<img src="Project-figure/unnamed-chunk-27-1.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-27-2.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" width="100%" angle=90 style="display: block; margin: auto;" />

```
[1] "Simple Tree Accuracy on train data: 0.498311"
[1] "Simple Tree Accuracy on test data: 0.330000"
```

<img src="Project-figure/unnamed-chunk-27-3.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" width="100%" angle=90 style="display: block; margin: auto;" />

```
$size
[1] 13 11  8  6  5  4  3  1

$dev
[1] 346 353 359 370 378 378 469 469

$k
[1] -Inf    3    5   11   15   16   31   33

$method
[1] "misclass"

attr(,"class")
[1] "prune"         "tree.sequence"
```

<img src="Project-figure/unnamed-chunk-27-4.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" width="100%" angle=90 style="display: block; margin: auto;" />

```
[1] "Pruned Tree Accuracy on train data: 0.423986"
[1] "Pruned Tree Accuracy on test data: 0.320000"
```

<img src="Project-figure/unnamed-chunk-27-5.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" width="100%" angle=90 style="display: block; margin: auto;" />

```
[1] "C4.5 Tree Alg. Accuracy on train data: 0.726351"
[1] "C4.5 Tree Alg. Accuracy on test data: 0.320000"

Call:
 randomForest(formula = Reason.f. ~ . - ID.f, data = trainData,      ntree = 1000, importance = TRUE, proximity = TRUE) 
               Type of random forest: classification
                     Number of trees: 1000
No. of variables tried at each split: 4

        OOB estimate of  error rate: 49.66%
Confusion matrix:
                     None I VII X XI XIII XIV XVIII XIX patient.follow-up
None                   39 0   0 0  0    0   0     0   0                 0
I                       0 3   1 1  1    1   0     2   0                 2
VII                     0 1   0 0  0    1   1     0   2                 3
X                       0 1   0 2  0    2   0     1   2                 2
XI                      0 1   0 0  2    3   0     0   0                 2
XIII                    0 0   0 1  1   13   3     2   3                 4
XIV                     0 0   1 0  0    3   2     0   0                 2
XVIII                   0 2   0 0  0    4   0     6   3                 0
XIX                     0 1   2 2  1    5   1     0   5                 5
patient.follow-up       0 1   0 2  0    2   1     1   3                16
medical.consultation    0 1   0 1  2    3   3     0   1                 1
laboratory.exam         0 0   0 1  0    0   0     1   1                 0
unjustified.absence     0 1   0 4  0    4   0     1   3                 2
physiotherapy           0 0   0 0  0    0   0     0   0                 0
dental.consultation     0 0   0 0  0    1   0     1   2                 0
                     medical.consultation laboratory.exam
None                                    0               0
I                                       1               0
VII                                     3               2
X                                       3               1
XI                                      6               1
XIII                                    5               0
XIV                                     6               0
XVIII                                   2               3
XIX                                     2               0
patient.follow-up                       3               0
medical.consultation                   75               2
laboratory.exam                         7               6
unjustified.absence                     7               0
physiotherapy                           3               1
dental.consultation                    24               2
                     unjustified.absence physiotherapy dental.consultation
None                                   0             0                   0
I                                      3             0                   0
VII                                    0             0                   1
X                                      5             1                   0
XI                                     1             1                   2
XIII                                   5             7                   2
XIV                                    2             0                   0
XVIII                                  0             0                   1
XIX                                    3             2                   2
patient.follow-up                      2             0                   0
medical.consultation                   3             5                  26
laboratory.exam                        1             2                   6
unjustified.absence                    6             0                   3
physiotherapy                          0            59                   1
dental.consultation                    1             2                  64
                     class.error
None                   0.0000000
I                      0.8000000
VII                    1.0000000
X                      0.9000000
XI                     0.8947368
XIII                   0.7173913
XIV                    0.8750000
XVIII                  0.7142857
XIX                    0.8387097
patient.follow-up      0.4838710
medical.consultation   0.3902439
laboratory.exam        0.7600000
unjustified.absence    0.8064516
physiotherapy          0.0781250
dental.consultation    0.3402062
```

<img src="Project-figure/unnamed-chunk-27-6.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" width="100%" angle=90 style="display: block; margin: auto;" />

```
[1] 0.09610855 0.10034914
```

<img src="Project-figure/unnamed-chunk-27-7.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-27-8.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" width="100%" angle=90 style="display: block; margin: auto;" />

```
[1] "Random Forest Alg. Accuracy on train data: 0.966216"
[1] "Random Forest Alg. Accuracy on test data: 0.450000"
Call:
rpart(formula = y ~ ., data = rpTrain, method = "class")
  n= 592 

           CP nsplit rel error    xerror       xstd
1  0.07947020      0 1.0000000 1.0000000 0.02276656
2  0.05408389      1 0.9205298 0.9205298 0.02450914
3  0.03090508      3 0.8123620 0.8454746 0.02566927
4  0.02649007      4 0.7814570 0.8520971 0.02558399
5  0.01986755      5 0.7549669 0.8278146 0.02588132
6  0.01545254      6 0.7350993 0.8145695 0.02602595
7  0.01324503      8 0.7041943 0.8167770 0.02600269
8  0.01214128      9 0.6909492 0.7947020 0.02622021
9  0.01103753     11 0.6666667 0.7792494 0.02635283
10 0.01000000     13 0.6445916 0.7660044 0.02645384

Variable importance
      x.Absenteeism.time.in.hours            x.Disciplinary.failure 
                               22                                12 
                   x.Service.time                         x.Month.f 
                                8                                 8 
                         x.Weight          x.Transportation.expense 
                                7                                 6 
x.Distance.from.Residence.to.Work                             x.Pet 
                                6                                 6 
                            x.Age                          x.Height 
                                5                                 4 
                 x.Social.drinker                             x.Son 
                                4                                 4 
          x.Work.load.Average.day                      x.Hit.target 
                                3                                 3 

Node number 1: 592 observations,    complexity param=0.0794702
  predicted class=medical.consultation  expected loss=0.7652027  P(node) =1
    class counts:    36    16    11    15    24    46    16    21    29    27   139    28    30    49   105
   probabilities: 0.061 0.027 0.019 0.025 0.041 0.078 0.027 0.035 0.049 0.046 0.235 0.047 0.051 0.083 0.177 
  left son=2 (36 obs) right son=3 (556 obs)
  Primary splits:
      x.Disciplinary.failure      < 0.5      to the right, improve=38.184810, (0 missing)
      x.Absenteeism.time.in.hours < 0.5      to the left,  improve=37.193690, (0 missing)
      x.Month.f                   < 3.5      to the right, improve=14.636150, (0 missing)
      x.Transportation.expense    < 226.5    to the right, improve= 9.665866, (0 missing)
      x.Social.drinker            < 0.5      to the left,  improve= 8.097029, (0 missing)
  Surrogate splits:
      x.Absenteeism.time.in.hours < 0.5      to the left,  agree=0.998, adj=0.972, (0 split)

Node number 2: 36 observations
  predicted class=None                  expected loss=0  P(node) =0.06081081
    class counts:    36     0     0     0     0     0     0     0     0     0     0     0     0     0     0
   probabilities: 1.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 

Node number 3: 556 observations,    complexity param=0.05408389
  predicted class=medical.consultation  expected loss=0.75  P(node) =0.9391892
    class counts:     0    16    11    15    24    46    16    21    29    27   139    28    30    49   105
   probabilities: 0.000 0.029 0.020 0.027 0.043 0.083 0.029 0.038 0.052 0.049 0.250 0.050 0.054 0.088 0.189 
  left son=6 (199 obs) right son=7 (357 obs)
  Primary splits:
      x.Absenteeism.time.in.hours < 6        to the right, improve=30.220130, (0 missing)
      x.Month.f                   < 3.5      to the right, improve=14.626470, (0 missing)
      x.Transportation.expense    < 226.5    to the right, improve= 8.884404, (0 missing)
      x.Social.drinker            < 0.5      to the left,  improve= 8.341359, (0 missing)
      x.Age                       < 33.5     to the left,  improve= 7.471673, (0 missing)
  Surrogate splits:
      x.Transportation.expense          < 315      to the right, agree=0.691, adj=0.136, (0 split)
      x.Service.time                    < 5        to the left,  agree=0.669, adj=0.075, (0 split)
      x.Pet                             < 3        to the right, agree=0.669, adj=0.075, (0 split)
      x.Distance.from.Residence.to.Work < 51.5     to the right, agree=0.658, adj=0.045, (0 split)
      x.Work.load.Average.day           < 336657   to the right, agree=0.658, adj=0.045, (0 split)

Node number 6: 199 observations,    complexity param=0.01986755
  predicted class=XIII                  expected loss=0.8291457  P(node) =0.3361486
    class counts:     0    14     4    14    14    34     7    17    25    24    11     4    23     0     8
   probabilities: 0.000 0.070 0.020 0.070 0.070 0.171 0.035 0.085 0.126 0.121 0.055 0.020 0.116 0.000 0.040 
  left son=12 (185 obs) right son=13 (14 obs)
  Primary splits:
      x.Distance.from.Residence.to.Work < 51.5     to the left,  improve=6.095854, (0 missing)
      x.Service.time                    < 3.5      to the right, improve=5.590725, (0 missing)
      x.Pet                             < 3        to the left,  improve=5.563733, (0 missing)
      x.Transportation.expense          < 345.5    to the left,  improve=5.173986, (0 missing)
      x.Absenteeism.time.in.hours       < 12       to the right, improve=4.033394, (0 missing)
  Surrogate splits:
      x.Service.time < 3.5      to the right, agree=0.995, adj=0.929, (0 split)
      x.Pet          < 3        to the left,  agree=0.960, adj=0.429, (0 split)

Node number 7: 357 observations,    complexity param=0.05408389
  predicted class=medical.consultation  expected loss=0.6414566  P(node) =0.6030405
    class counts:     0     2     7     1    10    12     9     4     4     3   128    24     7    49    97
   probabilities: 0.000 0.006 0.020 0.003 0.028 0.034 0.025 0.011 0.011 0.008 0.359 0.067 0.020 0.137 0.272 
  left son=14 (239 obs) right son=15 (118 obs)
  Primary splits:
      x.Month.f                         < 4.5      to the right, improve=21.084490, (0 missing)
      x.Social.drinker                  < 0.5      to the left,  improve=10.054740, (0 missing)
      x.Son                             < 0.5      to the right, improve=10.020880, (0 missing)
      x.Hit.target                      < 94.5     to the left,  improve= 9.957578, (0 missing)
      x.Distance.from.Residence.to.Work < 49       to the left,  improve= 8.408044, (0 missing)
  Surrogate splits:
      x.Hit.target            < 94.5     to the left,  agree=0.776, adj=0.322, (0 split)
      x.Work.load.Average.day < 307469   to the left,  agree=0.748, adj=0.237, (0 split)
      x.Age                   < 27.5     to the right, agree=0.672, adj=0.008, (0 split)
      x.Weight                < 64       to the right, agree=0.672, adj=0.008, (0 split)

Node number 12: 185 observations,    complexity param=0.01214128
  predicted class=XIII                  expected loss=0.8216216  P(node) =0.3125
    class counts:     0    14     4    13    14    33     7    17    24    14    11     3    23     0     8
   probabilities: 0.000 0.076 0.022 0.070 0.076 0.178 0.038 0.092 0.130 0.076 0.059 0.016 0.124 0.000 0.043 
  left son=24 (28 obs) right son=25 (157 obs)
  Primary splits:
      x.Service.time              < 17.5     to the right, improve=4.932710, (0 missing)
      x.Transportation.expense    < 234      to the left,  improve=3.591403, (0 missing)
      x.Work.load.Average.day     < 214056.5 to the right, improve=3.561607, (0 missing)
      x.Weight                    < 102      to the left,  improve=3.477291, (0 missing)
      x.Absenteeism.time.in.hours < 12       to the right, improve=3.257915, (0 missing)
  Surrogate splits:
      x.Distance.from.Residence.to.Work < 50.5     to the right, agree=0.957, adj=0.714, (0 split)
      x.Age                             < 48.5     to the right, agree=0.865, adj=0.107, (0 split)

Node number 13: 14 observations
  predicted class=patient.follow-up     expected loss=0.2857143  P(node) =0.02364865
    class counts:     0     0     0     1     0     1     0     0     1    10     0     1     0     0     0
   probabilities: 0.000 0.000 0.000 0.071 0.000 0.071 0.000 0.000 0.071 0.714 0.000 0.071 0.000 0.000 0.000 

Node number 14: 239 observations,    complexity param=0.03090508
  predicted class=medical.consultation  expected loss=0.5564854  P(node) =0.4037162
    class counts:     0     2     5     1    10     7     6     3     1     1   106    11     6     1    79
   probabilities: 0.000 0.008 0.021 0.004 0.042 0.029 0.025 0.013 0.004 0.004 0.444 0.046 0.025 0.004 0.331 
  left son=28 (103 obs) right son=29 (136 obs)
  Primary splits:
      x.Social.drinker                  < 0.5      to the left,  improve=9.115584, (0 missing)
      x.Age                             < 33.5     to the left,  improve=6.733577, (0 missing)
      x.Son                             < 3.5      to the left,  improve=6.172567, (0 missing)
      x.Distance.from.Residence.to.Work < 26.5     to the left,  improve=5.881030, (0 missing)
      x.Service.time                    < 9.5      to the left,  improve=5.132862, (0 missing)
  Surrogate splits:
      x.Service.time                    < 10.5     to the left,  agree=0.837, adj=0.621, (0 split)
      x.Distance.from.Residence.to.Work < 26.5     to the left,  agree=0.816, adj=0.573, (0 split)
      x.Age                             < 30.5     to the left,  agree=0.753, adj=0.427, (0 split)
      x.Pet                             < 1.5      to the right, agree=0.724, adj=0.359, (0 split)
      x.Weight                          < 88.5     to the left,  agree=0.715, adj=0.340, (0 split)

Node number 15: 118 observations,    complexity param=0.02649007
  predicted class=physiotherapy         expected loss=0.5932203  P(node) =0.1993243
    class counts:     0     0     2     0     0     5     3     1     3     2    22    13     1    48    18
   probabilities: 0.000 0.000 0.017 0.000 0.000 0.042 0.025 0.008 0.025 0.017 0.186 0.110 0.008 0.407 0.153 
  left son=30 (50 obs) right son=31 (68 obs)
  Primary splits:
      x.Transportation.expense          < 181.5    to the right, improve=12.406940, (0 missing)
      x.Son                             < 0.5      to the right, improve=12.007400, (0 missing)
      x.Distance.from.Residence.to.Work < 50.5     to the left,  improve=10.324190, (0 missing)
      x.Service.time                    < 17.5     to the left,  improve= 8.992375, (0 missing)
      x.Weight                          < 79       to the left,  improve= 8.311996, (0 missing)
  Surrogate splits:
      x.Height < 169.5    to the left,  agree=0.881, adj=0.72, (0 split)
      x.Pet    < 0.5      to the right, agree=0.873, adj=0.70, (0 split)
      x.Age    < 28.5     to the left,  agree=0.805, adj=0.54, (0 split)
      x.Son    < 0.5      to the right, agree=0.805, adj=0.54, (0 split)
      x.Weight < 79       to the left,  agree=0.788, adj=0.50, (0 split)

Node number 24: 28 observations
  predicted class=XIII                  expected loss=0.5  P(node) =0.0472973
    class counts:     0     1     0     2     3    14     0     2     0     0     1     0     1     0     4
   probabilities: 0.000 0.036 0.000 0.071 0.107 0.500 0.000 0.071 0.000 0.000 0.036 0.000 0.036 0.000 0.143 

Node number 25: 157 observations,    complexity param=0.01214128
  predicted class=XIX                   expected loss=0.8471338  P(node) =0.2652027
    class counts:     0    13     4    11    11    19     7    15    24    14    10     3    22     0     4
   probabilities: 0.000 0.083 0.025 0.070 0.070 0.121 0.045 0.096 0.153 0.089 0.064 0.019 0.140 0.000 0.025 
  left son=50 (147 obs) right son=51 (10 obs)
  Primary splits:
      x.Weight                    < 100.5    to the left,  improve=3.887109, (0 missing)
      x.Transportation.expense    < 234      to the left,  improve=3.149808, (0 missing)
      x.Social.drinker            < 0.5      to the left,  improve=3.113738, (0 missing)
      x.Service.time              < 9.5      to the left,  improve=3.064162, (0 missing)
      x.Absenteeism.time.in.hours < 12       to the right, improve=2.953454, (0 missing)

Node number 28: 103 observations
  predicted class=medical.consultation  expected loss=0.4757282  P(node) =0.1739865
    class counts:     0     2     4     1     5     5     4     3     0     0    54     7     4     1    13
   probabilities: 0.000 0.019 0.039 0.010 0.049 0.049 0.039 0.029 0.000 0.000 0.524 0.068 0.039 0.010 0.126 

Node number 29: 136 observations,    complexity param=0.01545254
  predicted class=dental.consultation   expected loss=0.5147059  P(node) =0.2297297
    class counts:     0     0     1     0     5     2     2     0     1     1    52     4     2     0    66
   probabilities: 0.000 0.000 0.007 0.000 0.037 0.015 0.015 0.000 0.007 0.007 0.382 0.029 0.015 0.000 0.485 
  left son=58 (108 obs) right son=59 (28 obs)
  Primary splits:
      x.Weight                          < 67.5     to the right, improve=6.721444, (0 missing)
      x.Month.f                         < 12.5     to the left,  improve=3.308741, (0 missing)
      x.Son                             < 3.5      to the left,  improve=3.250020, (0 missing)
      x.Height                          < 171.5    to the right, improve=3.035225, (0 missing)
      x.Distance.from.Residence.to.Work < 22.5     to the left,  improve=2.803455, (0 missing)
  Surrogate splits:
      x.Son          < 3.5      to the left,  agree=0.934, adj=0.679, (0 split)
      x.Height       < 168.5    to the right, agree=0.904, adj=0.536, (0 split)
      x.Service.time < 11.5     to the right, agree=0.868, adj=0.357, (0 split)

Node number 30: 50 observations,    complexity param=0.01324503
  predicted class=medical.consultation  expected loss=0.68  P(node) =0.08445946
    class counts:     0     0     2     0     0     1     2     0     1     2    16     9     0     4    13
   probabilities: 0.000 0.000 0.040 0.000 0.000 0.020 0.040 0.000 0.020 0.040 0.320 0.180 0.000 0.080 0.260 
  left son=60 (37 obs) right son=61 (13 obs)
  Primary splits:
      x.Social.drinker            < 0.5      to the left,  improve=3.733222, (0 missing)
      x.Absenteeism.time.in.hours < 2.5      to the right, improve=2.338824, (0 missing)
      x.WeekDay.f                 < 4.5      to the left,  improve=2.232381, (0 missing)
      x.Height                    < 171.5    to the right, improve=2.130000, (0 missing)
      x.Weight                    < 67.5     to the right, improve=1.990526, (0 missing)
  Surrogate splits:
      x.Transportation.expense          < 254      to the left,  agree=0.88, adj=0.538, (0 split)
      x.Distance.from.Residence.to.Work < 28.5     to the left,  agree=0.86, adj=0.462, (0 split)
      x.Service.time                    < 10       to the left,  agree=0.84, adj=0.385, (0 split)
      x.Weight                          < 68.5     to the right, agree=0.84, adj=0.385, (0 split)
      x.Age                             < 32.5     to the left,  agree=0.82, adj=0.308, (0 split)

Node number 31: 68 observations
  predicted class=physiotherapy         expected loss=0.3529412  P(node) =0.1148649
    class counts:     0     0     0     0     0     4     1     1     2     0     6     4     1    44     5
   probabilities: 0.000 0.000 0.000 0.000 0.000 0.059 0.015 0.015 0.029 0.000 0.088 0.059 0.015 0.647 0.074 

Node number 50: 147 observations,    complexity param=0.01103753
  predicted class=XIX                   expected loss=0.8435374  P(node) =0.2483108
    class counts:     0    13     4    11    11    17     7    15    23    14    10     3    15     0     4
   probabilities: 0.000 0.088 0.027 0.075 0.075 0.116 0.048 0.102 0.156 0.095 0.068 0.020 0.102 0.000 0.027 
  left son=100 (30 obs) right son=101 (117 obs)
  Primary splits:
      x.Service.time              < 9.5      to the left,  improve=2.807082, (0 missing)
      x.Transportation.expense    < 234      to the right, improve=2.605976, (0 missing)
      x.Absenteeism.time.in.hours < 12       to the right, improve=2.593522, (0 missing)
      x.Work.load.Average.day     < 311062.5 to the right, improve=2.463573, (0 missing)
      x.Age                       < 42       to the left,  improve=2.417622, (0 missing)
  Surrogate splits:
      x.Age                    < 30.5     to the left,  agree=0.959, adj=0.800, (0 split)
      x.Education              < 1.5      to the right, agree=0.871, adj=0.367, (0 split)
      x.Weight                 < 60.5     to the left,  agree=0.857, adj=0.300, (0 split)
      x.Height                 < 176.5    to the right, agree=0.844, adj=0.233, (0 split)
      x.Transportation.expense < 383      to the right, agree=0.810, adj=0.067, (0 split)

Node number 51: 10 observations
  predicted class=unjustified.absence   expected loss=0.3  P(node) =0.01689189
    class counts:     0     0     0     0     0     2     0     0     1     0     0     0     7     0     0
   probabilities: 0.000 0.000 0.000 0.000 0.000 0.200 0.000 0.000 0.100 0.000 0.000 0.000 0.700 0.000 0.000 

Node number 58: 108 observations,    complexity param=0.01545254
  predicted class=medical.consultation  expected loss=0.5462963  P(node) =0.1824324
    class counts:     0     0     1     0     4     2     2     0     1     1    49     4     1     0    43
   probabilities: 0.000 0.000 0.009 0.000 0.037 0.019 0.019 0.000 0.009 0.009 0.454 0.037 0.009 0.000 0.398 
  left son=116 (97 obs) right son=117 (11 obs)
  Primary splits:
      x.Month.f                < 12.5     to the left,  improve=3.878979, (0 missing)
      x.Weight                 < 89.5     to the right, improve=1.812107, (0 missing)
      x.Work.load.Average.day  < 239481.5 to the right, improve=1.636090, (0 missing)
      x.Social.smoker          < 0.5      to the right, improve=1.630741, (0 missing)
      x.Transportation.expense < 295.5    to the right, improve=1.432660, (0 missing)

Node number 59: 28 observations
  predicted class=dental.consultation   expected loss=0.1785714  P(node) =0.0472973
    class counts:     0     0     0     0     1     0     0     0     0     0     3     0     1     0    23
   probabilities: 0.000 0.000 0.000 0.000 0.036 0.000 0.000 0.000 0.000 0.000 0.107 0.000 0.036 0.000 0.821 

Node number 60: 37 observations,    complexity param=0.01103753
  predicted class=medical.consultation  expected loss=0.6216216  P(node) =0.0625
    class counts:     0     0     2     0     0     1     2     0     0     0    14     9     0     4     5
   probabilities: 0.000 0.000 0.054 0.000 0.000 0.027 0.054 0.000 0.000 0.000 0.378 0.243 0.000 0.108 0.135 
  left son=120 (15 obs) right son=121 (22 obs)
  Primary splits:
      x.Work.load.Average.day           < 283417   to the left,  improve=3.337920, (0 missing)
      x.Absenteeism.time.in.hours       < 2.5      to the right, improve=2.560764, (0 missing)
      x.Age                             < 30       to the right, improve=2.154755, (0 missing)
      x.Hit.target                      < 95.5     to the right, improve=2.044150, (0 missing)
      x.Distance.from.Residence.to.Work < 25.5     to the left,  improve=1.707617, (0 missing)
  Surrogate splits:
      x.Hit.target                      < 95.5     to the right, agree=0.784, adj=0.467, (0 split)
      x.Age                             < 30       to the right, agree=0.703, adj=0.267, (0 split)
      x.Transportation.expense          < 226.5    to the right, agree=0.676, adj=0.200, (0 split)
      x.Distance.from.Residence.to.Work < 25.5     to the left,  agree=0.676, adj=0.200, (0 split)
      x.Absenteeism.time.in.hours       < 2.5      to the right, agree=0.676, adj=0.200, (0 split)

Node number 61: 13 observations
  predicted class=dental.consultation   expected loss=0.3846154  P(node) =0.02195946
    class counts:     0     0     0     0     0     0     0     0     1     2     2     0     0     0     8
   probabilities: 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.077 0.154 0.154 0.000 0.000 0.000 0.615 

Node number 100: 30 observations
  predicted class=I                     expected loss=0.8  P(node) =0.05067568
    class counts:     0     6     2     1     6     3     0     4     1     0     5     1     1     0     0
   probabilities: 0.000 0.200 0.067 0.033 0.200 0.100 0.000 0.133 0.033 0.000 0.167 0.033 0.033 0.000 0.000 

Node number 101: 117 observations
  predicted class=XIX                   expected loss=0.8119658  P(node) =0.1976351
    class counts:     0     7     2    10     5    14     7    11    22    14     5     2    14     0     4
   probabilities: 0.000 0.060 0.017 0.085 0.043 0.120 0.060 0.094 0.188 0.120 0.043 0.017 0.120 0.000 0.034 

Node number 116: 97 observations
  predicted class=medical.consultation  expected loss=0.5051546  P(node) =0.1638514
    class counts:     0     0     1     0     4     2     1     0     1     1    48     4     1     0    34
   probabilities: 0.000 0.000 0.010 0.000 0.041 0.021 0.010 0.000 0.010 0.010 0.495 0.041 0.010 0.000 0.351 

Node number 117: 11 observations
  predicted class=dental.consultation   expected loss=0.1818182  P(node) =0.01858108
    class counts:     0     0     0     0     0     0     1     0     0     0     1     0     0     0     9
   probabilities: 0.000 0.000 0.000 0.000 0.000 0.000 0.091 0.000 0.000 0.000 0.091 0.000 0.000 0.000 0.818 

Node number 120: 15 observations
  predicted class=laboratory.exam       expected loss=0.4666667  P(node) =0.02533784
    class counts:     0     0     2     0     0     0     0     0     0     0     3     8     0     1     1
   probabilities: 0.000 0.000 0.133 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.200 0.533 0.000 0.067 0.067 

Node number 121: 22 observations
  predicted class=medical.consultation  expected loss=0.5  P(node) =0.03716216
    class counts:     0     0     0     0     0     1     2     0     0     0    11     1     0     3     4
   probabilities: 0.000 0.000 0.000 0.000 0.000 0.045 0.091 0.000 0.000 0.000 0.500 0.045 0.000 0.136 0.182 
```

<img src="Project-figure/unnamed-chunk-27-9.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" width="100%" angle=90 style="display: block; margin: auto;" />

```
[1] "Recursive Partitioning Tree Alg. Accuracy on train data: 0.506757"
```

<img src="Project-figure/unnamed-chunk-27-10.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" width="100%" angle=90 style="display: block; margin: auto;" />

```
[1] "Recursive Partitioning Tree Alg. Accuracy on test data: 0.270000"
```

## Results
According to what you see on previous part, the accuracy of **Random Forest Algorithm** is better than other tree based methods

Clustering
========================================================
id:clustering
source: ../Src/Clustering.R

In clustering we are trying to find some similarity between data instances in order to make some groups of them. The clustering unlike classification is an unsupervised method.

We have removed our supervised feature _'Reason for Absence'_ from data set to compare the results of Clustering with our supervised classification and as we'll see the results are compeletely irrelevanvt. We also set number of clusters in our clustering method to the number of classes of supervised data:



```r
k = length(unique(levels(data$Reason.f.)))
k
```

```
[1] 28
```

```r
NROW(data)
```

```
[1] 740
```

We apply 3 clustering algorithms to data:
* K-Means
* Hierarchical Clustering (Using single-linkage)
* Model-based Clustering

## Results:


```
K-means clustering with 28 clusters of sizes 21, 32, 32, 31, 62, 24, 32, 20, 15, 15, 21, 19, 22, 15, 32, 18, 35, 22, 6, 29, 26, 36, 37, 19, 18, 6, 91, 4

Cluster means:
   Transportation expense Distance from Residence to Work Service time
1                201.7143                        40.23810     15.23810
2                233.5312                        29.65625     13.84375
3                226.9688                        34.81250     13.71875
4                224.1935                        27.54839     13.41935
5                245.6935                        28.95161     12.58065
6                168.5833                        19.58333      9.87500
7                195.6250                        35.37500     15.09375
8                238.1000                        26.90000     11.45000
9                222.8667                        27.46667     10.40000
10               225.0000                        27.40000     13.40000
11               259.0952                        39.04762     11.47619
12               203.4737                        32.73684     14.00000
13               223.2727                        28.36364     14.54545
14               192.0667                        31.13333     14.86667
15               214.0625                        21.15625     12.00000
16               222.7778                        29.61111     12.77778
17               205.3714                        25.34286     10.17143
18               213.8636                        31.31818     12.59091
19               293.5000                        29.16667     12.16667
20               224.8276                        30.34483     12.06897
21               225.1538                        28.19231     11.07692
22               218.8333                        24.38889     11.16667
23               212.7027                        32.05405     12.75676
24               233.9474                        35.42105     14.57895
25               243.8889                        28.22222     10.16667
26               172.5000                        25.16667     11.50000
27               219.0000                        30.36264     12.46154
28               327.0000                        35.25000     10.25000
        Age Work load Average/day Hit target Disciplinary failure
1  37.00000              251818.0   96.00000           0.00000000
2  37.81250              378217.0   93.00000           0.12500000
3  37.50000              239495.1   97.40625           0.03125000
4  37.61290              327732.6   97.41935           0.03225806
5  35.85484              283520.0   94.82258           0.06451613
6  33.16667              308593.0   95.00000           0.00000000
7  39.00000              222196.0   99.00000           0.00000000
8  36.85000              230290.0   92.00000           0.00000000
9  35.06667              261306.0   97.00000           0.00000000
10 37.93333              249797.0   93.00000           0.00000000
11 36.04762              205917.0   92.00000           0.00000000
12 36.94737              236629.0   93.00000           0.00000000
13 39.36364              244387.0   98.00000           0.18181818
14 36.00000              313532.0   96.00000           0.00000000
15 36.75000              237656.0   99.00000           0.06250000
16 35.16667              306345.0   93.00000           0.00000000
17 35.34286              275190.9   96.91429           0.08571429
18 36.36364              241476.0   92.00000           0.22727273
19 38.00000              261756.0   87.00000           0.00000000
20 34.68966              343253.0   95.00000           0.00000000
21 35.61538              268830.5   93.23077           0.11538462
22 35.25000              246192.9   94.55556           0.00000000
23 36.32432              253717.6   94.02703           0.05405405
24 39.52632              294217.0   81.00000           0.21052632
25 33.33333              302585.0   99.00000           0.00000000
26 32.83333              261756.0   87.00000           0.00000000
27 36.96703              264802.3   93.10989           0.07692308
28 31.25000              222196.0   99.00000           0.00000000
   Education       Son Social drinker Social smoker       Pet   Weight
1   1.000000 0.4761905      0.8571429    0.04761905 0.2857143 81.14286
2   1.093750 0.8750000      0.7187500    0.09375000 0.8125000 82.75000
3   1.125000 1.4375000      0.8125000    0.06250000 0.3437500 81.75000
4   1.129032 1.3225806      0.7096774    0.06451613 0.8064516 83.06452
5   1.241935 1.1451613      0.4838710    0.06451613 1.0161290 76.74194
6   1.083333 0.5000000      0.1250000    0.00000000 0.5833333 77.37500
7   1.312500 0.6562500      0.5312500    0.03125000 0.4062500 79.68750
8   1.200000 1.0500000      0.6000000    0.15000000 0.8000000 77.80000
9   1.133333 1.2000000      0.4000000    0.00000000 1.2000000 76.93333
10  1.333333 0.9333333      0.6000000    0.13333333 0.2666667 78.86667
11  1.142857 1.1904762      0.7142857    0.19047619 1.5714286 83.23810
12  1.421053 0.8421053      0.6842105    0.05263158 0.3157895 82.73684
13  1.318182 1.1363636      0.7272727    0.09090909 0.5454545 80.54545
14  1.933333 0.8000000      0.3333333    0.26666667 0.2000000 72.80000
15  1.906250 1.0312500      0.4687500    0.15625000 0.7187500 78.81250
16  1.111111 1.4444444      0.5000000    0.11111111 0.9444444 76.00000
17  1.485714 0.7714286      0.4857143    0.11428571 1.1714286 78.85714
18  1.000000 1.2727273      0.6363636    0.00000000 0.4545455 79.81818
19  1.000000 1.1666667      0.8333333    0.00000000 1.0000000 73.83333
20  1.241379 1.6551724      0.5172414    0.20689655 0.6206897 72.00000
21  1.115385 0.8461538      0.5000000    0.00000000 1.2307692 82.30769
22  1.666667 1.0555556      0.3055556    0.08333333 0.7500000 74.38889
23  1.189189 0.8108108      0.5945946    0.00000000 0.5945946 79.37838
24  1.000000 0.8421053      1.0000000    0.00000000 0.3684211 84.57895
25  1.222222 0.8888889      0.2777778    0.00000000 0.7222222 72.88889
26  1.666667 0.5000000      0.3333333    0.00000000 0.3333333 74.66667
27  1.417582 1.0109890      0.5934066    0.05494505 0.8571429 80.35165
28  1.000000 2.0000000      1.0000000    0.00000000 1.5000000 82.50000
     Height Absenteeism time in hours   Month.f WeekDay.f
1  170.6667                  5.047619  3.000000  3.333333
2  175.3125                  8.812500  6.500000  2.687500
3  172.0625                  9.468750  6.781250  3.062500
4  174.6452                  8.645161  3.935484  3.161290
5  171.2903                  7.612903 11.838710  2.919355
6  171.7917                  2.500000  2.000000  2.750000
7  170.8125                  7.156250  4.000000  2.781250
8  171.2500                 10.200000  8.000000  2.850000
9  170.4667                 11.800000 13.000000  3.533333
10 171.1333                  5.066667  9.000000  2.333333
11 170.5714                  6.666667  9.000000  2.666667
12 171.3684                  3.631579 13.000000  2.473684
13 171.9545                  5.772727  4.000000  3.045455
14 172.3333                  5.866667  2.000000  3.200000
15 176.0312                  7.312500  6.000000  3.156250
16 172.3333                  8.944444 12.000000  3.111111
17 175.3429                  6.714286  7.457143  3.171429
18 171.0455                  4.000000 10.000000  2.590909
19 169.5000                  3.500000 10.000000  2.833333
20 171.3793                  9.689655  4.000000  2.827586
21 171.2308                  4.115385 10.730769  3.115385
22 171.7500                  5.250000  5.444444  2.722222
23 170.7297                  5.297297  8.945946  2.891892
24 170.1053                  8.578947 10.000000  3.052632
25 172.8333                  4.833333  3.000000  2.944444
26 174.8333                  3.333333 10.000000  2.333333
27 171.8242                  6.736264  7.307692  2.890110
28 171.2500                 32.000000  4.000000  2.000000

Clustering vector:
  [1]  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3 11 11 11 11
 [24] 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 18 18 18 18 18 18
 [47] 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 23 23 23 23 23 23 23
 [70] 23 23 23 23 23 23 23 23 23 23 23 16 16 16 16 16 16 16 16 16 16 16 16
 [93] 16 16 16 16 16 16  9  9  9  9  9  9  9  9  9  9  9  9  9  9  9  6  6
[116]  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6 25
[139] 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 20 20 20 20 20 20
[162] 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
[185]  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  2  2  2
[208]  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2
[231]  2  2  2  2  2  2 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 27
[254] 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 24 24 24 24 24 24
[277] 24 24 24 24 24 24 24 24 24 24 24 24 24 27 27 27 27 27 27 27 27 27 27
[300] 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27  5  5  5  5  5
[323]  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5 12 12 12 12 12 12
[346] 12 12 12 12 12 12 12 12 12 12 12 12 12  4  4  4  4  4  4  4  4  4  4
[369]  4  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1 13
[392] 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13  3  3
[415]  3  3  3  3  3  3  3  3  3  3  3 22 22 22 22 22 22 22 22 22 22 22 22
[438] 22 22 22 22 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23
[461]  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8 10 10 10
[484] 10 10 10 10 10 10 10 10 10 10 10 10 19 19 26 26 19 26 19 26 26 26 19
[507] 19  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5
[530]  5  5  5 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21
[553] 21 21 21  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5 14 14 14 14 14
[576] 14 14 14 14 14 14 14 14 14 14 27 27 27 27 27 27 27 27 27 27 27 27 27
[599] 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27  7  7  7
[622]  7  7  7  7  7  7  7  7 28  7  7  7  7  7  7  7  7  7 28  7  7  7  7
[645]  7  7  7  7  7  7  7  7 28 28 22 22 22 22 22 22 22 22 22 22 22 22 22
[668] 22 22 22 22 22 22 22 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
[691] 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 17 17 17 17 17 17 17
[714] 17 17 17 17 17 17 17 17 17 17 17 17 27 27 27 27 27 27 27 27 27 27 27
[737] 27 21 21 21

Within cluster sum of squares by cluster:
 [1]     47307.81  14480214.69    350094.25  92576566.77 182884659.16
 [6]     86546.00     59105.91    106786.50     97942.93     63410.40
[11]     87743.71     50418.95    148257.50     31250.27    174419.25
[16]     46973.17    686007.43    107450.09     18353.50     69966.62
[21]  19521026.88    620742.94   2394316.22     58771.05     96625.22
[26]      9403.00  24156664.51     13719.00
 (between_SS / total_SS = 100.0 %)

Available components:

[1] "cluster"      "centers"      "totss"        "withinss"    
[5] "tot.withinss" "betweenss"    "size"         "iter"        
[9] "ifault"      
```

<img src="Project-figure/unnamed-chunk-30-1.png" title="plot of chunk unnamed-chunk-30" alt="plot of chunk unnamed-chunk-30" width="100%" angle=90 style="display: block; margin: auto;" /><img src="Project-figure/unnamed-chunk-30-2.png" title="plot of chunk unnamed-chunk-30" alt="plot of chunk unnamed-chunk-30" width="100%" angle=90 style="display: block; margin: auto;" />

```
   Transportation expense Distance from Residence to Work Service time
1                201.7143                        40.23810     15.23810
2                233.5312                        29.65625     13.84375
3                226.9688                        34.81250     13.71875
4                224.1935                        27.54839     13.41935
5                245.6935                        28.95161     12.58065
6                168.5833                        19.58333      9.87500
7                195.6250                        35.37500     15.09375
8                238.1000                        26.90000     11.45000
9                222.8667                        27.46667     10.40000
10               225.0000                        27.40000     13.40000
11               259.0952                        39.04762     11.47619
12               203.4737                        32.73684     14.00000
13               223.2727                        28.36364     14.54545
14               192.0667                        31.13333     14.86667
15               214.0625                        21.15625     12.00000
16               222.7778                        29.61111     12.77778
17               205.3714                        25.34286     10.17143
18               213.8636                        31.31818     12.59091
19               293.5000                        29.16667     12.16667
20               224.8276                        30.34483     12.06897
21               225.1538                        28.19231     11.07692
22               218.8333                        24.38889     11.16667
23               212.7027                        32.05405     12.75676
24               233.9474                        35.42105     14.57895
25               243.8889                        28.22222     10.16667
26               172.5000                        25.16667     11.50000
27               219.0000                        30.36264     12.46154
28               327.0000                        35.25000     10.25000
        Age Work load Average/day Hit target Disciplinary failure
1  37.00000              251818.0   96.00000           0.00000000
2  37.81250              378217.0   93.00000           0.12500000
3  37.50000              239495.1   97.40625           0.03125000
4  37.61290              327732.6   97.41935           0.03225806
5  35.85484              283520.0   94.82258           0.06451613
6  33.16667              308593.0   95.00000           0.00000000
7  39.00000              222196.0   99.00000           0.00000000
8  36.85000              230290.0   92.00000           0.00000000
9  35.06667              261306.0   97.00000           0.00000000
10 37.93333              249797.0   93.00000           0.00000000
11 36.04762              205917.0   92.00000           0.00000000
12 36.94737              236629.0   93.00000           0.00000000
13 39.36364              244387.0   98.00000           0.18181818
14 36.00000              313532.0   96.00000           0.00000000
15 36.75000              237656.0   99.00000           0.06250000
16 35.16667              306345.0   93.00000           0.00000000
17 35.34286              275190.9   96.91429           0.08571429
18 36.36364              241476.0   92.00000           0.22727273
19 38.00000              261756.0   87.00000           0.00000000
20 34.68966              343253.0   95.00000           0.00000000
21 35.61538              268830.5   93.23077           0.11538462
22 35.25000              246192.9   94.55556           0.00000000
23 36.32432              253717.6   94.02703           0.05405405
24 39.52632              294217.0   81.00000           0.21052632
25 33.33333              302585.0   99.00000           0.00000000
26 32.83333              261756.0   87.00000           0.00000000
27 36.96703              264802.3   93.10989           0.07692308
28 31.25000              222196.0   99.00000           0.00000000
   Education       Son Social drinker Social smoker       Pet   Weight
1   1.000000 0.4761905      0.8571429    0.04761905 0.2857143 81.14286
2   1.093750 0.8750000      0.7187500    0.09375000 0.8125000 82.75000
3   1.125000 1.4375000      0.8125000    0.06250000 0.3437500 81.75000
4   1.129032 1.3225806      0.7096774    0.06451613 0.8064516 83.06452
5   1.241935 1.1451613      0.4838710    0.06451613 1.0161290 76.74194
6   1.083333 0.5000000      0.1250000    0.00000000 0.5833333 77.37500
7   1.312500 0.6562500      0.5312500    0.03125000 0.4062500 79.68750
8   1.200000 1.0500000      0.6000000    0.15000000 0.8000000 77.80000
9   1.133333 1.2000000      0.4000000    0.00000000 1.2000000 76.93333
10  1.333333 0.9333333      0.6000000    0.13333333 0.2666667 78.86667
11  1.142857 1.1904762      0.7142857    0.19047619 1.5714286 83.23810
12  1.421053 0.8421053      0.6842105    0.05263158 0.3157895 82.73684
13  1.318182 1.1363636      0.7272727    0.09090909 0.5454545 80.54545
14  1.933333 0.8000000      0.3333333    0.26666667 0.2000000 72.80000
15  1.906250 1.0312500      0.4687500    0.15625000 0.7187500 78.81250
16  1.111111 1.4444444      0.5000000    0.11111111 0.9444444 76.00000
17  1.485714 0.7714286      0.4857143    0.11428571 1.1714286 78.85714
18  1.000000 1.2727273      0.6363636    0.00000000 0.4545455 79.81818
19  1.000000 1.1666667      0.8333333    0.00000000 1.0000000 73.83333
20  1.241379 1.6551724      0.5172414    0.20689655 0.6206897 72.00000
21  1.115385 0.8461538      0.5000000    0.00000000 1.2307692 82.30769
22  1.666667 1.0555556      0.3055556    0.08333333 0.7500000 74.38889
23  1.189189 0.8108108      0.5945946    0.00000000 0.5945946 79.37838
24  1.000000 0.8421053      1.0000000    0.00000000 0.3684211 84.57895
25  1.222222 0.8888889      0.2777778    0.00000000 0.7222222 72.88889
26  1.666667 0.5000000      0.3333333    0.00000000 0.3333333 74.66667
27  1.417582 1.0109890      0.5934066    0.05494505 0.8571429 80.35165
28  1.000000 2.0000000      1.0000000    0.00000000 1.5000000 82.50000
     Height Absenteeism time in hours   Month.f WeekDay.f
1  170.6667                  5.047619  3.000000  3.333333
2  175.3125                  8.812500  6.500000  2.687500
3  172.0625                  9.468750  6.781250  3.062500
4  174.6452                  8.645161  3.935484  3.161290
5  171.2903                  7.612903 11.838710  2.919355
6  171.7917                  2.500000  2.000000  2.750000
7  170.8125                  7.156250  4.000000  2.781250
8  171.2500                 10.200000  8.000000  2.850000
9  170.4667                 11.800000 13.000000  3.533333
10 171.1333                  5.066667  9.000000  2.333333
11 170.5714                  6.666667  9.000000  2.666667
12 171.3684                  3.631579 13.000000  2.473684
13 171.9545                  5.772727  4.000000  3.045455
14 172.3333                  5.866667  2.000000  3.200000
15 176.0312                  7.312500  6.000000  3.156250
16 172.3333                  8.944444 12.000000  3.111111
17 175.3429                  6.714286  7.457143  3.171429
18 171.0455                  4.000000 10.000000  2.590909
19 169.5000                  3.500000 10.000000  2.833333
20 171.3793                  9.689655  4.000000  2.827586
21 171.2308                  4.115385 10.730769  3.115385
22 171.7500                  5.250000  5.444444  2.722222
23 170.7297                  5.297297  8.945946  2.891892
24 170.1053                  8.578947 10.000000  3.052632
25 172.8333                  4.833333  3.000000  2.944444
26 174.8333                  3.333333 10.000000  2.333333
27 171.8242                  6.736264  7.307692  2.890110
28 171.2500                 32.000000  4.000000  2.000000
  [1]  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3 11 11 11 11
 [24] 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 18 18 18 18 18 18
 [47] 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 23 23 23 23 23 23 23
 [70] 23 23 23 23 23 23 23 23 23 23 23 16 16 16 16 16 16 16 16 16 16 16 16
 [93] 16 16 16 16 16 16  9  9  9  9  9  9  9  9  9  9  9  9  9  9  9  6  6
[116]  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6  6 25
[139] 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 20 20 20 20 20 20
[162] 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
[185]  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  2  2  2
[208]  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2
[231]  2  2  2  2  2  2 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 27
[254] 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 24 24 24 24 24 24
[277] 24 24 24 24 24 24 24 24 24 24 24 24 24 27 27 27 27 27 27 27 27 27 27
[300] 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27  5  5  5  5  5
[323]  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5 12 12 12 12 12 12
[346] 12 12 12 12 12 12 12 12 12 12 12 12 12  4  4  4  4  4  4  4  4  4  4
[369]  4  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1 13
[392] 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13  3  3
[415]  3  3  3  3  3  3  3  3  3  3  3 22 22 22 22 22 22 22 22 22 22 22 22
[438] 22 22 22 22 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23
[461]  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8 10 10 10
[484] 10 10 10 10 10 10 10 10 10 10 10 10 19 19 26 26 19 26 19 26 26 26 19
[507] 19  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5
[530]  5  5  5 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21
[553] 21 21 21  5  5  5  5  5  5  5  5  5  5  5  5  5  5  5 14 14 14 14 14
[576] 14 14 14 14 14 14 14 14 14 14 27 27 27 27 27 27 27 27 27 27 27 27 27
[599] 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27  7  7  7
[622]  7  7  7  7  7  7  7  7 28  7  7  7  7  7  7  7  7  7 28  7  7  7  7
[645]  7  7  7  7  7  7  7  7 28 28 22 22 22 22 22 22 22 22 22 22 22 22 22
[668] 22 22 22 22 22 22 22 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
[691] 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 17 17 17 17 17 17 17
[714] 17 17 17 17 17 17 17 17 17 17 17 17 27 27 27 27 27 27 27 27 27 27 27
[737] 27 21 21 21
 [1] 21 32 32 31 62 24 32 20 15 15 21 19 22 15 32 18 35 22  6 29 26 36 37
[24] 19 18  6 91  4




 Hierarchical Clustering
    Calculating distances            Length Class  Mode     
merge       1478   -none- numeric  
height       739   -none- numeric  
order        740   -none- numeric  
labels         0   -none- NULL     
method         1   -none- character
call           3   -none- call     
dist.method    1   -none- character
```

<img src="Project-figure/unnamed-chunk-30-3.png" title="plot of chunk unnamed-chunk-30" alt="plot of chunk unnamed-chunk-30" width="100%" angle=90 style="display: block; margin: auto;" />

```




 Model-Based Clustering 

---------------------------------------------------- 
Gaussian finite mixture model fitted by EM algorithm 
---------------------------------------------------- 

Mclust VEV (ellipsoidal, equal shape) model with 4 components: 

 log.likelihood   n  df       BIC       ICL
      -26824.09 740 635 -57843.41 -57843.41

Clustering table:
  1   2   3   4 
439 112 134  55 
```

<img src="Project-figure/unnamed-chunk-30-4.png" title="plot of chunk unnamed-chunk-30" alt="plot of chunk unnamed-chunk-30" width="100%" angle=90 style="display: block; margin: auto;" />

```
---------------------------------------------------- 
Gaussian finite mixture model fitted by EM algorithm 
---------------------------------------------------- 

Mclust EII (spherical, equal volume) model with 28 components: 

 log.likelihood   n  df       BIC       ICL
        -104261 740 504 -211851.8 -212173.4

Clustering table:
 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 
20  0 57  0 32  0 22  0 75 27  0 51 47 36 15 21  0 35 91 15 23 37 60 19  0 
26 27 28 
 0 54  3 
```

<img src="Project-figure/unnamed-chunk-30-5.png" title="plot of chunk unnamed-chunk-30" alt="plot of chunk unnamed-chunk-30" width="100%" angle=90 style="display: block; margin: auto;" />

