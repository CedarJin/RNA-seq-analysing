rm(list=ls())
getwd()
data<- read.csv("energy.csv", header=T)
install.packages("pheatmap")
library(pheatmap)

packageVersion("pheatmap")
# [1] ‘1.0.12’


new_data <- data[,3:4]

library(tidyr)
row<-unite(data,"gene",X,X.1,sep=",  ", remove = F)
new_data <- row[,4:5]
rownames(new_data)<- row[,1]
pheatmap(new_data,cluster_rows=FALSE, cluster_cols=FALSE,na_col = "grey90",
         scale="column",
         color = colorRampPalette(c("#fff7f3", "#fa9fb5", "#7a0177"))(50),
         display_numbers = TRUE,
         angle_col = "45",
         border_color = "white",
         cellwidth = 20, cellheight = 20,
         gaps_row = c(6,16),gaps_col = c(1,2),
         fontsize_number = 6,
         )

install.packages('dichromat')
library('dichromat')
