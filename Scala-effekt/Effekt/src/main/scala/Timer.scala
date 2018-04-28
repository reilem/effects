import java.io.FileWriter

object Timer {
  def main(args: Array[String]): Unit = {
    val (index, timings) = timer("TEST", 500000, 10)

    val csv = new FileWriter("test.csv")
    csv.append("n")
    csv.append(",")
    csv.append("x")
    csv.append("\n")
    (index, timings).zipped.foreach((x,y) => {
      csv.append(x.toString)
      csv.append(",")
      csv.append(y.toString)
      csv.append("\n")
    })
    csv.close()
    print("DONE")
  }

  def timer(functionName: String, upperBounds: Int, iterations: Int): (List[Int], List[Float]) = {
    var indexColumn = (0 to upperBounds).toList
    var timeColumn: List[Float] = Nil
    try {
    for( i <- 0 to upperBounds) {
      val startTime = System.nanoTime()
      for (t <- 0 to iterations) evaluateF(functionName, i)
      val endTime = System.nanoTime()
      val duration: Float = endTime - startTime
      timeColumn = (duration / (1000000 * iterations)) :: timeColumn
    }
    } catch {
      case exc: IllegalArgumentException => return (Nil, Nil)
    }
    (indexColumn.reverse, timeColumn)
  }

  def evaluateF(functionName: String, i: Int) = functionName match {
    case "NQ" => NQueens.run(i)
    case "STRESS" => StressTest.run(i)
    case "FIB" => Fibonacci.run(i)
    case _ => throw new IllegalArgumentException("No such function found")
  }
}
