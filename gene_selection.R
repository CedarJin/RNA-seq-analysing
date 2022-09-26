rm(list = ls())
#set working directory to project location in "session" botton
Hp6 <-read.csv("Hp6_WT.csv", header = T)
Hp24 <-read.csv("Hp24_WT.csv", header = T)
#delete blank rows
Hp6<- Hp6[!(Hp6$class == ""), ]
Hp24<- Hp24[!(Hp24$class == ""), ]
# 取交集
install.packages("dplyr")
library(dplyr)
con_gene <- intersect(Hp6$gene_id,Hp24$gene_id)
con_gene_HP6 <- subset(Hp6, Hp6$gene_id %in% con_gene)
con_gene_HP24 <- subset(Hp24, Hp24$gene_id %in% con_gene)
Speci_gene_HP6 <- Hp6[-which(Hp6$gene_id %in% con_gene),]
Speci_gene_HP24 <- Hp24[-which(Hp24$gene_id %in% con_gene),]
#导出数据
write.csv(con_gene_HP6,file="con_gene_HP6.csv")
write.csv(con_gene_HP24,file="con_gene_HP24.csv")
write.csv(Speci_gene_HP6,file="Speci_gene_HP6.csv")
write.csv(Speci_gene_HP24,file="Speci_gene_HP24.csv")
