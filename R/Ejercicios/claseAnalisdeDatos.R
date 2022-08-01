v <- c(2.3, -1.2, 2.9, 4, 0.5, NA)
is.na(v)
na.omit(v) #devuelve el objeto pasado por valor sin elementos na

as.numeric("345")
is.character("holapepe")


v6 = c(1,9,6,7,8,99,102,-5,0)
sort(v6) #muestra un vector con los valores de v6 ordenados de negativo -> positivo
order(v6) #muestra un vector con los indices (no lo valores) del vector ordenado de negativo a positivo
v6[order(v6)]
which(v6>10) #devuelve posiciones de valores de v6 > 10 (los que son true la condicion)



#mostrar salarios brutos del dataframe empleados
sort(empleados$Bruto_base, decreasing = TRUE)
#mostrar dni's de las personas que reciben de menor a mayor salario
mask = order(empleados$Bruto_base)
empleados$DNI[mask]

# Segundos criterios de ordenacion
empleados[c('DNI', 'Bruto_base', 'Antig')]
mask = order(empleados$Bruto_base, empleados$Antig)
empleados[mask,]


#Cadena de caracteres

cadena = 'En un lugar de la mancha, de cuyo nombre no quiero ...'
substr(cadena, 1, 6) #extrae mediante las posiciones del vector de caracteres
strsplit(cadena," ") #extrae segun la condiciones indicada en el segundo parametro   
                     #en este caso los espacios



#REGEX
#https://rstudio-pubs-static.s3.amazonaws.com/74603_76cd14d5983f47408fdf0b323550b846.html

v8 = c('Ejemplo', 'Cabeza', 'Abecedario', 'c,ab,o')
pattern = '.ab'
grep(pattern, v8) #DEVUELVE las posiciones de v8 2 y 4 poseen los caracteres ..ab..
grep(pattern, v8,  value = TRUE) #devuelve los valores que cumplen el grep


strings <- c("a", "ab", "acb", "accb", "acccb", "accccb")
strings
grep("ac*b", strings, value = TRUE) #ac*b extrae esta combinacion pudiendose repetir c 0 veces a infinitas
grep("ac+b", strings, value = TRUE) #c se puede repetir desde 1 a n
grep("ac?b", strings, value = TRUE) #c se puede repetir como maximo una vez
grep("ac{2}b", strings, value = TRUE) #c se puede repetir exactamente 2 veces
grep("ac{2,}b", strings, value = TRUE) #c se puede repetir desde 2 hasta n
grep("ac{2,3}b", strings, value = TRUE) # c se puede repeitr desde 2 hasta 3 veces
stringr::str_extract_all(strings, "ac{2,3}b", simplify = TRUE)


#READ / WRITE 
filename = 'C:/MASTER BIG DATA UCM/Modulos/3 - R/iris.csv'
df.iris = read.csv(filename)

class(df.iris)
head(df.iris)
str(df.iris)

df.iris$variety = factor(df.iris$variety) #ponemos como factor a variety
str(df.iris)


#Distribuciones de probabilidad 
n = 10000
v10 = runif(n, min = 0, max = 1)
hist(v10)

v11 = rnorm(n, mean = 0, sd = 1)
hist(v11)

#histograma
hist(v11,
     breaks = 50,
     main = 'Histograma de una distribucion normal',
     xlab = 'Valores',
     ylab = 'Frecuencia',
     col = 'lightblue'
     )

#sample recoge de un dataset una muestra, una cantidad
iris.sample = sample(iris$Species, size = 100)
table(iris.sample)
pie(table(iris.sample))


resolver <- function(a, b, c){
  if((b^2-4*a*c)<0){
    return(NULL)
  }
  else{
    x1 = (-b+(sqrt(b^2-4*a*c))/2*a)
    x2 = (-b-(sqrt(b^2-4*a*c))/2*a)
    return(c(x1,x2))
  }
}

resolver(1,4,3)
