####============================================================================
####
####
####
####@Objective      This code illustrates the concept of law of iterated expectations
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

# Simulate data
data <- data.frame(
  group = sample(c("A", "B"), size = 50000, replace = TRUE, prob = c(0.5, 0.5)),
  value = rnorm(50000)
)

# Adjust values by group to have different expectations
data$value <- ifelse(data$group == "A", data$value + 2, data$value - 2)

# Calculate the overall expected value
overall_expectation <- mean(data$value)

# Calculate conditional expectations E(X | Y)
conditional_expectations <- data |> 
  group_by(group) |> 
  summarise(conditional_mean = mean(value))

# Calculate the expectation of the conditional expectations E(E(X | Y))
expectation_of_conditional <- mean(conditional_expectations$conditional_mean)

# Print the results
print(paste("Overall Expectation E(X):", overall_expectation))
print("Conditional Expectations E(X | Y) for each group:")
print(conditional_expectations)
print(paste("Expectation of Conditional Expectations E(E(X | Y)):", expectation_of_conditional))
