// Ubicacion de la base de datos y muestreo del dataset
db
db.dataset.find()

// Borrado de campos no utiles
db.dataset.updateMany({},{$unset:{"Cluster PAM":""}})
db.dataset.updateMany({},{$unset:{"DBSCAN":""}})

// Queries realizadas

// (1) Conocer la aplicacion mas descargada y menos descargada
db.dataset.find().sort({Descargas:-1}).limit(1)
db.dataset.find().sort({Descargas:+1}).limit(1)

// (2) Conocer la media total de las valoraciones 
db.dataset.aggregate([{$group:{"_id":"_id",
    "Media total de las valoraciones del conjunto":{$avg:"$Media de las valoraciones"}}},
     {$project: {"_id":0}}
])

// (3) Conocer la cantidad de descargas totales del conjunto de aplicaciones
db.dataset.aggregate([{$group:{"_id":"_id", 
    "Descargas totales del conjunto":{$sum:"$Descargas"}}},
    {$project: {"_id":0}}
])

// (4) Conocer el contenido de las aplicaciones mas descargas junto a su media de valoraciones
db.dataset.aggregate([
    {$group:{"_id":"$Contenido",
             "Descargas totales":{"$sum":"$Descargas"},
             "valor":{"$avg":"$Media de las valoraciones"}
            }
    },
    {$project:{"Descargas totales" : 1,
               "Media de valoraciones" : {$trunc: ["$valor",2]}
              }
    },
    {$sort:{"Descargas totales":-1}
    }
])


// (5) Categoria de aplicaciones mas descargas junto a su media de valoraciones 
// y espacio que ocupan en la tienda Google Play Store
db.dataset.aggregate([
    {$group:{"_id":"$Categoria",
             "Descargas totales":{"$sum":"$Descargas"},
             "valor":{"$avg":"$Media de las valoraciones"}
             "tam":{"$sum" : "$Tamaño"}
            }
    },
    {$project:{"Descargas totales" : 1,
               "Media de valoraciones" : {$trunc: ["$valor",2]},
               "Media de valoraciones" : {$ifNull: [ "$valor", "No evaluada"]}
               "Espacio en Google Play Store (MB)" : {$trunc: ["$tam",1]}
        
    }
    },
    {$sort:{"Descargas totales":-1}
    }
])


// (6) Cantidad de descargas de las aplicaciones gratuitas y de pago
db.dataset.aggregate([
  { 
   $facet:{
    "Gratis":[
        {$match: { "Precio" : {$eq: 0}}},
        {$group:{"_id":"_id","Aplicaciones gratuitas":{$sum:"$Descargas"}}},
        {$project: {"_id":0}},
        ],
    "Pago":[
        {$match: { "Precio" : {$gt: 0}}},
        {$group:{"_id":"_id","Aplicaciones de pago":{$sum:"$Descargas"}}},
        {$project: {"_id":0}}
        ]
     }
  },
    {
    $project: {
            "Descargas totales":{
                $setUnion: ["$Gratis","$Pago"]
            }
        }
     }
])

// (7) Media de la cantidad de valoraciones de aplicaciones con mas de 5.000 descargas y menos de 5.000
db.dataset.aggregate([
  { 
   $facet:{
    "a":[
        {$match: { "Descargas" : {$lte: 5000}}},
        {$group:{"_id":"_id","x":{$avg:"$Valoraciones"}}},
        {$project:{"_id":0, "Aplicaciones con menos de 5000 descargas" : {$trunc: ["$x",0]}}}
        ],
    "b":[
        {$match: { "Descargas" : {$gt: 5000}}},
        {$group:{"_id":"_id","y":{$avg:"$Valoraciones"}}},
        {$project:{"_id":0, "Aplicaciones con mas de 5000 descargas" : {$trunc: ["$y",0]}}}
        ]
     }
  },
    {
    $project: {"Media de comentarios":{$setUnion: ["$a","$b"]}}
    },
    {$unwind: "$Media de comentarios"}
])

// (8) Modificacion del campo Idioma String a Array (valor "Multilingüe" a multiples idiomas)

// Añadimos un campo al valor idioma y sobreescribimos en nuestro dataset
db.dataset.aggregate([{$addFields:{"Idioma":{"$split":["$Idioma",","]}}},{$out:"dataset"}])

// Sustituimos Multilingue por el conjunto de idiomas y realizamos la actualizacion oportuna
var query = {"Idioma":"Multilingüe"}
var operacion = {$push:{"Idioma":{$each:["Ingles","Español","Frances","Hindi",
"Ruso","Italiano","Portugues","Aleman"]}}}
db.dataset.updateMany(query,operacion)

// Finalmente extreaemos el valor Multilingüe del campo Idioma de tipo Array
var query = {}
var operacion = {$pull:{"Idioma": "Multilingüe"}}
db.dataset.updateMany(query,operacion)
db.dataset.find()


// (9) Conocer el porcentaje de las aplicaciones segun el idioma
db.dataset.aggregate([
  {$unwind: "$Idioma"},
        {$group:{"_id":"$Idioma","Cantidad":{$sum:1}}},
        {$project: {
        "Cantidad" : true,
        "Porcentaje (%)" : {
            $divide: [{$multiply: ["$Cantidad",100]}, a = db.dataset.find().count()]}
        }
   },
   {$sort: {"Porcentaje (%)": -1}}
])

// (10) Conocer las caracteristicas de la estructura de las aplicaciones realizando una 
// comparacion entre la mejor valorada y la peor valorada por el publico
db.dataset.aggregate([
  { 
   $facet:{
    "a":[
         {$match: {"Usabilidad" : "Alta", "Calidad de la interfaz visual" : "Alta"}},
         {$project: {"_id" : 0 ,"Nombre" : 1, "Elementos desplegables" :1, 
         "Barra de accion" :1, "Sistema de navegacion" :1, "Insercion de datos" : 1, 
         "Transiciones entre pantallas" :1, "Panel lateral" :1}}
         {$sort: {Descargas : -1, Valoraciones : -1, "Media de las valoraciones" : -1}}
         {$limit: 1},
        ],
    "b":[
         {$match: {"Usabilidad" : "Baja", "Calidad de la interfaz visual" : "Baja"}},
         {$project: {"_id" : 0 ,"Nombre" : 1, "Elementos desplegables" :1,
         "Barra de accion" :1, "Sistema de navegacion" :1, "Insercion de datos" : 1,
         "Transiciones entre pantallas" :1, "Panel lateral" :1}}
         {$sort: {Descargas : -1, Valoraciones : -1, "Media de las valoraciones" : -1}}
         {$limit: 1},
        ]
     }
  },
  {$project: {"Tabla Comparativa":{$setUnion: ["$a","$b"]}}},
  {$unwind: "$Tabla Comparativa"}
])

// (11) Conocer si hay alguna empresa que ha realizado mas de una aplicacion
// y extraer cuales ha realizado
db.dataset.aggregate([
      {$group: { 
          _id : "$Desarrollador/es",
          Aplicaciones: {$push: "$Nombre"},
          Count: {$sum:1}
                }
      },
      {$match: {
          Count: {"$gt" : 1}
      }},
      {$project: {
          "Count" : 0
      } },
      {$sort: {"Count" : -1}}
])

