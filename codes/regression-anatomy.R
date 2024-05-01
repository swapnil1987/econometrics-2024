####============================================================================
####
####
####
####@Objective      This code illustrates the regression anatomy concept
####
####
####
####
####
####@Author       Swapnil Singh
####
####
####
####============================================================================

rm(list=ls())
gc()
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
cat('\014')
Sys.setenv(lang='en')


if(!require(pacman)) {
  install.packages('pacman')
}


p_load(tidyverse,
       tikzDevice)

# Set seed for reproducibility
set.seed(123)

#simulation parameters 
n = 1000
k = 1


#generate x's
X = NULL
for (ik in 1:k){
     
     X = cbind(X, rnorm(n, mean = 1/ik, sd = 2/ik))
}

#generate the error term
epsilon = rnorm(n, mean = 0, sd = 0.5)




#true vector of coefficients
beta.true = seq(1,k, by=1)


#true data generating process
Y = 1+  X %*% beta.true + epsilon



#===========================================
#beta estimation through matrix manipulation
#===========================================
beta.matrix = lm(Y ~ X)



#=======================================
#beta estimation through anatomy formula
#=======================================
if (k == 1){
     
     beta.cov = cov(X, Y)/var(X)
     print('====================================================')
     print('For the case of single regressor')
     paste('[True, Matrix, Anatomy] =', beta.true, ',', beta.matrix$coefficients[2], ',', beta.cov, sep='  ')
     
} else if (k > 1) {
     
     beta.cov = seq(0,0,length.out=k)
     for (ik in 1:k){
          temp = lm(X[,ik] ~ X[,-ik])$fitted
          temp = X[,ik] - temp
          beta.cov[ik] = cov(Y, temp)/var(temp)
          
     }
     
     print('====================================================')
     print('For the case of multiple regressor')
     print(cbind(beta.true, beta.matrix$coefficients[2:(k+1)], beta.cov))
}


