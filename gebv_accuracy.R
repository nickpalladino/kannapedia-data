# GEBV Accuracy Estimate

library(ggplot2)
library(dplyr)

# compute GEBV accuracy
# n - population training size
# h - h^2 narrow-sense heritability
# m - effective number of independent chromosome segments in population

gebv_accuracy <- function(n, h, m) {
  return(sqrt((n*h)/(n*h+m)))
}

population_size <- seq(1,200)
m <- 2*50*30 # TODO: figure out what this should be

h1 <- data.frame(population_size, gebv_accuracy(population_size, 0.1, m))
h2 <- data.frame(population_size, gebv_accuracy(population_size, 0.5, m))
h3 <- data.frame(population_size, gebv_accuracy(population_size, 0.9, m))

cols = c("population_size", "gebv_accuracy")
colnames(h1) = cols
colnames(h2) = cols
colnames(h3) = cols

#combined <- merge(h1, h2, h3, by="population_size")
#combined <- reshape2::melt(combined, id.var='population_size')

combined <- h1 %>%  mutate(Heritability = 'h^2=0.1') %>%
  bind_rows(h2 %>% mutate(Heritability = 'h^2=0.5')) %>%
  bind_rows(h3 %>% mutate(Heritability = 'h^2=0.9'))

ggplot(combined,aes(y = gebv_accuracy, x = population_size, color = Heritability)) + 
  geom_line() +
  xlab("Training Population Size") +
  ylab("GEBV Accuracy") +
  ggtitle("GEBV Accuracy vs Training Size for Multiple Narrow-Sense Heritabilities")
