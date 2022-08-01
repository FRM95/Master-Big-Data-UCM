case class Contribuyente(
                    age: Int,
                    workclass: String,
                    education: String,
                    educationNum: Int,
                    maritalStatus: String,
                    occupation: String,
                    relationship: String,
                    race: String,
                    sex: String,
                    capitalGain: Int,
                    capitalLoss: Int,
                    hoursPerWeek: Int,
                    nativeCountry: String,
                    income: String
                  )

// Implementa el companion object
// ejercicio-9:
// Dada la clase 'Contribuyente' y es a la que se mapea cada fila del csv, se pide que se cree su companion object y
// definan las funciones:
//  - imprimeDatos que muestre por consola el siguiente formato: "$workclass - $occupation - $nativeCountry - $income"
//  - apply, que no reciba ningún parámetro y que devolverá una instancia de la clase Contribuyente con aquellos campos que sean:
//     del tipo Int inicializados a -1
//     del tipo String inicializado a "desconocido"

/*
  Solucion: Definimos un objeto companion con la funcion imprimeDatos, la cual recibe un parametro c de tipo Seq[Contribuyente]
  (a imprimeDatos se le pasara un parametro del tipo Seq[Contribuyente] y no un objeto Contribuyente ya que el dataset es de tipo Seq[]
  y queremos poder usarla para recorrer e imprimir todos los valores de la lista de contribuyentes)
  De igual manera se define el metodo apply que crea una instancia p de clase Contribuyente con parametros predefinidos
*/

object Contribuyente {

  def imprimeDatos(c: Contribuyente): Unit = {
    println(s"${c.workclass} - ${c.occupation} - ${c.nativeCountry} - ${c.income}\n" )
  }

  def apply(): Contribuyente = {
    val p = Contribuyente(age = -1, workclass = "desconocido", education = "desconocido", educationNum = -1, maritalStatus = "desconocido", occupation = "desconocido", relationship = "desconocido", race = "desconocido", sex = "desconocido", capitalGain = -1, capitalLoss = -1, hoursPerWeek = -1, nativeCountry = "desconocido", income = "desconocido")
    p
  }
}

