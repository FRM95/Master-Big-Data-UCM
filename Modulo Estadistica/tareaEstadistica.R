#Script en R - entrega Modulo estadística
#MASTER UCM - BIG DATA: DATA SCIENCE
#Alumno: Miguel Moreno Mardones
#Fecha: 11/01/2022

#Librerias utilizadas
library("readxl")
library(car)
library(e1071)

#Import del archivo .xlsx
egyptData <- read_excel("C:\Users\.....\Libro1.xlsx")

#Creacion de dataset mediante la union de ambas epocas
predTemprano <- egyptData[(egyptData$`Época histórica`== 1),2]
predTardio <- egyptData[(egyptData$`Época histórica`== 2),2]
datos <- data.frame(predTemprano,predTardio)
columnas <- c("Epoca Temprana", "Epoca Tardia")
colnames(datos) <- columnas


#EJERCICIO 1

#APARTADO a)
#Funciones para obtener las medidas de centralizacion

#moda
mode <- function(x){ 
  ux <- unique(x)
  tab <- tabulate(match(x,ux))
  return(ux[tab == max(tab)])
}

#media, media geometrica, mediana..
medidasCentralizacion <- function(x){ 
  resultado <- list(mean(x),exp(mean(log(x))), median(x), mode(x), min(x), max(x))
  names(resultado) = c("Media", "Media geometrica", "Mediana", "Moda", "Minimo", "Maximo")
  return(resultado)
}

#Cuartiles
medidasNoCentrales <- function(x){
  resultado <- list(quantile(x))
  names(resultado) = c("Cuartiles")
  return(resultado)
}

#Medidas de dispersion
medidasDispersion <- function(x){
  resultado <- list(var(x), sqrt(var(x)), (max(x)-min(x)), sqrt(var(x)/mean(x)))
  names(resultado) = c("Varianza", "Desviacion estandar", "Rango", "Coeficiente de variacion de Pearson")
  return(resultado)
}

#Medidas de asimetria y curtosis
medidasAsimCurt <- function(x){
  resultado <- list(skewness(x, na.rm = TRUE, type = 3), kurtosis(x, na.rm = TRUE, type=3))
  names(resultado) = c("Coeficiente de Asimetria de Fisher", "Coeficiente de Curtosis")
  return(resultado)
}

#Ejecucion de las funciones mediante los parametros de ambas epocas
medidasCentralizacion(datos$'Epoca Temprana')
medidasCentralizacion(datos$'Epoca Tardia')

medidasDispersion(datos$'Epoca Temprana')
medidasDispersion(datos$'Epoca Tardia')

medidasNoCentrales(datos$'Epoca Temprana')
medidasNoCentrales(datos$'Epoca Tardia')

medidasAsimCurt(datos$'Epoca Temprana')
medidasAsimCurt(datos$'Epoca Tardia')


#Diagrama de cajas y bigotes de ambas epocas
boxplot(datos, col = rgb(0, 1, 0.7, alpha = 0.2),
        ylab = "Anchura (MM)",
        main = "Diagrama de cajas y bigotes")


#APARTADO b)

#Test de Kolmogorov - Smirnov
ks.test(datos$'Epoca Temprana',"pnorm")
ks.test(datos$'Epoca Tardia', "pnorm")


#EJERCICIO 2

#APARTADO a)
#Funcion de calculo del IC para niveles 0.9, 0.95 y 0.99 con varianzas desiguales y variables independientes
intervaloConfianza <- function(x,y){
  for(i in c(0.9,0.95,0.99)){
    resultado <- t.test(x,y, conf.level = i, paired = FALSE, var.equal = FALSE)$conf.int
    print(resultado)
  }
}

#Ejecucion de la funcion del IC
intervaloConfianza(datos$'Epoca Temprana',datos$'Epoca Tardia')

#APARTADO b)

#Condiciones contraste de hipótesis en t.test

#Normalidad
shapiro.test(datos$'Epoca Temprana')
shapiro.test(datos$'Epoca Tardia')

#Igualdad de varianzas
y <- c(datos$'Epoca Temprana',datos$'Epoca Tardia')
group <- as.factor(c(rep(1,length(datos$`Epoca Temprana`)), rep(2,length(datos$`Epoca Tardia`))))
leveneTest(y, group)

#Prueba test-t
#Funcion delt-student para niveles 0.9, 0.95 y 0.99 con varianzas desiguales, variables independientes e igualdad de medias
pruebaT <- function(x,y){
  for(i in c(0.9,0.95,0.99)){
    resultado <- t.test(x,y, alternative = "two.sided",conf.level = i, paired = FALSE, var.equal = FALSE)
    print(resultado)
  }
}

#Ejecucion de la funcion del test-t
pruebaT(datos$'Epoca Temprana',datos$'Epoca Tardia')


