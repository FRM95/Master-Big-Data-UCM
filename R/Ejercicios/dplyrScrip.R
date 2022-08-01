# dplyr
##################################################################

library(dplyr)
library(gapminder)

is.data.frame(gapminder)
head(gapminder)
str(gapminder)
dim(gapminder)
summary(gapminder)

# SELECT 

#cada vez que pasa por el pipe (%>%) es un data frame,
#por lo que podremos hacer operaciones sobre el resultado del pipe

colnames(gapminder)
gapminder %>% select(country, continent, pop) #selecciona las columnas
gapminder %>% select(country:pop) #selecciona las columnas desde countr a pop
gapminder %>% select(country:lifeExp) 
gapminder %>% select(-(country:lifeExp)) #selecciona todas menos las del rango


gapminder %>% select(country:pop) %>% 
  filter(country == 'Spain' & year >= 1990)

gapminder %>% select(country:pop) %>% 
  filter(country == 'Spain' | country == 'Portugal') %>%
  filter(year >= 1990)


#Filters con grep
gapminder %>% select(country:pop) %>%
  filter(grepl('Spain|Austria', x = country)) %>% #Similar al de arriba pero con grep
  filter(year>=1990)

gapminder %>% select(country:pop) %>% 
  filter(grepl('^A', x = country)) %>% #Filtramos por los que empiezan por A
  filter(year>=1990)

#Filtrado de los paises por A pero sin que aparezca su nombre filtrados por 1990 y 2000
gapminder %>% select(country:pop) %>% 
  filter(grepl('^A', x = country)) %>% #Filtramos por los que empiezan por A
  filter(year>=1990 & year <=2000) %>%
  select(-(country)) #hacemos un select de todos menos el country


#Seleccionar todos los registros de Airquality entre el 1 y 10 de Junio
#y cuya temperatura es superior al 50% de todas las del dataset
data("airquality")
head(airquality)

airquality %>% select(Ozone:Day) %>%
  filter(Month == 6 & (Day >= 1 & Day <= 10)) %>%
  filter(Temp > median(airquality$Temp)) #la mediana es el 50%!!

#Filter at se aplica a una columna / filter all se aplica a todas las columnas
#any vars cualquier variable, all vars todas las variables

iris %>% filter_at(
  vars(starts_with('Sepal')), any_vars(.>4.5)) #muestrame aquellas variables que empiezan por sepal de las que algunas de ellas su valores son mayores que 4.5

iris %>% select(-Species) %>% filter_all(any_vars(.>6)) #muestrame aquellas variables que de cualquiera de sus valores sean mayores que 6

iris %>% select(-Species) %>% filter_all(any_vars(.<1)) #aquellos que tengan valores menores que uno

#MUY UTIL
airquality %>% filter_all(any_vars(is.null(airquality))) #para todas las columnas dime si hay un valor nulo en alguna de las columnas 
airquality %>% filter_all(any_vars(is.na(airquality))) #para todas las columnas dime si hay un valor na en alguna de las columnas 

#summarise para crear tabla con los filtros pasados
gapminder %>% group_by(continent) %>%
  summarise(
    media.pop = mean(pop),
    sd.pop = sd(pop),
    n.rows = n(), #numero de valores
    q1.pop = quantile(pop,0.25)
  )

gapminder %>% filter(continent %in% c('Americas','Asia')) %>%
  filter(year>1990) %>%
  group_by(country, year) %>%
  summarise(
    percentil95 = quantile(gdpPercap,0.99),
    percentil1 = quantile(gdpPercap,0.01)
  )

#MUTATE crea columnas o modifica las existentes

# crea una columna llamada live.plus, si lifeExp es mayor q1ue 35, pondra el valor de
# gdpPercap * 1.5, en tal caso  será gdpPercap if(lifeExp >35){gdpPercap * 1.5}else{gdpPercap}
gapminder %>% mutate(
  life.plus = if_else(lifeExp > 35, gdpPercap * 1.5, gdpPercap) 
)

gapminder %>% filter(country=='Spain') %>%
  mutate(
    life.plus2 = case_when(
      lifeExp > 75 ~ "alta",
      lifeExp > 65 ~ "media",
      TRUE ~"baja" #para todos los casos restantes (que no sean >75 o >65)
    )
  )

# Ejercicio
# a) En iris, crear una nueva columna que muestre alto/bajo en funcion de 
# si petal length es mayor o menor que 4.5
# b) Tras ello, agrupar por la nueva columna y contar cuantos elementso hay
# en cada grupo

iris %>% mutate(
  petal.tamano = case_when(
    Petal.Length > 4.5 ~ "alto",
    TRUE ~'bajo'
  )
)

iris %>% mutate(
  petal.tamano = if_else(Petal.Length>4.5, 'alto', 'bajo')
)


iris %>% mutate(
  petal.tamano = case_when(
    Petal.Length > 4.5 ~ "alto",
    TRUE ~'bajo'
  )
) %>% group_by(petal.tamano) %>% 
  summarise(
    n.elementos = n()
  )

# ARRANGE ordena el data.frame en base a ciertas columnas
gapminder %>% arrange(country, desc(year))
gapminder %>% arrange(desc(year), country)

# JOINS 
data("band_members")
data("band_instruments")

head(band_instruments)
head(band_members)

band_members %>% inner_join(band_instruments, by='name')
band_members %>% inner_join(band_instruments)
band_members %>% left_join(band_instruments)
band_members %>% right_join(band_instruments)

data("band_instruments2")
band_members %>% inner_join(band_instruments2, 
                            by = c('name' = 'artist'))