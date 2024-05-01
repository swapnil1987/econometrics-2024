---
title: "Microeconometrics Module"
subtitle: "Lecture 3: Endogeneity"
author: "Swapnil Singh"
date: "Lietuvos Bankas and KTU <br> [Course Link](https://github.com/swapnil1987/econometrics-2024)"
output: 
 beamer_presentation:
   theme: "metropolis"
---

## Simple Linear Regression


- Assume that there are two variables -- $y$ and $x$ -- and we are interested in understanding the relationship between them
 - $y =$ wage and, $x = $ education 
 - $y =$ diabetes and, $x =$ whether smoking or not
- More importantly, we are interested in knowing whether $x$ has a **causal** effect on $y$
- Three things to consider:
 1. How to allow other factors to affect $y$?
 2. What is the functional relationship between $y$ and $x$?
 3. Under which conditions we can claim causality?
 
 
---

## Simple Linear Regrssion

- Bite the bullet and write:
 $$ y = \beta_0 + \beta_1 x + u $$
 where $u$ is the error term
 
- Essentially, we are saying that
    - Other factors affect $y$ additively
    - Parametric relationship is linear
- Note that even though parametric relationship is linear, it can capture non-linear relationship between $y$ and $x$

---

## Causality


- But still there is an open question about causality
- For this, we put structure on the relationship between $x$ and $u$

- Two assumptions: (1) $\mathbb E(u) = 0$, and (2) $\mathbb E(u|x) = \mathbb E(u) = 0$
- The first assumption is innoccuous 
- The second assumption is the most important
- The violation of second assumption implies endogeneity problem, and we cannot claim causal effect. Why?


---

## Causality

![](figures/dag_simple_regression.pdf){width=80%}


---

## Example: Omitted Variable Bias



```r
#preliminaries (just FYI, as I am displaying code for the first time)
rm(list=ls())
gc()
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
Sys.setenv(lang='en')

if(!require(pacman)){
  install.packages('pacman')
}

p_load(tidyverse)
```


---

## Example: Omitted Variable Bias


```r
# Setting up the data
set.seed(123)
N <- 1000
X1 <- rnorm(N, 50, 10) # Explanatory variable
U <- rnorm(N, 0, 5)   # Unobserved variable 
X2 <- 0.5 * X1 + rnorm(N,1,6)     # Another explanatory variable
Y <- 2 + 1 * X1 + 1.5 * X2 + U # Outcome variable

# Naive Regression (omitting X2)
naive_model <- lm(Y ~ X1)
summary(naive_model)
```

```
## 
## Call:
## lm(formula = Y ~ X1)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -29.922  -6.794  -0.064   6.625  38.190 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  2.18393    1.67480   1.304    0.193    
## X1           1.77686    0.03275  54.247   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 10.27 on 998 degrees of freedom
## Multiple R-squared:  0.7467,	Adjusted R-squared:  0.7465 
## F-statistic:  2943 on 1 and 998 DF,  p-value: < 2.2e-16
```
