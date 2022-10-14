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



annotation_row = data.frame(
  Function_Classification = c("Glucogenesis", "Oxidative phosphorylation", "Glycolysis","Glycolysis",
                              "Glucose transport","Glucose transport","Glycogenolysis","Glucose transport",
                              "Glycolysis","Glycolysis","Glucose transport","Glycolysis",
                              "Glycolysis","Glucose transport","Oxidative phosphorylation","Oxidative phosphorylation",
                              "Glycolysis","Glycolysis","Glycogen biosynthesis"),
  row.names = rownames(new_data))

new_data2 <- merge(new_data,annotation_row,by="row.names",all = T)
row.names(new_data2)<-new_data2[,1]
new_data2<- new_data2[,2:4]
#ordering
library(dplyr)
new_data2<-arrange(new_data2, Function_Classification)

#install colorRampPalette related package
install.packages('dichromat')
library('dichromat')

#ann_colors
ann_colors<- list(
  Function_Classification = c("Glucogenesis"= "#fef0d9", "Glucose transport"="#fdd49e",
                              "Glycogen biosynthesis"="#fdbb84","Glycogenolysis"="#fc8d59",
                              "Glycolysis"="#e34a33","Oxidative phosphorylation"="#b30000"))


pheatmap(new_data2[,1:2],cluster_rows=F, cluster_cols=FALSE,na_col = "grey90",
         scale="column",
         color = colorRampPalette(c("#fff7f3", "#fa9fb5", "#7a0177"))(50),
         display_numbers = TRUE,
         angle_col = "45",
         border_color = "white",
         cellwidth = 20, cellheight = 20,
         gaps_row =c(6,16) ,gaps_col = c(1,2),
         fontsize_number = 6,
         #annotation_row = annotation_row,
         #annotation_colors = ann_colors
         )

