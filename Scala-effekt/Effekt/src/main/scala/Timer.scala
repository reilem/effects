import java.io.{BufferedWriter, FileWriter}

object Timer {


  def main(args: Array[String]): Unit = {
    val (index, timings) = timer("TEST", 12, 8)

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
    for( i <- 0 to upperBounds){
      val startTime = System.nanoTime()
      for( t <- 0 to iterations) evaluateF(functionName, i)
      val endTime = System.nanoTime()
      val duration: Float = endTime - startTime
      timeColumn = (duration/(1000000*iterations)) :: timeColumn
  }
    (indexColumn.reverse, timeColumn)
  }

  def evaluateF(functionName: String, i: Int) = NQueens.run(i)
}
