import java.io.FileWriter

object Timer {
  def main(args: Array[String]): Unit = {
    // Comment this top line and uncomment one the line below it and run this function to perform a time test
    val list: List[(Int, Float)] = Nil
//    val list: List[(Int, Float)] = timer("NQ", 0, 15, 1, 1)
//    val list: List[(Int, Float)] = timer("FIB", 0, 5000, 25, 100)
//    val list: List[(Int, Float)] = timer("STRS", 0, 500000, 50, 10000)
//    val list: List[(Int, Float)] = timer("PIP", 0, 500, 25, 10)
//    val list: List[(Int, Float)] = timer("FRNG", 0, 13, 25, 1)
//    val list: List[(Int, Float)] = timer("EFLS_NQ", 0, 15, 1, 1)
//    val list: List[(Int, Float)] = timer("EFLS_FIB", 0, 5000, 25, 100)
//    val list: List[(Int, Float)] = timer("EFLS_PIP", 0, 500, 25, 10)
//    val list: List[(Int, Float)] = timer("EFLS_FRNG", 0, 25, 25, 1)

    val csv = new FileWriter("test.csv")
    csv.append("n,x\n")
    list.foreach(t => {
      csv.append(t._1.toString + "," + t._2.toString + "\n")
    })
    csv.close()
    print("DONE")
  }

  def timer(functionName: String, lowerBounds: Int, upperBounds: Int, iterations: Int, step: Int): List[(Int, Float)] = {
    val evaluator = evaluateF(functionName, upperBounds)
    evaluator()
    var timeList: List[(Int, Float)] = Nil
    println("n,x")
    try {
    for(i <- lowerBounds to upperBounds by step) {
      val tester = evaluateF(functionName, i)
      val startTime = System.nanoTime()
      for (_ <- 0 to iterations) tester()
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

  def evaluateF(functionName: String, i: Int): (Unit => Unit) = functionName match {
    case "NQ" => _ => NQueens.run(i)
    case "EFLS_NQ" => _ => Effectless_NQueens.run(i)
    case "STRS" => _ => StressTest.run(i)
    case "FIB" => _ => Fibonacci.run(i)
    case "EFLS_FIB" => _ => Effectless_Fibonacci.run(i)
    case "PIP" =>
      val t = Pipes.generate(i)
      _ => Pipes.run(t)
    case "EFLS_PIP" =>
      val t = Effectless_Pipes.generate(i)
      _ => Effectless_Pipes.run(t)
    case "FRNG" =>
      val t = Fringe.generate(i)
      _ => Fringe.run(t, t)
    case "EFLS_FRNG" =>
      val t = Effectless_Fringe.generate(i)
      _ => Effectless_Fringe.run(t, t)
    case _ => throw new IllegalArgumentException("No such function found")
  }
}
