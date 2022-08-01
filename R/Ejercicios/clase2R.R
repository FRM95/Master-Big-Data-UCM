#Ejercicio
#Implementar un programa que cree un vector llamado salarios con los salarios de 
#cinco empleados, donde el primer elemento son 1000 euros y el resto se 
#incrementan de 100 en 100
#SLIDE 19

salarios = seq(from=1000, to=1400,by=100)

names(salarios)= c("Juan", "Antonio", "Pepe", "Luis", "Pedro")
salarios

salarios.p = salarios[startsWith(names(salarios), 'P')]
salarios.p

salarios.p['Pedro'] = salarios.p['Pedro']*1.5
salarios.p

incrementos = c(1.01,1.02,1.03,1.04,1.05)
incrementos = 1:5 /100 +1
incrementos * salarios

#Implementar un programa que cree un vector de los n?meros pares del 0 al 100, le 
#cambie el signo a los que sean m?ltiplos de 3 y multiplique por 5 a los que no.
#SLIDE 20

vector.pares = seq(from=0, to=100, by=2)
mult.3 = vector.pares %% 3 == 0
vector.pares[mult.3] = vector.pares[mult.3] * (-1)
!mult.3
vector.pares[!mult.3] = vector.pares[!mult.3] * 5
vector.pares

#Indexar matrices
matriz = matrix(c(33.1,55.9,8.4,77.9,13.9,5.09), nrow = 3)
rownames(matriz) = c('fila1','fila2','fila3')
colnames(matriz) = c('col1','col2')
matriz
matriz['fila2','col1']

matriz2 = matrix(1:100,nrow=10)
submatriz2 = matriz2[1:4,4:10]
submatriz2

#Sacar submatriz de filas impares y columnas pares de matriz2
matriz3 = matrix(1:100,nrow=10)
matriz3[c(TRUE,FALSE),c(FALSE,TRUE)]
#otra solucion =
matriz3[seq(1,10,2),seq(2,10,2)]

#Concatenar strings
paste('hola','mundo',sep =' ')
paste('fila',1:10,sep = ' ')
paste('col', 1:10, sep = ' ')
rownames(matriz3) = paste('fila',1:10,sep='')
colnames(matriz3) = paste('col',1:10,sep='')
matriz3

#LISTAS
lista <- list(3, "hola", 3.56, c("un", "vector"))
lista[[2]] # deuvleve un unico elemento
sublista <- lista[3]  # devuelve una lista de un solo elemento 

sub2 <- lista[2:4]    # lista ["hola", 3.56, c("un", "vector")] 
names(sub2) <- c("cad", "real", "vector") 
sub3 <- sub2[c("vector", "cad")] # selecciono 2 elementos


# Creamos una lista con nombres desde el momento de creaci?n 
cambio <- list(dolar = 0.89, yen = 0.0081, zloty = 0.22)
moneda.polaca <- "zloty"   # nombre de la casilla que buscamos 
euros <- 150 * cambio[["dolar"]]  # 150 dolares a euros 
euros2 <- 4000 * cambio[[moneda.polaca]] #4000 zloty a euros
cambio$zloty <- 0.23 #se cambia el valor de un elemento de la lista
cambio$yen = NULL # borrado de elemento por nombre
cambio[[2]] = NULL # borrado de elemento por indice
cambio$rupia = 0.56 #a?adimos un elemento 
cambio[["rupia"]] = 0.56 
str(cambio) #devuelve elementos y valor elementos de una lista (estructura)

#Ejercicio propuesto
#SLIDE 29
empleados = list(
  DNI = c("12345678A", "12345678B", "12345678C","12345678D", "12345678E"),
  Email = c("maria@gmail.com","pepe@gmail.com","juan@gmail.com", "sara@gmail.com","ana@gmail.com"),
  Bruto_base = c(1200,1450,1329,1020,1600),
  Bruto_bonus = c(50,83,102,78,29),
  Bruto_extra = c(10,20,30,40,50),
  Antig = c(5,10,7,2,9),
  Categoria = c('Comercial','Director Financiero','Ingeniero Informático','Data Scientist','Jefe de Proyectos')
)

bonus.mask = empleados[startsWith(names(empleados),'Bruto_')]
maximo = max(empleados$Bruto_base)
media = mean(empleados$Bruto_bonus)
vSuma = empleados$Bruto_base + empleados$Bruto_bonus + empleados$Bruto_extra
empleados$total = vSuma
empleados$Categoria = NULL

#FACTORES
estudios = c("medio", "bajo", "alto", "medio", "alto")
alturas = factor(estudios) #guardamos en alturas los valores distintos
alturas #levels seran los valores distintos
levels(alturas)
nlevels(alturas)

#un factor sera como definir una muestra 
#y los levels los posibles valores distintos que puede tener

alturas = factor(c('medio','bajo','bajo','alto','medio','bajo'),
                 levels = c('bajo','medio','alto'), ordered = TRUE)
alturas
min(alturas) #al haberlo ordenado en levels estrictamente y habilitar el orden
max(alturas)

alturas[alturas>'bajo'] #devuelve aquellos mayores que bajo
levels(alturas)[1] = 'chiquito' #cambia el valor del level de la posicion 1
alturas


#DATAFRAMES
alturaPersona = c(1.88,1.95,1.36,1.58,1.78,1.65,1.45,1.91)
length(alturaPersona)
grupoClases = factor(c('A','A','B','C','B','A','B','C'))
length(grupoClases)
grupoClases

df <- data.frame(Alturas = alturaPersona, Grupos = grupoClases)
df
head(df) #saca los 6 primeros
tail(df) #saca los 6 ultimos
str(df) #estructura del dataframe
dim(df) #dimension del dataframe (filasxcolumnas)
summary(df) #estadistica descriptiva del df

colnames(df) = c('Alt','Grp') #Cambio de nombre de las columnas
df
alturas2 = alturaPersona + 0.2
df[['Alturas2']] = alturas2 #a?adimos una nueva columna
df

df$Alturas2=NULL #borrado de una columna
df[['Alturas2']] = NULL
df

#EJEMPLO
empleados = data.frame( 
  DNI = c("12345678A", "12345678B", "12345678C",  
          "12345678D", "12345678E"), 
  Email = c("maria@gmail.com","pepe@gmail.com","juan@gmail.com", 
            "sara@gmail.com","ana@gmail.com"), 
  Bruto_base = c(1200,1450,1329,1020,1600), 
  Bruto_bonus = c(50,83,102,78,29), 
  Bruto_extra = c(10,20,30,40,50), 
  Antig = c(5,10,7,2,9), 
  Categoria = c('Comercial','Director Financiero','Ingeniero Informatico','Data Scientist','Jefe de Proyectos') 
)
empleados

#sacar filas impares y columnas pares
#df(filas,columnas)
empleados[c(1,3,5),c(2,4,6)]
empleados[c(TRUE,FALSE),c(FALSE,TRUE)]

#sacar filas 1,3,4 y columnas 2,4,5,6,7
empleados[c(1,3,4),c(2,4,5,6,7)]

#sacar columnas de email y bruto extras
a = empleados$Email #extrae en a las filas asociadas a la columna email
b = empleados$Bruto_extra
empleados[,c('Email','Bruto_extra')] #puedes no poner la ',' y asume que el filtro es en columnas

#sacar las columnas que empiezan con bruto
empleados[,startsWith(colnames(empleados),'Bruto')] 

#indexar las filas por el DNI del empleado y borrar la columna dNI
rownames(empleados) = empleados$DNI
empleados
empleados$DNI = NULL
empleados

#filtrar todas las filas que tengan un bruto base superior a 1000
empleados[empleados$Bruto_base>1200,]

#filtrar todas las filas que tengan un bruto base superior a 1000 y columna DNI
empleados[empleados$Bruto_base>1200,'DNI']

# filtrar todas las filas que tengan un bruto base mayor de la media
empleados[empleados$Bruto_base>mean(empleados$Bruto_base),]

###########

#Filtrado por subset
subset(empleados, subset = Bruto_base>1200, select = c('Email','Categoria','Bruto_base'))

#Concatenacion de dataframes
df1 = empleados[1:2,1:3] 
df2 = empleados[3:5,1:3]
rbind(df1,df2) #agrupa dos dataframes en uno mediante filas

df1 = empleados[1:4,1:2]
df2 = empleados[1:4,5:6]
cbind(df1,df2) #agrupa dos dataframes en uno mediante columnas

#FUNCIONES y ESTRUCTURAS DE CONTROL
x = c(2.9,5.3)
y = c(5.2,-6.6)

dist = sqrt((x[1]-x[2])^2+(y[1]-y[2])^2)
dist

distancia <- function(x,y){
  dist = sqrt((x[1]-x[2])^2+(y[1]-y[2])^2)
  return(dist)
}

distancia(c(2.9,5.3),c(5.2,-6.6))

#BUCLE FOR :)
fin = 3000
suma = 0
for(i in 1:fin){
  suma = i
  print(suma)
}

#Ejercicio
v1 = 1:50
v2 = 6:56

ejerc1 <- function(x,y){
  for(i in 1:length(x)){
    for(a in 1:length(y)){
      if(i %% 3 == 0 && a %% 3 == 0){
        print(x[i]/y[a])
      }
    }
  }
}

#Bucle While :)
i = 1
while( i <= length(v1)){
  print(v1[i]/v2[i])
  i = i+1
}


#FUNCIONES lapply, sapply, tapply, apply
#sirven para aplicar a cada elemento de una 
#lista, vector o df una determinada funci?n escrita por el usuario 
#head(iris)

summary(iris)

iris[,1] #todas las filas de la columna 1
iris[1] #todas las filas de la columna 1 (unico para datasets)
iris$Sepal.Length #todas las filas de la columna

sapply(iris[,1], min)
sapply(iris[1:4], mean)

divisores <- function(x){
  candidato = 1:x
  resto = x%%candidato
  mask = resto == 0
  return(candidato[mask])
}


esPrimo <- function(x){
  v = divisores(x)
  if(length(v) == 2){return(v)}
}

#tapply permite estratificar (por factor) la ejecucion de una funcion
head(iris)
tapply(iris$Sepal.Length, iris$Species, mean) #aplica la media a la longitud de cada especie
                                              #aplica la funcion media por especie de la longitud de cada una

