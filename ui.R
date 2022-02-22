
# Modulo visualización avanzada
# Ejercicio de fin de modulo (ui.R)
# Master de Big Data: Data Science - UCM 2021/2022

# Alumno: Miguel Moreno Mardones
# Repositorio de Github con informacion del dataset: https://github.com/FRM95/UCM-BD

# Para este ejercicio de fin de modulo, se reutiliza un Dataset acerca de las 
# aplicaciones de ambito Estadistico que se pueden encontrar en la tienda Google Play, 
# junto a algunas de sus caracteristicas mas relevantes (estructura, usabilidad, interfaz visual, evaluacion..)
# Dicho dataset fue creado y usado en la asignatura TFG del grado Ingenieria Informatica, ETSIINF - UPM.
 

# Librerias necesarias

library(shiny)
library(shinythemes)
library(ggplot2)
library(readxl)
library(openxlsx)
library(dplyr)
library(colourpicker)
library(shiny)
library(RColorBrewer)
library(modeest)
library(ggpubr)
library(DT)
library(corrplot)

# Carga del dataset desde Gihub personal

dataset <- read.xlsx("https://github.com/FRM95/UCM-BD/blob/main/datasetVisAvanz.xlsx?raw=true")

# Conversion previa de columnas a tipo a factor

dataset <- dataset %>% mutate_at(vars(3:13), factor) %>% mutate_at(vars(19:20), factor) 
dataset <- na.omit(dataset)

# Vectores de las variables contenidas en el dataset

colCategoricas <- sapply(dataset, is.factor)
colCategoricas <- names(dataset)[colCategoricas]


colContinuas <- sapply(dataset, is.numeric)
colContinuas <- names(dataset)[colContinuas]

# Creacion de la UI mediante Shiny

fluidPage(
  theme = shinytheme("yeti"),
  navbarPage("Dashboard",
    tabPanel("Descripción",
    mainPanel(
      h1("Ejercicio Visualización Avanzada", align = "center"),
      h2("Master Big Data: Data Science - UCM Año 2021/22", align = "center"),
      br(),
      br(),
      p("Esta página web permite visualizar gráficos y obtener múltiples medidas descriptivas acerca 
        de las aplicaciones de estadística que se pueden encontrar en la plataforma de 
        Google Play Store."),
      p("URL de descarga del Dataset: ",
        a("Aplicaciones de estadística y probabilidad en Google Play Store",
          href = "https://github.com/FRM95/UCM-BD/blob/main/datasetVisAvanz.xlsx?raw=true")
        ),
      p("Alumno: Miguel Moreno Mardones"),
      p("Contacto: ",
        a("Github",
          href = "https://github.com/FRM95"
          )
        ),
      h2("Descripción del ejercicio ", align = "center"),
      br(),
      p("Mediante la utilización del paquete Shiny de R, se ha construido este servicio web que implementa algunas de las
        principales medidas estadísticas sobre un conjunto de 250 aplicaciones. Así, trataremos de comprender (de manera gráfica)
        el ecosistema de las aplicaciones de estadísitica y probabilidad en la tienda Google Play Store. Es por eso que podremos obtener información
        acerca del contenido, las categorías o estructura que poseen en dicha plataforma, o las medidas numéricas como la cantidad de descargas o comentarios
        realizados por los usuarios. Finalmente, veremos gráficamente los grupos generados que existen en los datos mediante el uso de algoritmos de agrupamiento como PAM.
        Para así tener una mejor idea de como diferenciar las aplicaciones en pos de realziar futuros estudios.
        El dataset utilizado es totalmente personal, realizado durante mi etapa en la ETSIINF - UPM en el año 2019, por lo que algunos datos (pese a ser oficiales)
        pueden estar obsoletos."),
      br(),
      p("Características del Dataset: "),
      p("• Nombre de la aplicación, donde se define su nombre por el que se la conoce en Google Play y su desarrollador."),
      p("• Contenido y categoría de la aplicación."),
      p("• Elementos de su estructura."),
      p("• El número de descargas y precio actual de la aplicación."),
      p("• Coste o precio de la aplicación."),
      p("• Interfaz visual y usabilidad ofrecida."),
      p("• La evaluación ofrecida por los usuarios y la media de sus puntuaciones."),
      p("• Subconjuntos de aplicaciones encontrados dentro de los datos."),
      br(),
      br(),
      p("Shiny is a product of ",
      a("RStudio.",
        href = "https://www.rstudio.com/"),
      "This license allows for material to be redistributed non-commercially, you are allowed to copy, edit, and build
      upon the original work. You must indicate if the material has been edited or adapted or built upon in any way,
      along with giving credit to the original author and linking to the license. Contact the author for any questions." ),
      )
    ),
    
    tabPanel("Exploración",
             mainPanel(
               h5("Utiliza las siguientes categorías para filtrar los datos:"),
               column(4, selectInput('category', 'Categoría de la aplicación', c("Todas",unique(as.character(dataset[,4]))))
               ),
               column(4, selectInput('content', 'Contenido de la aplicación', c("Todos",unique(as.character(dataset[,3]))))
               ),
               br(),
               column(4, checkboxInput('pay', 'De pago')),
               DT::dataTableOutput("dataset")
             )
    ),
    
    navbarMenu("Análisis general",
      tabPanel("Diagrama de barras",
               sidebarPanel(
                 helpText("Selecciona las variables de entrada deseadas para crear un diagrama de barras.", align = "left"),
                 selectInput('xBar', 'Variable categórica del eje X', colCategoricas[c(1,3,10,11)]),
                 selectInput('yBar', 'Variable continua del eje Y', colContinuas),
                 selectInput('colorPal', 'Paleta de colores', c('GnBu', 'Greens','Blues','Purples','Oranges','Reds')),
                 helpText(strong("Un diagrama de barras representa graficamente un conjunto de datos de manera proporcional a sus valores
                   mediante el uso de barras rectangulares tanto verticales como horizontales." ,align = "left")),
                 width = 3,
                  ),
               mainPanel(
                 h1("Diagrama de barras", align = "center"),
                 br(),
                 br(),
                 plotOutput('diagramaBarras',
                            height = 520,
                            width = 1000,
                    ),
                  ),
               ),
      
      tabPanel("Diagrama de cajas y bigotes",
               sidebarPanel(
                 helpText("Selecciona las variables de entrada deseadas para crear un diagrama de 
                          cajas y bigotes."),
                 selectInput('xBig', 'Variable categórica del eje X', colCategoricas[c(1,10,11)], selected = colCategoricas[1]),
                 selectInput('yBig', 'Variable continua del eje Y', colContinuas[c(3,5)], selected = colContinuas[5]),
                 selectInput('colorPal2', 'Paleta de colores', c('GnBu', 'Greens','Blues','Purples','Oranges','Reds')),
                 helpText(strong("Un diagrama de cajas y bigotes representa graficamente los aspectos más representativos de las estadística
                   descriptiva como son el rango, los cuartiles, la mediana y los datos atípicos." ,align = "left")),
                 width = 3,
               ),
               mainPanel(
                 h1("Diagrama de cajas y bigotes", align = "center"),
                 br(),
                 br(),
                 plotOutput('diagramaBigotes',
                            height = 520,
                            width = 1000,
                 ),
               ),
               ),
      
      tabPanel("Histograma",
               sidebarPanel(
                 helpText("Selecciona la variable de entrada deseada para crear un histograma."),
                 selectInput('xHist', 'Variable continua', colContinuas, selected = colContinuas[5]),
                 colourInput('colorHist','Selecciona el color','#83C4D4'),
                 checkboxInput('mean1', 'Media'),
                 checkboxInput('median1', 'Mediana'),
                 checkboxInput('firstQ1', 'Primer cuartil'),
                 checkboxInput('thirdQ1', 'Tercer cuartil'),
                 helpText(strong("Un histograma representa graficamente la frecuencia de aparición de los datos 
                 representados de una variable con el fin de obtener una vista general de su distribución." ,align = "left")),
                 width = 3,
               ),
               mainPanel(
                 h1("Histograma", align = "center"),
                 br(),
                 br(),
                 plotOutput('histograma',
                            height = 520,
                            width = 1000,
                 ),
               ),
               ),
    ),
    
      tabPanel("Algoritmo de agrupamiento",
               sidebarPanel(
                 helpText(strong("Los algoritmos de agrupamiento nos permiten generar grupos o clústers de un conjunto 
                                 de datos bajo un único criterio.",align = "left")),
                 selectInput('kGrupos', 'Cantidad de k-grupos', c(3,4,5,6,7), selected = 5),
                 selectInput('tipoElip', 'Tipo de elipsis', c('norm','t','convex'), selected = 't'),
                 p("Resultados obtenidos:"),
                 helpText("• Grupo 1: Precio medio: 0€ Media de descargas: 23.416 Media de comentarios: 228 Evaluacion media: 4/5"),
                 helpText("• Grupo 2: Precio medio: 0,5€ Media de descargas: 720 Media de comentarios: 15 Evaluacion media: 4,1/5"),
                 helpText("• Grupo 3: Precio medio: 0,9€ Media de descargas: 250 Media de comentarios: 0.2 Evaluacion media: 3,4/5"),
                 helpText("• Grupo 4: Precio medio: 0,5€ Media de descargas: 100.000 Media de comentarios: 9.754 Evaluacion media: 4,4/5"),
                 helpText("• Grupo 5: Precio medio: 4,2€ Media de descargas: 5.582 Media de comentarios: 136 Evaluacion media: 4,3/5"),
                 width = 3,
               ),
               mainPanel(
                 h1("Álgoritmo de agrupamiento: PAM", align = "center"),
                 plotOutput('pam',
                            height = 500,
                            width = 1000
                      ),
                 br(),
                 p("• El estudio se ha realizado con k = 5 grupos.", align = "left"),
                 p("• Se ha utilizado la distancia manhattan como medida entre puntos.", align = "left"),
                 p("• Los datos utilizados recogen el precio, la cantidad de valoraciones, la evaluación y el número de descargas de las aplicaciones.", align = "left")
                  )
          ),
    
    tabPanel("Resultados",
             sidebarPanel(
               helpText("Selecciona la variable de entrada categórica para representarla en el gráfico."),
               selectInput('variable', 'Variable', colCategoricas[1:12], selected = colCategoricas[1]),
               helpText("Selecciona la variable de entrada continua para obtener su descripción."),
               selectInput('variable2', 'Variable', colContinuas, selected = colContinuas[1]),
               helpText(strong("El gráfico central muestra el conteo de apariciones de las variables
                               definidas como factor. El texto inferior muestra el resultado de aplicar 
                               la función summary() a las variables numéricas.",align = "left")),
               width = 3,
             ),
             mainPanel(
               h1("Estadística descriptiva", align = "center"),
               p("Gráfico de la variable categórica seleccionada:"),
               plotOutput('coordenadas',
                          height = 500,
                          width = 1000,
                          ),
               br(),
               helpText(strong("Resumen (Summary) de la variable continua:")),
               textOutput('text')
             )
             
    )
    
    
  )
  
)

