# Fijo directorio de trabajo
setwd('F:/Documentos/Master Comercio 2021-22')

# Cargo las funciones que voy a utilizar después
source("Funciones_Clust.R")

# Cargo las librerias que me van a hacer falta
paquetes(c("factoextra","cluster","fpc", "clValid"))


#### Primer ejemplo con datos simulados ######

# Fijo semilla
set.seed(123)
# Me invento un vector de medias (centroides) para 4 grupos
medias=matrix(c(0,0,3,3,-3,-3,2.5,-2.5),4,2,byrow=TRUE)

# Voy a generar 100 datos con dos variables con ditribución normal
n=100
puntos=matrix(c(rnorm(n),rnorm(n)),n,2)

# Ahora creo una variable grupo para distinguir
grupos=trunc(runif(n,min=1,max=5))

# 
desloca=matrix(medias[grupos,],n,2)

# Genero las instancias finales con las distribuciones normales centradas en los centroides
puntos=puntos+desloca
plot(puntos,col=grupos)

# CLustering jerárquico
# Lista de métodos de Linkage a comparar
methods <- c("single", "complete", "average", "mcquitty", "ward.D2")

# Genero un bucle para recorrerla, ajustar modelos y pedir información
hclist <- list()
val.hc<-c()
for(i in seq_along(methods)) {
  hc <- hclust(dist(puntos), method = methods[i]) 
  hclist[[i]]<-hc # Lista de modelos jerárquicos
  #Visualización
  print(fviz_dend(hc, k = 4, cex = 0.5, color_labels_by_k = T, rect = T)+ggtitle(paste('Linkage ', methods[i])))
  #Validación interna
  cl<-cutree(hc, k = 4) 
  md.val<-medidasVal(puntos,cl,grupos,methods[i])
  
  # Generar vector de vmedidas de validación
  val.hc<- rbind(val.hc,md.val)#Podemos seleccionar otras medidas en la función medidasVal()
}

names(hclist) <- rownames(val.hc)<-methods # Pongo nombres a los objetos creados

# Validación Interna
dotchart(val.hc[,4], #xlim = c(0.7,1),
         xlab = "wss", main = "Whithin ss",pch = 19)
dotchart(val.hc[,3], #xlim = c(0.7,1),
         xlab = "shi", main = "silhouette",pch = 19)

# Validación externa 
# Genero las clasificaciones para 4 clusters
get_clusters_perf <- function(hc) { cl<-cutree(hc, k = 4) }
var_clusters <- lapply(hclist, get_clusters_perf)

# Aplico la función macthing para poder sacar el valor correcto de accuracy
clusters_performance <- sapply(var_clusters, matching, truth=grupos, k=4, retVar=F)
dotchart(sort(clusters_performance), #xlim = c(0.7,1),
         xlab = "Acc", main = "Accuracy por método de Linkage",pch = 19)


#Parece que funciona mejor el completo o ward en este caso

### Comparación con K-means
km.out=kmeans(puntos,4,nstart=50)
fviz_cluster(km.out, data = data.frame(puntos),  ellipse.type = "convex", palette = "jco",repel = TRUE,
             ggtheme = theme_minimal())

# Pintar solución frente a los datos reales
plot(puntos,col=grupos,cex=1.5)

#Validacion con Accuracy
acc.km<-matching(km.out$cluster,grupos,4)
cat('Accuracy K-means =', acc.km$acc,'\n')

#Calculo las medidas de validación
med.km<-medidasVal(puntos,acc.km$clus,grupos,'K-means')
valT<-rbind(val.hc,med.km)

#Añado el acc de km
clusters_perf<-c(clusters_performance,km=acc.km$acc)

# Una tabla resumen total de validación interna/externa
valT<-cbind(valT,Acc=clusters_perf)
valT


# Intentamos unir fuerzas con método híbrido 
hk.out=hkmeans(puntos,4)
hkmeans_tree(hk.out, cex = 0.6)
fviz_cluster(hk.out, data = puntos,  ellipse.type = "convex", palette = "jco",repel = TRUE,
             ggtheme = theme_minimal())
med.hk<-medidasVal(puntos,hk.out$cluster,hk.out$cluster,'K-means')

# Utilizamos el método por bootstrapping de eclus
ecl<-eclust(puntos)
table(ecl$cluster,grupos)

med.ecl<-medidasVal(puntos,ecl$cluster,ecl$cluster,'eclus')

valT<-rbind(valT,med.hk,med.ecl)
valT

# Comparar Ward con hkmeans
cl<-cutree(hclist$ward.D2, k = 3) 
med.1<-medidasVal(sd.data,cl,hk.out$cluster,'Ward vs hkmeans')
med.2<-medidasVal(sd.data,hk.out$cluster,cl,'Ward vs hkmeans') # Tiene mejores características hkmeans



#### Ejemplo Países ####

# Los datos paises.csv, contienen información sobre 3 indicadores
# (Death_Rate, BIrth_Rate, Infant_Death_Rate) en 97 países. 
# El objetivo es conseguir grupos de países con la mayor homogeneidad interna.

# Lectura datos
paises <- read.table('Datos/paises.R')

# Inspección archivo
str(paises)
head(paises)


# CLustering jerárquico
# Lista de métodos de Linkage a comparar
methods <- c("single", "complete", "average", "mcquitty", "ward.D2")

# Genero un bucle para recorrerla, ajustar modelos y pedir información
hclist <- list()
val.hc<-c()
for(i in seq_along(methods)) {
  hc <- hclust(dist(paises), method = methods[i]) 
  hclist[[i]]<-hc # Lista de modelos jerárquicos
  #Visualización
  print(fviz_dend(hc, k = 3, cex = 0.5, color_labels_by_k = T, rect = T)+ggtitle(paste('Linkage ', methods[i])))
  #Validación interna
  cl<-cutree(hc, k = 3) 
  md.val<-medidasVal(paises,cl,cl,methods[i])
  
  # Generar vector de vmedidas de validación
  val.hc<- rbind(val.hc,md.val)#Podemos seleccionar otras medidas en la función medidasVal()
}

names(hclist) <- rownames(val.hc)<-methods # Pongo nombres a los objetos creados

# Validación Interna
dotchart(val.hc[,4], #xlim = c(0.7,1),
         xlab = "wss", main = "Whithin ss",pch = 19)
dotchart(val.hc[,3], #xlim = c(0.7,1),
         xlab = "shi", main = "silhouette",pch = 19)



#Parece que funciona mejor el average o ward en este caso

### Comparación con K-means
km.out=kmeans(paises,3,nstart=50)
fviz_cluster(km.out, data = paises,  ellipse.type = "convex", palette = "jco",repel = TRUE,
             ggtheme = theme_minimal())

# Pintar solución frente a los datos reales
rgl::plot3d(paises, col=km.out$cluster)
rgl::text3d(paises,texts=rownames(paises))



#Calculo las medidas de validación
med.km<-medidasVal(paises,km.out$clus,km.out$clus,'K-means')
valT<-rbind(val.hc,med.km)
valT

# Ward y kmeans son los mejores (siendo mismo modelo) 

# Intentamos unir fuerzas con método híbrido 
hk.out=hkmeans(paises,3)
hkmeans_tree(hk.out, cex = 0.6)
fviz_cluster(hk.out, data = puntos,  ellipse.type = "convex", palette = "jco",repel = TRUE,
             ggtheme = theme_minimal())
med.hk<-medidasVal(paises,hk.out$cluster,hk.out$cluster,'K-means')

# Utilizamos el método por bootstrapping de eclus
ecl<-eclust(paises)

ecl$centers
med.ecl<-medidasVal(paises,ecl$cluster,ecl$cluster,'eclus')

valT<-rbind(valT,med.hk,med.ecl)
valT


#######  Datos elecciones   ######

## Lectura de los datos
elec<-readxl::read_excel('Datos/DatosEleccionesEspaña.xlsx')
summary(elec)
colnames(elec)

# Eliminamos los datos perdidos antes de agregar
#elec<-na.omit(elec)
#names(elec)

# Selecciono las variables de % de votos
elec_r<-elec[,c(3,6,8:10)]

# Agregamos datos por CCAA para todos los % por la media y para datos en valor absoluto por la suma
ccaa<-aggregate(.~CCAA,elec_r,mean) # para datos absolutos sum
rownames(ccaa)<-ccaa$CCAA
ccaa<-ccaa[,-1]
head(ccaa)

# Escalamos los datos pues tenemos unidades de medida muy distintas
ccaa.sc<-scale(ccaa) 

# Exploramos clustering jerárquico con distintos Linkages
methods<-c("complete","average",'ward.D2')
hclist<-list()
val.hc<-c()
for (i in 1:length(methods)){
  hc=hclust(dist(ccaa.sc),method =methods[i])
  hclist[[i]]<-hc
 print(fviz_dend(hc,k = 4, cex = 0.5, color_labels_by_k = T, rect = T)+ggtitle(paste('Linkage ', methods[i])))
 #Validación interna
 cl<-cutree(hc, k = 4) 
 md.val<-medidasVal(ccaa.sc,cl,cl,methods[i])
 
 # Generar vector de medidas de validación
 val.hc<- rbind(val.hc,md.val)#Podemos seleccionar otras medidas en la función medidasVal()
}

names(hclist) <- rownames(val.hc)<-methods


# Exploramos k-means con 4 grupos
km.out=kmeans(ccaa.sc,4)
fviz_cluster(km.out, data = ccaa.sc,  ellipse.type = "convex", palette = "jco",repel = TRUE,
             ggtheme = theme_minimal())

# Intentamos unir fuerzas con método híbrido 
hk.out=hkmeans(ccaa.sc,4)

hkmeans_tree(hk.out, cex = 0.6)
fviz_cluster(hk.out, data = ccaa.sc,  ellipse.type = "convex", palette = "jco",repel = TRUE,
             ggtheme = theme_minimal())

## Medidas de validación
md.km<-medidasVal(ccaa.sc,km.out$cluster,km.out$cluster,'kmeans')
md.hk<-medidasVal(ccaa.sc,hk.out$cluster,hk.out$cluster,'hkmeans') ## Son iguales

ValT<-rbind(val.hc,md.km,md.hk) ## Elmismo clustering con varias técnicas
ValT


# Para una mejor interpretabilidad hacemos una
# reducción por componentes principales 
pr.out=prcomp(ccaa.sc, scale. = T)

# Varianza explicada
summary(pr.out)$importance[3,2] # 80,97%

# Ajustamos el cluster jerárquico a la solución de dos componentes
hc.pr=hclust(dist(pr.out$x[ ,1:2]))
fviz_dend(hc.pr,k = 4, cex = 0.5, color_labels_by_k = T, rect = T)+ggtitle("Cluster Jerárquico 2 PC")
cl.hc.pr<-cutree(hc.pr, k = 4) 

km.out.pr=kmeans(pr.out$x[ ,1:2],4)
fviz_cluster(km.out, data = pr.out$x[ ,1:2], 
             ggtheme = theme_minimal())
km.out.pr$centers


## Medidas de validación
md.km<-medidasVal(pr.out$x[ ,1:2],km.out.pr$cluster,km.out.pr$cluster,'kmeans PCA')
md.hk<-medidasVal(pr.out$x[ ,1:2],cl.hc.pr,cl.hc.pr,'hclus PCA') 

ValT<-rbind(md.km,md.hk) ## Un poco mejor el k means
ValT
