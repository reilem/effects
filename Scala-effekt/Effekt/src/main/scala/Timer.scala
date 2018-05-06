import java.io.FileWriter

object Timer {
  def main(args: Array[String]): Unit = {
//    val list: List[(Int, Float)] = timer("NQ", 0, 15, 1, 1)
//    val list: List[(Int, Float)] = timer("FIB", 0, 5000, 25, 100)
    val list: List[(Int, Float)] = timer("STRS", 0, 500000, 50, 10000)

    val csv = new FileWriter("test.csv")
    csv.append("n,x\n")
    list.foreach(t => {
      csv.append(t._1.toString + "," + t._2.toString + "\n")
    })
    csv.close()
    print("DONE")
  }

  def timer(functionName: String, lowerBounds: Int, upperBounds: Int, iterations: Int, step: Int): List[(Int, Float)] = {
    evaluateF(functionName, upperBounds)
    var timeList: List[(Int, Float)] = Nil
    println("n,x")
    try {
    for(i <- lowerBounds to upperBounds by step) {
      val startTime = System.nanoTime()
      for (_ <- 0 to iterations) evaluateF(functionName, i)
      val endTime = System.nanoTime()
      val duration: Float = endTime - startTime
      val res = duration / (1000000 * iterations)
      println(i.toString + "," + res.toString)
      timeList = timeList:::List((i,res))
    }
    } catch {
      case exc: IllegalArgumentException => return Nil
    }
    timeList
  }

  def evaluateF(functionName: String, i: Int) = functionName match {
    case "NQ" => NQueens.run(i)
    case "STRS" => StressTest.run(i)
    case "FIB" => Fibonacci.run(i)
    case _ => throw new IllegalArgumentException("No such function found")
  }
}
