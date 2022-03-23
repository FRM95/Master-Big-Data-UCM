
# Directorio de Trabajo
setwd('F:/Documentos/Master Comercio 2021-22')

# Cargar librerías
paquetes(c('readxl','fpp2','tseries','forecast','ggplot2','seasonal','descomponer','TSA'))


########### Datos de pasajeros de avión. Serie clásica ############

# Cargamos un dataset propio de R
vuelos<-read_excel('Datos/VUELOS.xlsx')
str(vuelos)

# Convertir a serie temporal
v_vuelos <- ts(vuelos$Vuelos, start=c(1995,1), frequency=12)
autoplot(v_vuelos)

## Análisis y descripción de las componenetes de la serie

# Descomposición de las series 
vuelos_desc<- decompose(v_vuelos, type = 'multiplicative')


# Representacion de la descomposición
autoplot(vuelos_desc)

# Coeficientes debidos a la estacionalidad 
vuelos_desc$figure


# Análisis gráfico de la estacionalidad. Representación por año
ggseasonplot(v_vuelos, year.labels=TRUE, year.labels.left=TRUE) +
  ylab("Número") +  ggtitle("Seasonal plot: Pasajeros de avión 1995")


# Representacion de residuos
autoplot(vuelos_desc$random)
mean(vuelos_desc$random, na.rm = T)
sd(vuelos_desc$random, na.rm = T)

## Contraste de normalidad de los residuos
ks.test(vuelos_desc$random,'pnorm')
shapiro.test(vuelos_desc$random)


# Construcción del periodograma 
gperiodograma(v_vuelos)


### Tratamiento de la serie. Hacia la serie estacionaria

# Eliminar la heterocedasticidad. Estabilización de la varianza
vuelosLog<-log(v_vuelos)

# Una función para pintar...hay más..
ts.plot(vuelosLog, main= 'Pasajeros de Avión 1995. 
        Estabilización Varianza', 
        gpars=list(xlab="year", ylab="log(passengers)", lty=c(1:3)))

# Eliminar tendencia
vuelosLog.diff_1<-diff(vuelosLog)

# Representación
ts.plot(vuelosLog.diff_1, main= 'Pasajeros de Avión 1995. 
        Estabilización Varianza y Diferenciación', 
        gpars=list(xlab="year", ylab="log(passengers)", lty=c(1:3)))
abline(h=0)

# Eliminar estacionalidad
vuelosLog.diff_1_12<-diff(vuelosLog.diff_1, lag = 12)
ts.plot(vuelosLog.diff_1_12, main= 'Pasajeros de Avión 1995. 
        Diferenciacion estacional ', 
        gpars=list(xlab="year", ylab="log(passengers)", lty=c(1:3)))
abline(h=0)

## Contraste de normalidad de los residuos
ks.test(vuelosLog.diff_1_12,'pnorm')
shapiro.test(vuelosLog.diff_1_12) ## La serie con 
# todas las transformaciones no es ruido blanco


# Ventanas de ajuste y evaluación 
vuelos_tr<-window(x = v_vuelos, end = c(2012,6))
vuelos_tst<-window(x = v_vuelos, start = c(2012,7))


### Suavizado exponencial simple ses(). Predicción a un año
vuelos_s1=ses(vuelos_tr, h=8)

# Distribución de residuos
print(vuelos_s1)
vuelos_s1$model
autoplot(vuelos_s1$residuals)

#Representamos los valores observados y los suavizados con la predicción 
autoplot(vuelos_s1) +
  autolayer(fitted(vuelos_s1), series="Fitted")+autolayer(vuelos_tst, series="actual") +
  ylab("viajeros") + xlab("Mes/Año")


###  Suavizado Exponencial doble de Holt 
vuelos_sh <- holt(vuelos_tr, h=8)


# Inspección del objeto creado y Distribución de residuos
print(vuelos_sh)
vuelos_sh$model
autoplot(vuelos_sh$residuals)


#Representamos los valores observados y los suavizados con la predicción 
autoplot(vuelos_sh) +
  autolayer(fitted(vuelos_sh), series="Fitted") +autolayer(vuelos_tst, series="actual") +
  ylab("viajeros") + xlab("Mes/Año")


#### Holt-Winters

# Ajuste de modelo
vuelos_hw_add <- hw(vuelos_tr, h=12,level = c(80, 95))
vuelos_hw_mul <- hw(vuelos_tr, h=12, seasonal="multiplicative",level = c(80, 95))

#Visualización
autoplot(vuelos_hw_add)+ autolayer(fitted(vuelos_hw_add), series="Fitted") +autolayer(vuelos_tst, series="Test") +
  ylab("vuelos_pass)") + xlab("Year")

autoplot(vuelos_hw_mul)+ autolayer(fitted(vuelos_hw_mul), series="Fitted") +autolayer(vuelos_tst, series="Test") +
  ylab("vuelos_pass)") + xlab("Year")


## Extra:
# Predicciones utilizando el paquete forecast (ETS)
ETS_pred<-forecast(vuelos_tr,h=12)
autoplot(ETS_pred)


# Se prueba la precisión de las distintas predicciones
accuracy(vuelos_s1,vuelos_tst)
accuracy(vuelos_sh,vuelos_tst)
accuracy(vuelos_hw_add,vuelos_tst)
accuracy(vuelos_hw_mul,vuelos_tst)
accuracy(ETS_pred,vuelos_tst)


