# Lectura y manipulación últimos datos COVID-19 por grupo de edad y sexo
# Pedro Concejero 20 abril 2021

# Siempre! pon tu directorio de trabajo en el setwd

setwd("/home/pedro/Escritorio/UCM_master/ucm_master_big_data")

library(tidyverse)
library(ggplot2)

isciii <- read_csv("https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv")

View(isciii)

summary(isciii)

covid_por_edad_y_sexo <- isciii %>%
  group_by(sexo, grupo_edad) %>%
  summarise(total_contagiados = sum(num_casos),
            total_hospitalizados = sum(num_hosp),
            total_uci = sum(num_uci),
            total_fallecidos = sum(num_def)) 

View(covid_por_edad_y_sexo)

covid_por_edad_y_sexo$sexo <- as.factor(covid_por_edad_y_sexo$sexo)
covid_por_edad_y_sexo$grupo_edad <- as.factor(covid_por_edad_y_sexo$grupo_edad)

summary(covid_por_edad_y_sexo)

save(covid_por_edad_y_sexo, file = "covid_por_edad_y_sexo_total_2021.rda")

# Dodged bar charts

p <- ggplot(covid_por_edad_y_sexo,
            aes(grupo_edad, total_contagiados,
                fill = sexo))

def <- p + geom_bar(position = "dodge", 
                  stat = "identity") + coord_flip() + 
  scale_fill_manual(values = c("skyblue", "green", "grey"))

# Pongamos título al gráfico con fechas mínima y máxima en los datos originales

min_fecha <- min(isciii$fecha)
max_fecha <- max(isciii$fecha)

title <- paste("Contagios por COVID-19 en España",
               "\n",
               "entre", min_fecha,
               "y", max_fecha,
               "\n", "por género")

print(title)

def + ggtitle(title) 

# Variando la columna de datos que se dibujan conseguiremos la misma visualización 
# para hospitalizados, uci y fallecidos
# y creo muy interesante también extraer conclusiones de qué tasas pasan de uno a otro

# Segunda propuesta: series temporales (las famosas "olas")

library(tsibble)
library(feasts)

olas_covid <- isciii %>%
  group_by(sexo, grupo_edad, fecha) %>%
  summarise(total_contagiados = sum(num_casos),
            total_hospitalizados = sum(num_hosp),
            total_uci = sum(num_uci),
            total_fallecidos = sum(num_def)) %>%
  as_tsibble(key = c(sexo, grupo_edad),
             index = fecha)

autoplot(olas_covid, total_contagiados)
autoplot(olas_covid, total_hospitalizados)
autoplot(olas_covid, total_uci)
autoplot(olas_covid, total_fallecidos)
