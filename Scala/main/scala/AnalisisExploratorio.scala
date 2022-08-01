
/*
Alumno: Miguel Moreno Mardones
Master Big Data UCM - Modulo: Scala
Fecha 28/06/2022
 */

object AnalisisExploratorio extends Analizador {

  // ejercicio-1:
  // Popula la variable dataset con el resultado de la función loadDataset de Utilidades.
  // Ten en cuenta que se carga el csv completo, incluyendo las cabeceras, asegúrate de omitirlas (la primera fila).

  /*
  Solucion: Cargamos el dataset (salvo la primera fila mediante tail) llamando al metodo loadDataset del objeto utilidades
   */

  val dataset = Utilidades.loadDataset().tail

  // Implementa la función
  // ejercicio-2:
  // Número total de registros en el dataset.

  /*
  Solucion: Checkeamos que el parametro c no sea null y sea del tipo Seq[Contribuyente] y extraemos la longitud de la lista
   */

  def totalDeRegistros(c: Seq[Contribuyente]): Int = {
    if (c!=null && !c.isEmpty) {
      c.size
    } else {
      0
    }
  }

  // Implementa la función
  // ejercicio-3:
  // Calcular la media de edad de todos los contribuyentes

  /*
  Solucion: Comprobamos que el parametro c no sea null y sea del tipo Seq[Contribuyente]
  Hacemos uso de la funcion map extrayendo para cada contribuyente el valor de age y realizamos el sumatorio
  Tras esto, lo dividimos por el numero total de registros
   */

  def calculaEdadMedia(c: Seq[Contribuyente]): Double = {
    if (c!=null && !c.isEmpty) {
      c.map(contribuyente => contribuyente.age).sum/totalDeRegistros(c)
    } else {
      0.0
    }
  }


  // Implementa la función
  // ejercicio-4:
  // Calcular la media de edad de todos los contribuyentes que nunca se han casado.
  // hint: marital-status = Never-Married

  /*
  Solucion: Creamos una variable inmutable que contiene los contribuyentes nunca casados del parametro c
  Para cada valor de la lista, obtenemos la edad, realizamos el sumatorio y lo divividimos por el total
   */

  def calculaEdadMediaNeverMarried(c: Seq[Contribuyente]): Double = {
    if (c!=null && !c.isEmpty) {
      val neverMarried = c.filter(x => x.maritalStatus == "Never-married")
      neverMarried.map(x => x.age).sum/totalDeRegistros(neverMarried)
    } else {
      0.0
    }
  }


  // Implementa la función
  // ejercicio-5:
  // Descubrir los distintos países de donde provienen los contribuyentes

  /*
  Solucion: Extraemos la faceta de pais al parametro c y aplicamos la funcion distinct
   */

  def paisesOrigenUnicos(c: Seq[Contribuyente]): Seq[String] = {
    if (c!=null && !c.isEmpty) {
      (c.map(x => x.nativeCountry)).distinct
    } else {
      Seq("")
    }
  }


  // Implementa la función
  // ejercicio-6:
  // De todos los contribuyentes, ¿cómo se distribuye por género?. Devuelve el porcentaje de hombres
  // y el de mujeres, en ese orden, (porcentajeDeHombres, porcentajeDeMujeres)

  /*
  Solucion: Creamos dos variables auxiliares que filtran la cantidad de contribuyentes en base a su genero
  Tras esto, se devuelve una tupla con el porcentaje (no se especifica un redondeo por lo que no se modifica un redondeo)
   */

  def distribucionPorGeneros(c: Seq[Contribuyente]): (Double, Double) = {
    if (c!=null && !c.isEmpty) {
      val varMale = (c.filter(x=>x.sex=="Male")).size.toDouble
      val varFemale = (c.filter(x=>x.sex=="Female")).size.toDouble
      (100/((varMale+varFemale)/varMale),100/((varMale+varFemale)/varFemale))
    }else {
      (0.0,0.0)
    }
  }


  // Implementa la función
  // ejercicio-7:
  // Encuentra el tipo de trabajo (workclass) mejor remunerado. El trabajo mejor remunerado es aquel trabajo donde el
  // porcentaje de los contribuyentes que perciben ingresos (income) superiores a ">50K" es mayor que los contribuyentes
  // cuyos ingresos son "<50K".

  /*
  Solucion: Creamos una variable resultado que mide la cantidad de contribuyentes asociados a cada trabajo y tipo de salario
  Creamos otra variable que por grupos de trabajos, filtra aquellos que cumplen la condicion de mejor pagados
  Se realiza una conversion a tipo String de los tipos del HashMap y filtramos la key de aquella que cumple la condicion
   */

  def trabajoMejorRemunerado(c: Seq[Contribuyente]): String = {
    if(c!=null && !c.isEmpty){
      val resultado = c.groupMap(_.workclass)(_.income)
      val resultado2 = resultado.groupMap(_._1)(x => (x._2.filter(_ == ">50K").length > x._2.filter(_ == "<=50K").length))
      val resultado3 = resultado2.map(x => (x._1, x._2.mkString)).filter(_._2 == "true").map(_._1).mkString
      resultado3
    } else {
      ""
    }


  }

  // Implementa la función
  // ejercicio-8:
  // Cuál es la media de años de educación (education-num) de aquellos contribuyentes cuyo país de origen no es
  // United-States

  /*
  Solucion: Realizamos un filtro de contribuyentes con pais de origen distinto a United-States obteniendo
  la suma de sus años de educacion para asi dividirlo por el total de individuos filtrados
  */

  def aniosEstudiosMedio(c: Seq[Contribuyente]): Double = {
    if (c!=null && !c.isEmpty) {
      c.filter(_.nativeCountry!="United-States").map(_.educationNum).sum/c.filter(_.nativeCountry!="United-States").size
    } else {
     0.0
    }
  }

  println(s" -> Dataset tiene un total de registros: ${totalDeRegistros(c = dataset)}")
  println(s" -> En el dataset, los contribuyentes tienen una edad media: ${calculaEdadMedia(c = dataset)}")
  println(s" -> En el dataset, los contribuyentes que nunca se casaron tienen una edad media: ${calculaEdadMediaNeverMarried(c = dataset)}")
  println(s" -> Los contribuyentes proviende de distintos países como: ${paisesOrigenUnicos(c = dataset).mkString(",")}")
  println(s" -> Los contribuyentes se distribuyen en (hombres - mujeres): ${distribucionPorGeneros(c = dataset)}")
  println(s" -> El tipo de trabajo mejor remunerado en el dataset es: ${trabajoMejorRemunerado(c = dataset)}")
  println(s" -> La media de años de estudio de los contribuyenes de origen distinto a United States es: ${aniosEstudiosMedio(c = dataset)}")


  // ejercicio-12
  // llama a la función imprimeContribuyentes pasándole los primeros 5 contribuyentes del dataset.

  /*
  Solucion: Al pertenecer AnalisisExploratorio al trait Analizador (mediante extend) podemos acceder a los miembros
  de Analizador mediante la palabra super, llamamos a imprimeContribuyentes pasandole los primeros 5 contribuyentes
  */

  super.imprimeContribuyentes(dataset.take(5))

}
