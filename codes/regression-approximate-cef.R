####============================================================================
####
####
####
####@Objective      This code illustrates how regression approximates CEF
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
set.seed(1234)



# Simulate data
nsims <- 50
x <- runif(nsims, -3, 3)
y <- (1+rnorm(nsims, mean=2, sd=1))*x + 3*rnorm(nsims)

data <- data.frame(x, y)

# Estimate conditional expectation using LOESS
conditional_expectation <- loess(y ~ x, data, span = 0.5)

# Predict conditional expectations
data$E_y_given_x <- predict(conditional_expectation, newdata = data)

# Fit linear regression
linear_model <- lm(y ~ x, data)
data$linear_fit <- predict(linear_model, newdata = data)

# Plotting
plot <- ggplot(data, aes(x = x)) +
  geom_point(aes(y = y), colour = "red") +
  geom_line(aes(y = E_y_given_x), colour = "blue", size = 1, linetype = 2) +
  geom_line(aes(y = linear_fit), colour = "black", size = 1, linetype = 1) +
  labs(title = "Comparison of Conditional\n Expectation and Linear Regression",
       x = "X", y = "Y") +
  theme_minimal() +
  scale_colour_manual(values = c("Conditional Expectation" = "blue", "Linear Regression" = "red")) +
  theme(plot.title = element_text(face = "bold", size = 20),
        plot.subtitle = element_text(size = 14),
        axis.title = element_text(size = 16),
        axis.text = element_text(size = 12),
        legend.title = element_blank(),
        legend.text = element_text(size = 12),
        #panel.grid.major = element_blank(),  
        #panel.grid.minor = element_blank(),  
        panel.background = element_blank(),  
        axis.line = element_line(color = "black"))  



figure_file = paste0( '../lectures/figures/','regression-approximate-cef.tex')
tikz(figure_file, standAlone = TRUE, width=7, height=7)
par( mai = c(1, 1, 0.5, 1), mar=c(2.5,2.8,1.1,2.5),lwd=0.5,tcl=-0.1,mgp=c(3,0.45,0), cex=1.5)
print(plot)
dev.off()

