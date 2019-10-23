#!/usr/bin/Rscript 


args <- commandArgs(TRUE)
options(encoding = "latin1")

if(length(args)!=1)
{
print('Deve entrar como nome da tabela a ser lida:')
print('Ex.: gera_tabela.R SNE029')
quit()
}

sar=args[1]
wrk.dir <- "/home/operador/grads/sar/tabelas/"
tabela_sar=paste(wrk.dir,"tabela_",sar,".txt",sep="")
#setwd(wrk.dir)
library(DT)
library(data.table)

## LENDO OS ARQUIVOS DAS TABELAS

tab=read.csv2(tabela_sar,h=F,sep=",")

## TRANSPONDO A TABELA

ttab=transpose(tab)
tab=ttab
lat=tab[1,1]
lon=tab[2,1]
tab=tab[-c(1,2),]
nlin=dim(tab)[1]
nlin2=nlin+1

tabnew=matrix(,nlin2,6)

for(j in 1:6){
tabnew[1,j]=tab[1,j]}


tabnew[2,1:6]=c("","Graus-Nos","Graus-Metros","Graus-Nos",
                "Graus Celsius","Graus Celsius")

for(i in 2:nlin){
for(j in 1:6){
tabnew[(i+1),j]=tab[i,j]}}

tab=tabnew[-1,]

res2=datatable(tab,
  caption = htmltools::tags$caption(
    style = 'caption-side: top; text-align: center;', 
    htmltools::em(paste("TABELA"," SAR_",sar," (LAT=",lat," LON=",lon,")",sep=""))), filter="none",
  colnames=c("DATA-HORA","VENTOS","ONDAS","CORRENTES","TEMP AR","TSM"),
  options = list(columnDefs = list(list(className = 'dt-center',targets = 0:5))))

html_sar=paste("SAR_",sar,".html",sep="")
saveWidget(res2,html_sar,FALSE)

