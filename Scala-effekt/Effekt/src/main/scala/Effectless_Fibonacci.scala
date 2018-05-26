
object Effectless_Fibonacci {
  def find(n: Int, l: List[(Int, Int)]): Option[Int] = {
    l match {
      case Nil => None
      case ((k,v)::tl) => if (n == k) Some(v) else find(n, tl)
    }
  }

  def run(n: Int): Int = {
    var state: List[(Int, Int)] = List((0, 0), (1, 1), (2, 1))
    def fibo_mem(m: Int): Int = {
      find(m, state) match {
        case Some(x) => x
        case None    =>
          val value: Int = fibo_mem(m - 2) + fibo_mem(m - 1)
          state = (m, value)::state
          value
      }
    }
    fibo_mem(n)
  }

  def main(args: Array[String]): Unit = {
    if (args.length >= 1) {
      val n = args(0).toInt
      val now = System.currentTimeMillis()
      run(n)
      val time = System.currentTimeMillis() - now
      println(time)
    }
  }
}

