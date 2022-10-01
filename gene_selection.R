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
#对Con基因进行富集分析，GO，KEGG
#load包,不一定全都用上

library(ggplot2)#柱状图和点状图
library(enrichplot)#GO,KEGG,GSEA
library(clusterProfiler)#GO,KEGG,GSEA
library(GOplot)#弦图，弦表图，系统聚类图
library(DOSE)
library(ggnewscale)
library(topGO)#绘制通路网络图
library(circlize)#绘制富集分析圈图
library(ComplexHeatmap)#绘制图例

#载入差异表达数据，只需基因ID(GO,KEGG,GSEA需要)和Log2FoldChange(GSEA需要)即可
#指定富集分析的物种库为奶牛
GO_database <- 'org.Bt.eg.db' #GO分析指定物种，物种缩写索引表详见http://bioconductor.org/packages/release/BiocViews.html#___OrgDb
KEGG_database <- 'bta' #KEGG分析指定物种，物种缩写索引表详见http://www.genome.jp/kegg/catalog/org_list.html

GO<-enrichGO( con_gene_HP6$gene_id,#GO富集分析
              OrgDb = GO_database,
              keyType = "ENTREZID",#设定读取的gene ID类型
              ont = "ALL",#(ont为ALL因此包括 Biological Process,Cellular Component,Mollecular Function三部分）
              pvalueCutoff = 0.05,#设定p值阈值
              qvalueCutoff = 0.05,#设定q值阈值
              readable = T)

KEGG<-enrichKEGG(con_gene_HP6$gene_id,#KEGG富集分析
                 organism = KEGG_database,
                 pvalueCutoff = 0.05,
                 qvalueCutoff = 0.05,
                 readable = T)
#可视化GO，KEGG
barplot(GO, split="ONTOLOGY")+facet_grid(ONTOLOGY~., scale="free")#柱状图
barplot(KEGG,showCategory = 40,title = 'KEGG Pathway')

dotplot(GO, split="ONTOLOGY")+facet_grid(ONTOLOGY~., scale="free")#点状图
dotplot(KEGG)


write.table(KEGG$ID, file = "/Users/JYS/Downloads/KEGG_GO/KEGG_IDs.txt", #将所有KEGG富集到的通路写入本地文件查看
            append = FALSE, quote = TRUE, sep = " ",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")
browseKEGG(KEGG,"bta04066")#选择其中的HIF-1 signaling通路进行展示


