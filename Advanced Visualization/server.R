
# Modulo visualización avanzada
# Ejercicio de fin de modulo (server.R)
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
library(RColorBrewer)
library(modeest)
library(ggpubr)
library(DT)
library(factoextra)
library(cluster)
library(clustertend)
library(cclust)


# Carga del dataset desde Gihub personal

dataset <- read.xlsx("https://github.com/FRM95/UCM-BD/blob/main/datasetVisAvanz.xlsx?raw=true")

# Conversion previa de columnas a tipo a factor

dataset <- dataset %>% mutate_at(vars(3:13), factor) %>% mutate_at(vars(19:20), factor)
dataset <- na.omit(dataset)

shinyServer(function(input, output) {
  
  #Output de la búsqueda de información en el datset
  output$dataset <- DT::renderDataTable({
    
    data <- dataset
    #DT::datatable(data, options = list(lengthMenu = c(10,20,50), pageLength = 5))
    
    if(input$category != "Todas") {
      data <- data[data$Categoria == input$category,]
    }
    
    if(input$content != "Todos") {
      data <- data[data$Contenido == input$content,]
    }
    
    if(input$content != "Todos") {
      data <- data[data$Contenido == input$content,]
    }
    
    if(input$pay) {
      data <- data[data$Precio != 0,]
    }
    
    DT::datatable(data, options = list(lengthMenu = c(5,10,20,50), pageLength = 5))
    
  })
    
    
  #Output del diagrama de barras
  output$diagramaBarras <- renderPlot({
    
    xLabel = input$xBar
    yLabel = input$yBar
    titulo = paste("Gráfico:",xLabel,"vs", yLabel)
    
    p <- ggplot(dataset,aes_string(x = input$xBar, y = input$yBar, fill = input$xBar)) + 
      geom_bar(stat="identity",width= 0.8, alpha = 1) +
      labs(title=titulo) + 
      theme(plot.title = element_text(color = "#404040",size = 18),
            axis.text = element_text(size = 12),
            axis.title = element_text(size = 13.5),
            axis.title.x = element_text(vjust = -1.9),
            axis.title.y = element_text(vjust = 3.8)
            ) + scale_fill_brewer(palette = "GnBu")
    
    if (input$colorPal != 'GnBu')
      p <- p + scale_fill_brewer(palette = input$colorPal)
    
    
    print(p)
    
  })
  
  #Output del diagrama de bigotes
  output$diagramaBigotes <- renderPlot({
    
    xLabel = input$xBig
    yLabel = input$yBig
    titulo = paste("Gráfico:",xLabel,"vs", yLabel)
    
    p <- ggplot(dataset,aes_string(x = input$xBig, y = input$yBig, fill = input$xBig)) + 
      geom_boxplot(colour = "#404040" ,outlier.colour = "red", width= 0.8, alpha = 1, outlier.size = 2.3) +
      labs(title=titulo) + 
      theme(plot.title = element_text(color = "#404040",size = 18),
            axis.text = element_text(size = 12),
            axis.title = element_text(size = 13.5),
            axis.title.x = element_text(vjust = -1.9),
            axis.title.y = element_text(vjust = 3.8)
      ) + scale_fill_brewer(palette = "GnBu")
    
    if (input$colorPal2 != 'GnBu')
      p <- p + scale_fill_brewer(palette = input$colorPal2)
     
     
    print(p)
    
  })
  
  #Output del histograma
  output$histograma <- renderPlot({
    
    xLabel = input$xHist
    titulo = paste("Gráfico:",xLabel)
    
    p <- ggplot(dataset, aes_string(x = input$xHist)) + 
      geom_histogram(color = "#404040", bins = 20, alpha = 1,fill = input$colorHist) +
      labs(title=titulo) + 
      ylab("Frecuencia") +
      theme(plot.title = element_text(color = "#404040", size = 18),
            axis.text = element_text(size = 12),
            axis.title = element_text(size = 13.5),
            axis.title.x = element_text(vjust = -1),
            axis.title.y = element_text(vjust = 3.8)
      ) 
      
    if (input$mean1)
      p <- p + geom_vline(aes(xintercept = mean(get(input$xHist))), linetype = "dashed", color = "black", size = 1.3) 
    
    if (input$median1)
      p <- p + geom_vline(aes(xintercept = median(get(input$xHist))),linetype = "dashed", color = "red", size = 1.3)
    
    if (input$firstQ1)
      p <- p + geom_vline(aes(xintercept = quantile(get(input$xHist), 0.25)),linetype = "dashed", color = "purple", size = 1.3)
    
    if (input$thirdQ1)
      p <- p + geom_vline(aes(xintercept = quantile(get(input$xHist), 0.75)),linetype = "dashed", color = "orange", size = 1.3)
    
    
    print(p)
    
  })
  
  
  
  #Output del algoritmo PAM
  
  output$pam <- renderPlot({
    
    descargaslog <- log(dataset$Descargas)
    grupo <- dataset[,c('Precio','Valoraciones','Evaluaciones')]
    grupo$Descargas<- descargaslog
    grupo <- scale(grupo)
    
    set.seed(123)
    pam_clusters <- pam(x = grupo, k = 5, metric = "manhattan")
    
    p <- fviz_cluster(object = pam_clusters, data = grupo, geom = "point", ellipse.type = "t", repel = TRUE,
                 sow.clust.cent = TRUE)

    if(input$kGrupos != '5'){
      pam_clusters <- pam(x = grupo, k = input$kGrupos, metric = "manhattan")
      p <- fviz_cluster(object = pam_clusters, data = grupo, geom = "point", ellipse.type = "t", repel = TRUE,
                      sow.clust.cent = TRUE)
    }
    
    if(input$tipoElip != 't'){
      pam_clusters <- pam(x = grupo, k = input$kGrupos, metric = "manhattan")
      p <- fviz_cluster(object = pam_clusters, data = grupo, geom = "point", ellipse.type = input$tipoElip , repel = TRUE,
                        sow.clust.cent = TRUE)
    }
    
    print(p)
    
    
  })
  
  
  #Output resultados
  output$coordenadas <- renderPlot({
    
    xLabel = input$variable
    titulo = paste("Gráfico:", xLabel)
    
    p <- ggplot(data = dataset) + 
      geom_bar(aes_string(x = input$variable, fill = input$variable), show.legend = TRUE, width = 1) + 
      theme(aspect.ratio = 1,
            plot.title = element_text(color = "#404040", size = 18),
            axis.text = element_text(size = 10),
            axis.title = element_text(size = 13.5),
            axis.title.x = element_text(vjust = -1),
            axis.title.y = element_text(vjust = 3.8)
            ) + labs(x = NULL, y = "Cantidad") + scale_fill_brewer(palette = "Spectral")

    print(p)
    
  })

  output$text <- renderText({
    res <- dataset[input$variable2]
    summary(res)
  })
  
  
})

