####============================================================================
####
####
####
####@Objective      This code illustrates the concept of endogeneity through 
####                an omitted variable bias problem
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

# Correct Model (including X2)
correct_model <- lm(Y ~ X1 + X2)
summary(correct_model)

stargazer::stargazer(naive_model, correct_model, type='latex')

residuals <- cbind(naive_model$residuals, correct_model$residuals) |> 
  as.data.frame() |> 
  dplyr::mutate(id = seq(1, length(naive_model$residuals))) |> 
  tidyr::pivot_longer(cols = !id,
                      names_to = 'var',
                      values_to = 'value')

plot <- ggplot(data = residuals, aes(x = value,  color = var, linetype=var)) +
  geom_density(linewidth=2) +
  scale_color_manual(labels = c('model with omitted variable', 'model without omitted variable'),
                     values = c('red', 'black')) +
  scale_linetype_manual(labels = c('model with omitted variable', 'model without omitted variable'),
                     values = c(1,2)) +
  labs(
    x = "residuals", y = "") +
  theme_minimal(base_size = 14) +  
  theme(plot.title = element_text(face = "bold", size = 20),
        plot.subtitle = element_text(size = 14),
        axis.title = element_text(size = 16),
        axis.text = element_text(size = 12),
        legend.title = element_blank(),
        legend.position = c(0.75,0.8),
        legend.text = element_text(size = 12),
        #panel.grid.major = element_blank(),  
        #panel.grid.minor = element_blank(),  
        panel.background = element_blank(),  
        axis.line = element_line(color = "black"))  


figure_file = paste0( '../lectures/figures/','ovb-residuals.tex')
tikz(figure_file, standAlone = TRUE, width=7, height=7)
par( mai = c(1, 1, 0.5, 1), mar=c(2.5,2.8,1.1,2.5),lwd=0.5,tcl=-0.1,mgp=c(3,0.45,0), cex=1.5)
print(plot)
dev.off()
