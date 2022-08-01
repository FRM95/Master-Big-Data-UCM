
trait Analizador extends App {

  // Implementa la función en el objeto que extienda este trait.
  // ejercicio-11
  // Al extender Analizador, pedirá que se implemente la función abstracta imprimeContribuyentes,
  // la cual hará uso de la función imprimeDatos del companion object definido en el ejercicio 9.

  /*
  Solucion: Se aplica la funcion imprimeDatos del objeto Companion Contribuyente para
  cada valor de c (accedemos a cada valor de c mediante la funcion map)
  */

  def imprimeContribuyentes(c: Seq[Contribuyente]): Unit = {
    c.map(Contribuyente.imprimeDatos(_))
  }
}
