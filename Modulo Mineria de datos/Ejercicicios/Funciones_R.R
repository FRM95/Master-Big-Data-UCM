# Carga los paquetes de un vector de entrada y los instala si es necesario (hay una opción con una función existente, ver pacman::p_load())
paquetes <- function(x){
  for( i in x ){
    #  require devueleve TRUE (no visible) si se puede cargar el paquete
    if( ! require( i , character.only = TRUE ) ){
      #  En caso negativo lo instala
      install.packages( i , dependencies = TRUE )
      #  Y lo carga
      require( i , character.only = TRUE )
    }
  }
}

# Gráficos de inspección rápida de un dataset. Opción para obtener boxplots
dfplot_box <- function(data.frame, p=2){
#par(mfrow=c(p,p))
  df <- data.frame
  ln <- length(names(data.frame))
  pl<-list()
  for(i in 1:ln){
    if(is.factor(df[,i])){
      b<-barras_cual(df[,i],nombreEje = names(df)[i])
      #print(b)
      } else {
         
          b<-boxplot_cont(df[,i],nombreEje = names(df)[i])}

  pl[[i]]<-b
  }  

return(pl)
}

# Gráficos de inspección rápida de un dataset. Opción para obtener histogramas
dfplot_his <- function(data.frame, p=2){
    #par(mfrow=c(p,p))
  df <- data.frame
  ln <- length(names(data.frame))
  pl<-list()
  for(i in 1:ln){
    if(is.factor(df[,i])){
      b<-barras_cual(df[,i],nombreEje = names(df)[i])
    #print(b)
    } else {
        
      b<-hist_cont(df[,i],nombreEje = names(df)[i])}
        
      pl[[i]]<-b
    }  
    
  return(pl)
}  
  

## Nota: En todos los gráficos se puede cambiar el formato tal como colores (fill=''), 
## tema gráfico (theme_whatever()), nombres de ejes, escalas etc. 

# Diagrama de barras para las variables cuanlitativas 
barras_cual<-function(var,nombreEje){
  dataaux<-data.frame(variable=var)
  ggplot(dataaux, aes(x="All",y = (..count..)/sum(..count..))) +
    geom_bar(aes(var),fill="orchid") + coord_flip()+
    ylab("%")+ xlab(nombreEje)+ theme_light()
}

# Diagrama de cajas para las variables cuantitativas 
boxplot_cont<-function(var,nombreEje){
  dataaux<-data.frame(variable=var)
  ggplot(dataaux,aes(y=variable))+
    geom_boxplot(aes(x=""), fill="yellow") +
    stat_summary(aes(x="") ,fun=mean, geom="point", shape=8) +
    xlab(nombreEje)+ theme_light()+ theme(axis.title.y = element_blank())
}

# Histograma para las variables cuantitativas 
hist_cont<-function(var,nombreEje){
  dataaux<-data.frame(variable=var)
  ggplot(dataaux, aes(x=variable))+
    geom_density(aes(x=variable), fill="orchid") +
    geom_density(lty=1)+ theme(legend.position='none')+
    xlab(nombreEje) +theme_light()
}

# Diagrama de cajas para las variables cuantitativas y variable objetivo binaria
boxplot_targetbinaria<-function(var,target,nombreEje){
  dataaux<-data.frame(variable=var,target=target)
  ggplot(dataaux,aes(y=var))+
    geom_boxplot(aes(x="All"), notch=TRUE, fill="grey") +
    stat_summary(aes(x="All"), fun.y=mean, geom="point", shape=8) +
    geom_boxplot(aes(x=target, fill=target), notch=TRUE) +
    stat_summary(aes(x=target), fun.y=mean, geom="point", shape=8) +
    ylab(nombreEje)
}

# Histograma para las variables cuantitativas y variable objetivo binaria
hist_targetbinaria<-function(var,target,nombreEje){
  dataaux<-data.frame(variable=var,target=target)
  ggplot(dataaux, aes(x=var))+
    geom_density(aes(colour=target, fill=target), alpha=0.5) +
    geom_density(lty=1)+ theme(legend.position='none')+
    xlab(nombreEje)
}

# Gráfico mosaico para las variables cualitativas y variable objetivo binaria
mosaico_targetbinaria<-function(var,target,nombreEje){
  ds <- table(var, target)
  ord <- order(apply(ds, 1, sum), decreasing=TRUE)
  mosaicplot(ds[ord,], color=c("darkturquoise","indianred1"), las=2, main="",xlab=nombreEje)
}

# Gráfico de barras para las variables cualitativas y variable objetivo binaria
barras_targetbinaria<-function(var,target,nombreEje){
  dataaux<-data.frame(variable=var,target=target)
  ggplot(dataaux, aes(x="All",y = (..count..)/sum(..count..))) +
  #geom_bar(aes_string(fill=target))+
    geom_bar(aes(var,fill=target))+
    ylab("Frecuencia relativa")+xlab(nombreEje)
}

# Gráfico correlaciones, código de Rattle  (este gráfico tarda mucho y no suele merecer la pena 
# ya que la mayor parte de la info puede ser observada en un corplot al uso...)
graficoCorrelacion<-function(target,matriz){
  panel.hist <- function(x, ...)
  {
    usr <- par("usr"); on.exit(par(usr))
    par(usr=c(usr[1:2], 0, 1.5) )
    h <- hist(x, plot=FALSE)
    breaks <- h$breaks; nB <- length(breaks)
    y <- h$counts; y <- y/max(y)
    rect(breaks[-nB], 0, breaks[-1], y, col="grey90", ...)
  }
  
  panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...)
  {
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(0, 1, 0, 1))
    r <- (cor(x, y, use="complete"))
    txt <- format(c(r, 0.123456789), digits=digits)[1]
    txt <- paste(prefix, txt, sep="")
    if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
    text(0.5, 0.5, txt)
  }
  
  pairs(cbind(target,Filter(is.numeric, matriz)), 
        diag.panel=panel.hist, 
        upper.panel=panel.smooth, 
        lower.panel=panel.cor)
}

# Cuenta el número de atípicos y los transforma en missings (esta función retorna 2 valores, la variable ya 
# transformada con los outliers como missing y el conteo de outliers para hacerse una idea.
atipicosAmissing<-function(varaux){
  if (abs(skew(varaux))<1){
    criterio1<-abs((varaux-mean(varaux,na.rm=T))/sd(varaux,na.rm=T))>3
  } else {
    criterio1<-abs((varaux-median(varaux,na.rm=T))/mad(varaux,na.rm=T))>8
  }
  qnt <- quantile(varaux, probs=c(.25, .75), na.rm = T)
  H <- 3 * IQR(varaux, na.rm = T)
  criterio2<-(varaux<(qnt[1] - H))|(varaux>(qnt[2] + H))
  varaux[criterio1&criterio2]<-NA
  return(list(varaux,sum(criterio1&criterio2,na.rm=T)))
}

# Borras las observaciones completas si son atípicas
obsAtipicasBorrar<-function(varaux){
  if (abs(skew(varaux))<1){
    criterio1<-abs((varaux-mean(varaux,na.rm=T))/sd(varaux,na.rm=T))>3
  } else {
    criterio1<-abs((varaux-median(varaux,na.rm=T))/mad(varaux,na.rm=T))>8
  }
  qnt <- quantile(varaux, probs=c(.25, .75), na.rm = T)
  H <- 3 * IQR(varaux, na.rm = T)
  criterio2<-(varaux<(qnt[1] - H))|(varaux>(qnt[2] + H))
  !(criterio1&criterio2)
}

# Imputación variables cuantitativas
ImputacionCuant<-function(vv,tipo){#tipo debe tomar los valores media, mediana o aleatorio
  if (tipo=="media"){
    vv[is.na(vv)]<-round(mean(vv,na.rm=T),4)
  } else if (tipo=="mediana"){
    vv[is.na(vv)]<-round(median(vv,na.rm=T),4)
  } else if (tipo=="aleatorio"){
    dd<-density(vv,na.rm=T,from=min(vv,na.rm = T),to=max(vv,na.rm = T))
    vv[is.na(vv)]<-round(approx(cumsum(dd$y)/sum(dd$y),dd$x,runif(sum(is.na(vv))))$y,4)
  }
  vv
}

# Imputación variables cualitativas
ImputacionCuali<-function(vv,tipo){#tipo debe tomar los valores moda o aleatorio
  if (tipo=="moda"){
    vv[is.na(vv)]<-names(sort(table(vv),decreasing = T))[1]
  } else if (tipo=="aleatorio"){
    vv[is.na(vv)]<-sample(vv[!is.na(vv)],sum(is.na(vv)),replace = T)
  }
  factor(vv)
}

# Busca la transformación de variables input de intervalo que maximiza la correlación con la objetivo continua
mejorTransfCorr<-function(vv,target){
  vv<-scale(vv)
  vv<-vv+abs(min(vv,na.rm=T))*1.0001
  posiblesTransf<-data.frame(x=vv,logx=log(vv),expx=exp(vv),sqrx=vv^2,sqrtx=sqrt(vv),cuartax=vv^4,raiz4=vv^(1/4))
  return(list(colnames(posiblesTransf)[which.max(abs(cor(target,posiblesTransf, use="complete.obs")))],posiblesTransf[,which.max(abs(cor(target,posiblesTransf, use="complete.obs")))]))
}

# Calcula el V de Cramer
Vcramer<-function(v,target){
  if (is.numeric(v)){
    v<-cut(v,5)
  }
  if (is.numeric(target)){
    target<-cut(target,5)
  }
  cramer.v(table(v,target))
}

# Busca la transformación de variables input de intervalo que maximiza la V de Cramer con la objetivo binaria
mejorTransfVcramer<-function(vv,target){
  vv<-scale(vv)
  vv<-vv+abs(min(vv,na.rm=T))*1.0001
  posiblesTransf<-data.frame(x=vv,logx=log(vv),expx=exp(vv),sqrx=vv^2,sqrtx=sqrt(vv),cuartax=vv^4,raiz4=vv^(1/4))
  return(list(colnames(posiblesTransf)[which.max(apply(posiblesTransf,2,function(x) Vcramer(x,target)))],posiblesTransf[,which.max(apply(posiblesTransf,2,function(x) Vcramer(x,target)))]))
}

# Detecta el tipo de variable objetivo y busca la mejor transformación de las variables input continuas automáticamente
Transf_Auto<-function(matriz,target){
    if (is.numeric(target)){
    aux<-data.frame(apply(matriz,2,function(x) mejorTransfCorr(x,target)[[2]]))
    aux2<-apply(matriz,2,function(x) mejorTransfCorr(x,target)[[1]])
    names(aux)<-paste0(aux2,names(aux2))
  } else {
    aux<-data.frame(apply(matriz,2,function(x) mejorTransfVcramer(x,target)[[2]]))
    aux2<-apply(matriz,2,function(x) mejorTransfVcramer(x,target)[[1]])   
    names(aux)<-paste0(aux2,names(aux2))
  }
  return(aux)
}

# Gráfico con el V de cramer de todas las variables input para saber su importancia
graficoVcramer<-function(matriz, target){
  salidaVcramer<-sapply(matriz,function(x) Vcramer(x,target))
  barplot(sort(salidaVcramer,decreasing =T),las=2,ylim=c(0,1), cex.names = 0.7)
}

#Para evaluar el R2 en regr. lineal en cualquier conjunto de datos
Rsq<-function(modelo,varObj,datos){
  testpredicted<-predict(modelo, datos)
  testReal<-datos[,varObj]
  sse <- sum((testpredicted - testReal) ^ 2)
  sst <- sum((testReal - mean(testReal)) ^ 2)
  r2 <- 1 - sse/sst
  r2_adj<- r2-(1-r2)*modelo$rank/(nrow(datos)-modelo$rank-1)
  return(list(r2=r2,r2_adj=r2_adj))
}

#Para evaluar el pseudo-R2 en regr. logística en cualquier conjunto de datos
pseudoR2<-function(modelo,dd,nombreVar){
  pred.out.link <- predict(modelo, dd, type = "response")
  mod.out.null <- glm(as.formula(paste(nombreVar,"~1")), family = binomial, data = dd)
  pred.out.linkN <- predict(mod.out.null, dd, type = "response")
  1-sum((dd[,nombreVar]==1)*log(pred.out.link)+log(1 -pred.out.link)*(1-(dd[,nombreVar]==1)))/
    sum((dd[,nombreVar]==1)*log(pred.out.linkN)+log(1 -pred.out.linkN)*(1-(dd[,nombreVar]==1)))
}



#Gráfico con la importancia de las variables en regr. logística
impVariablesLog<-function(modelo,nombreVar,dd=data_train){
  null<-glm(as.formula(paste(nombreVar,"~1")),data=dd,family=binomial)
  aux2<-capture.output(aux<-step(modelo, scope=list(lower=null, upper=modelo), direction="backward",k=0,steps=1))
  aux3<-read.table(textConnection(aux2[grep("-",aux2)]))[,c(2,5)]
  aux3$V5<-(aux3$V5-modelo$deviance)/modelo$null.deviance
  barplot(aux3$V5,names.arg = aux3$V2,las=2,cex.names = 0.6, horiz = T,
          main="Importancia de las variables (Pseudo-R2)")
}

#Calcula medidas de calidad para un punto de corte dado
sensEspCorte<-function(modelo,dd,nombreVar,ptoCorte,evento){
  probs <-predict(modelo,newdata=dd,type="response")
  cm<-confusionMatrix(data=factor(ifelse(probs>ptoCorte,1,0)), reference=dd[,nombreVar],positive=evento)
  c(cm$overall[1],cm$byClass[1:4])
} 

#Generar todas las posibles interacciones
formulaInteracciones<-function(data,posicion){
  listaFactores<-c()
  lista<-paste(names(data)[posicion],'~')
  nombres<-names(data)
  for (i in (1:length(nombres))[-posicion]){
    lista<-paste(lista,nombres[i],'+')
    if (class(data[,i])=="factor"){
      listaFactores<-c(listaFactores,i)
      for (j in ((1:length(nombres))[-c(posicion,listaFactores)])){
        lista<-paste(lista,nombres[i],':',nombres[j],'+')
      }
    }
  }
  lista<-substr(lista, 1, nchar(lista)-1)
  lista
}

# Multiple plot function (Gráficos múltiples en una rejilla gráfica!)
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}