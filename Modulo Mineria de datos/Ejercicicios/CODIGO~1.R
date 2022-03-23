
# Directorio de Trabajo
setwd('F:/Documentos/Master Comercio 2021-22')

# Cargar librerías (paquete pacman)
install.packages("pacman")
pacman::p_load(readxl,fpp2,tseries,forecast,ggplot2,seasonal,descomponer,TSA)


########### Datos de pasajeros de avión. Serie clásica ############

# Cargamos un dataset propio de R
data(AirPassengers)
str(AirPassengers)


## Análisis y descripción de las componenetes de la serie

# Descomposición de las series 
air_desc<- decompose(AirPassengers, type = 'multiplicative')


# Representacion de la descomposición
autoplot(air_desc)

# Coeficientes debidos a la estacionalidad 
air_desc$figure

# Análisis gráfico de la estacionalidad. Representación por año
ggseasonplot(AirPassengers, year.labels=TRUE, year.labels.left=TRUE) +
  ylab("Número") +  ggtitle("Seasonal plot: Air Passengers")


# Representacion de residuos
autoplot(air_desc$random)
mean(air_desc$random, na.rm = T)
sd(air_desc$random, na.rm = T)

## Contraste de normalidad de los residuos
ks.test(air_desc$random,'pnorm')
shapiro.test(air_desc$random)


# Construcción del periodograma 
gperiodograma(AirPassengers)


### Tratamiento de la serie. Hacia la serie estacionaria

# Eliminar la heterocedasticidad. Estabilización de la varianza
AirLog<-log(AirPassengers)

# Una función para pintar...hay más..
ts.plot(AirLog, main= 'Pasajeros de Avión. 
        Estabilización Varianza', 
        gpars=list(xlab="year", ylab="log(passengers)", lty=c(1:3)))

# Eliminar tendencia
AirLog.diff_1<-diff(AirLog)

# Representación
ts.plot(AirLog.diff_1, main= 'Pasajeros de Avión. 
        Estabilización Varianza y Diferenciación', 
        gpars=list(xlab="year", ylab="log(passengers)", lty=c(1:3)))
abline(h=0)

# Eliminar estacionalidad
AirLog.diff_1_12<-diff(AirLog.diff_1, lag = 12)
ts.plot(AirLog.diff_1_12, main= 'Pasajeros de Avión. 
        Diferenciacion estacional ', 
        gpars=list(xlab="year", ylab="log(passengers)", lty=c(1:3)))
abline(h=0)

## Contraste de normalidad de los residuos
ks.test(AirLog.diff_1_12,'pnorm')
shapiro.test(AirLog.diff_1_12) ## La serie con 
# todas las transformaciones no es ruido blanco



# Ventanas de ajuste y evaluación 
air_tr<-window(x = AirPassengers, end = c(1959,12))
air_tst<-window(x = AirPassengers, start = c(1960,1))


### Suavizado exponencial simple ses(). Predicción a un año
air_s1=ses(air_tr, h=12)

# Distribución de residuos
print(air_s1)
air_s1$model
autoplot(air_s1$residuals)

#Representamos los valores observados y los suavizados con la predicción 
autoplot(air_s1) +
  autolayer(fitted(air_s1), series="Fitted")+autolayer(air_tst, series="actual") +
  ylab("viajeros") + xlab("Mes/Año")


###  Suavizado Exponencial doble de Holt 
air_sh <- holt(air_tr, h=12)


# Inspección del objeto creado y Distribución de residuos
print(air_sh)
air_sh$model
autoplot(air_sh$residuals)


#Representamos los valores observados y los suavizados con la predicción 
autoplot(air_sh) +
  autolayer(fitted(air_sh), series="Fitted") +autolayer(air_tst, series="actual") +
  ylab("viajeros") + xlab("Mes/Año")


#### Holt-Winters

# Ajuste de modelo
air_hw_add <- hw(air_tr, h=12,level = c(80, 95))
air_hw_mul <- hw(air_tr, h=12, seasonal="multiplicative",level = c(80, 95))

#Visualización
autoplot(air_hw_add)+ autolayer(fitted(air_hw_add), series="Fitted") +autolayer(air_tst, series="Test") +
  ylab("Air_pass)") + xlab("Year")

autoplot(air_hw_mul)+ autolayer(fitted(air_hw_mul), series="Fitted") +autolayer(air_tst, series="Test") +
  ylab("Air_pass)") + xlab("Year")


## Extra:
# Predicciones utilizando el paquete forecast (ETS)
ETS_pred<-forecast(air_tr,h=12)
autoplot(ETS_pred)


# Se prueba la precisión de las distintas predicciones
accuracy(air_s1,air_tst)
accuracy(air_sh,air_tst)
accuracy(air_hw_add,air_tst)
accuracy(air_hw_mul,air_tst)
accuracy(ETS_pred,air_tst)




##########  Datos sobre viajeros en la ciudad de córdoba #############

## Ejemplo Cordoba (datos Cordoba.xlsx)

#Lectura de datos
Cordoba<-read_excel('Datos/Cordoba.xlsx')
head(Cordoba)

# Convertir a serie temporal. 
v_cordoba <- ts(Cordoba[,-1], start=c(2005,1), frequency=12)
v_cordoba_R  <- ts(Cordoba[,2], start=c(2005,1), frequency=12)
v_cordoba_E  <- ts(Cordoba[,3], start=c(2005,1), frequency=12)

# Representación gráfica
autoplot(v_cordoba, facets=TRUE) 

# Residentes con nombres de ejes
autoplot(v_cordoba_R)+  ggtitle("Residentes") +  xlab("Mes/Año") +  ylab("Número")

# Extranjeros con nombres de ejes
autoplot(v_cordoba_E) +ggtitle("Extranjeros") +  xlab("Mes/Año") +  ylab("Número")

# Descomposición de las series 
v_cordoba_E_Comp<- decompose(v_cordoba_E,type=c("multiplicative"))
v_cordoba_R_Comp<- decompose(v_cordoba_R,type=c("multiplicative"))

# Representacion de la descomposición
autoplot(v_cordoba_E_Comp)
autoplot(v_cordoba_R_Comp)

# Coeficientes debidos a la estacionalidad 
v_cordoba_E_Comp$figure
v_cordoba_R_Comp$figure

# Análisis gráfico de la estacionalidad. Representación por año
ggseasonplot(v_cordoba_E, year.labels=TRUE, year.labels.left=TRUE) +
  ylab("Número") +  ggtitle("Seasonal plot: viajeros Extranjeros en Córdoba")

ggseasonplot(v_cordoba_R, year.labels=TRUE, year.labels.left=TRUE) +
  ylab("Número") +  ggtitle("Seasonal plot: viajeros Residentes en Córdoba")

# Representacion de resiuos
autoplot(v_cordoba_E_Comp$random)
mean(v_cordoba_E_Comp$random, na.rm = T)
sd(v_cordoba_E_Comp$random, na.rm = T)

autoplot(v_cordoba_R_Comp$random)
mean(v_cordoba_R_Comp$random, na.rm = T)
sd(v_cordoba_R_Comp$random, na.rm = T)

# Construcción del periodograma 
gperiodograma(v_cordoba_R)
gperiodograma(diff(log(v_cordoba_R)))


# Seleccionamos toda la serie excepto los valores del último año 
# para ajustar los modelos
v_cordoba_E_tr<-window(v_cordoba_E,end=c(2018,12))
v_cordoba_R_tr<-window(v_cordoba_R,end=c(2018,12))

# Seleccionamos el último año para comparar predicciones 
v_cordoba_E_tst<-window(v_cordoba_E,start=c(2019,1))
v_cordoba_R_tst<-window(v_cordoba_R,start=c(2019,1))



### Suavizado exponencial simple ses(). Predicción a un año
cordoba_E_s1=ses(v_cordoba_E_tr, h=8)
cordoba_R_s1=ses(v_cordoba_R_tr, h=8)

# Distribución de residuos
print(cordoba_E_s1)
cordoba_E_s1$model
autoplot(cordoba_E_s1$residuals)

print(cordoba_R_s1)
cordoba_R_s1$model
autoplot(cordoba_R_s1$residuals)


#Representamos los valores observados y los suavizados con la predicción 
autoplot(cordoba_E_s1) +
  autolayer(fitted(cordoba_E_s1), series="Fitted") +autolayer(v_cordoba_E_tst, series="actual") +
  ylab("viajeros") + xlab("Mes/Año")

autoplot(cordoba_R_s1) +
  autolayer(fitted(cordoba_R_s1), series="Fitted") +autolayer(v_cordoba_R_tst, series="actual") +
  ylab("viajeros") + xlab("Mes/Año")



###  Suavizado Exponencial doble de Holt 
cordoba_E_sh <- holt(v_cordoba_E_tr, h=8)
cordoba_R_sh <- holt(v_cordoba_R_tr, h=8)

# Inspección del objeto creado y Distribución de residuos
print(cordoba_E_sh)
cordoba_E_sh$model
autoplot(cordoba_E_sh$residuals)

print(cordoba_R_sh)
cordoba_R_sh$model
autoplot(cordoba_R_sh$residuals)

#Representamos los valores observados y los suavizados con la predicción 
autoplot(cordoba_E_sh) +
  autolayer(fitted(cordoba_E_sh), series="Fitted") +autolayer(v_cordoba_E_tst, series="actual") +
  ylab("viajeros") + xlab("Mes/Año")

autoplot(cordoba_R_sh) +
  autolayer(fitted(cordoba_R_sh), series="Fitted") +autolayer(v_cordoba_R_tst, series="actual") +
  ylab("viajeros") + xlab("Mes/Año")



### Suavizado Exponencial con estacionalidad. Holt-Winters
cordoba_E_hw <- hw(v_cordoba_E_tr, seasonal='multiplicative', h=8, level = c(80, 95))
cordoba_R_hw <- hw(v_cordoba_R_tr, seasonal='multiplicative', h=8, level = c(80, 95))


cordoba_E_hw$model
autoplot(cordoba_E_hw$residuals)
checkresiduals(cordoba_E_hw)

#Representamos los valores observados y los suavizados con la predicción 
autoplot(cordoba_E_hw) +
  autolayer(fitted(cordoba_E_hw), series="Fitted") +autolayer(v_cordoba_E_tst, series="actual") +
  ylab("viajeros") + xlab("Mes/Año")

autoplot(cordoba_R_hw) +
  autolayer(fitted(cordoba_R_hw), series="Fitted") +autolayer(v_cordoba_R_tst, series="actual") +
  ylab("viajeros") + xlab("Mes/Año")

checkresiduals(cordoba_R_hw)

# Se prueba la precisión de las distintas predicciones
accuracy(cordoba_E_s1,v_cordoba_E_tst)
accuracy(cordoba_E_sh,v_cordoba_E_tst)
accuracy(cordoba_E_hw,v_cordoba_E_tst)


accuracy(cordoba_R_s1,v_cordoba_R_tst)
accuracy(cordoba_R_sh,v_cordoba_R_tst)
accuracy(cordoba_R_hw,v_cordoba_R_tst)

