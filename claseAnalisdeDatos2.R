# EDA: Exploratory Data Analisys (básico)

install.packages("mlbench")
library(mlbench)

data("PimaIndiansDiabetes")
df = PimaIndiansDiabetes
summary(df)

#Obtenemos el nombre de las columnas
#Aplicamos sapply a cada una de ellas la media, mediana, standart div, cuartil
cols.num = colnames(df)[1:8]
sapply(df[cols.num], mean)
sapply(df[cols.num], median)
sapply(df[cols.num], sd)
sapply(df[cols.num], quantile)


#Univariate

par(mfrow=c(2,2)) #establece la salida de graficos de 2x2
#bucle que recorrer las columnas de df 
#y realiza el histograma de cada una
for(col in cols.num){
  hist(df[[col]],
       main = col,
       xlab = col)
}

#realizo un boxplot para cada una de las columnas
par(mfrow=c(2,2))
for(col in cols.num){
  boxplot(df[[col]],
       main = col,
       xlab = col)
}

#Diagrama de cajas de cada una de las columnas frente a diabetes
par(mfrow=c(2,2))
for(col in cols.num){
  boxplot(df[[col]] ~ df$diabetes,
          main = col,
          xlab = col,
          col = c('lightblue', 'green'))
}

#correlaciones
correlaciones = cor(df[cols.num]) #guardamos las correlaciones en una variable
correlaciones

library(corrplot)
par(mfrow = c(1,1))
corrplot(correlaciones) #realizamos el plot de las correlaciones


plot(df$age, df$pregnant)
plot(df$triceps, df$insulin)
plot(df$glucose, df$age, 
     col = df$diabetes, 
     pch = 17,
     xlab = 'glucosa',
     ylab = 'edad',
     main = 'scatterplot')

pairs(df[cols.num],
      col=df$diabetes)


pairs(df[c('mass', 'triceps', 'insulin')],
      col=df$diabetes)


# Ejercicio
# realizar un scatterplot (estratificado) por especie
# cada especie de un color

plot(iris$Petal.Length,iris$Sepal.Length,
  col = iris$Species,
  pch = 17,
  xlab = 'Petal',
  ylab = 'Sepal',
  main = 'scatterplot')


# realizar un modelo de regresion lineal quitando la especie distinta
tapply(X = iris$Petal.Length, INDEX = iris$Species, FUN = mean)
#hemos detectado que la especie distinta es setosa

iris.2 = iris[iris$Species != 'setosa',] #creamos otro iris de especies sin setosa
dim(iris.2)


#realizamos el modelo lineal simple

#1º creamos el scatterplot
plot(iris.2$Petal.Length,iris.2$Sepal.Length,
     pch = 17,
     xlab = 'Petal',
     ylab = 'Sepal',
     main = 'scatterplot')

#2º establecemos la regresion lineal
lm2 = lm(iris.2$Sepal.Length ~ iris.2$Petal.Length)
summary(lm2) #summary del modelo
abline(lm2, col='blue') #dibujamos la linea


# regresion lineal multiple

y = iris$Sepal.Length
x1 = iris$Sepal.Width
x2 = iris$Petal.Length
x3 = iris$Petal.Width
z = iris$Species

regresion.3 = lm( y ~ x1 + x2 + x3 )
summary(regresion.3)
par(mfrow=c(2,2))
plot(x1, y,
     col=z, 
     pch=17,
     ylab='y',
     xlab='xi')
plot(x2, y,
     col=z, 
     pch=17,
     ylab='y',
     xlab='xi')
plot(x3, y,
     col=z, 
     pch=17,
     ylab='y',
     xlab='xi')

