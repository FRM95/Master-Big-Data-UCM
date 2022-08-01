import scala.io.Source.fromFile
import scala.util.{Failure, Success, Try}

object Utilidades {

  val filePath = "src/adult.data.clean.csv"

  def loadDataset(file: String = filePath): Seq[Contribuyente] = {

    def getDefaultInt(v: String) = Try(v.toInt) match {
      case Success(value) => value
      case Failure(_) => 0
    }

    val rows = fromFile(file).getLines().filterNot(_ == "").map(
      line => {
        val Array(age, workclass, education, educationNum, maritalStatus, occupation, relationship, race, sex, capitalGain, capitalLoss, hoursPerWeek, nativeCountry, income) = line.split(",")
        Contribuyente(
          age = getDefaultInt(age),
          workclass = workclass.replace("\"", ""),
          education = education.replace("\"", ""),
          educationNum = getDefaultInt(educationNum),
          maritalStatus = maritalStatus.replace("\"", ""),
          occupation = occupation.replace("\"", ""),
          relationship = relationship.replace("\"", ""),
          race = race.replace("\"", ""),
          sex = sex.replace("\"", ""),
          capitalGain = getDefaultInt(capitalGain),
          capitalLoss = getDefaultInt(capitalLoss),
          hoursPerWeek = getDefaultInt(hoursPerWeek),
          nativeCountry = nativeCountry.replace("\"", ""),
          income = income.replace("\"", "")
        )
      }
    ).toSeq
    rows
  }
}
