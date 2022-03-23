# Función matching para crear las permutaciones refactorizar 
# la variable cluster estimado de acuerdo a la mayo coincidencia con
# la respuesta o referencia.

# La entrada df consta de :
#   - clus: variable de cluster estimado (hclus, kmeans...)
#   - truth: la verdadera variable u otra clusterización a comparar
#   - k número de clusters

matching<- function(clus,truth,k,retVar=T) {
  #if(!truth){truth=clus}
  per <- gtools::permutations(n = k, r = k, repeats.allowed = FALSE)
  acc<-c()
  cl<-list()
  for (i in 1:nrow(per)) {
    cl[[i]]<-factor(clus, levels = levels(factor(clus))[per[i,]])
    t=table(truth,cl[[i]])
    #print(t)
    acc[i]<-sum(diag(t))/sum(t)
    #acc[i]<-caret::confusionMatrix(cl[[i]],factor(truth))$overall[1]
  }
  
  ind<-which.max(acc)
  if(retVar){
  return(list(acc=acc[ind],clus=as.numeric(cl[[ind]])))
  } else {return(acc[ind])}
}



###### Función para medidas de validación de clustering ####
## Entrada : data=conjunto de datos. clust=variable cluster estimado
##          truth=variable cluster real/otro clustering a comparar
##          method=nombre del método principal a validar (clust)
####
medidasVal<- function(data,clust,truth,method='clustering'){
  st<-cluster.stats(dist(data),  clust, truth)
  #EL famoso indice VI (en la comparación con la referencia)
  cat('Indice VI ',method,'=', st$vi,'\n')
  # Otras medidas de acuerdo para la validación 
  cat('Indice Rand ',method,'=', st$corrected.rand,'\n')
  
  cat('Silueta media ',method,'=', st$avg.silwidth,'\n')
  
  cat('Within SS ',method,'=', st$within.cluster.ss,'\n')
  return(c(vi=st$vi,rand=st$corrected.rand,silhouette=st$avg.silwidth,wss=st$within.cluster.ss))
}
