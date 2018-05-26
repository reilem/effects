import scala.annotation.tailrec

object Effectless_NQueens {
  def noAttack(i: Int, j: Int, qs: List[(Int, Int)]): Boolean = qs match {
    case Nil => true
    case (k,l) :: tail => i != k && j != l && Math.abs(i - k) != Math.abs(j - l) && noAttack(i, j, tail)
  }

  def available(n: Int, x: Int, qs: List[(Int, Int)]): List[Int] = {
    @tailrec
    def check(acc: List[Int] , y: Int): List[Int] = {
      if (y == 0) acc
      else if (noAttack(x,y,qs)) check(y::acc, y-1)
      else check(acc, y-1)
    }
    check(Nil, n)
  }

  def run(n: Int): List[List[(Int, Int)]] = {
    def place(x: Int, qs: List[(Int, Int)]): List[List[(Int, Int)]] = {
      if (x == 0) {
        List(qs)
      } else {
        def choose(lst: List[Int]): List[List[(Int, Int)]] = {
          lst match {
            case Nil => Nil
            case y::ys => place(x - 1, (x,y)::qs):::choose(ys)
          }
        }
        choose(available(n, x, qs))
      }
    }
    place(n, Nil)
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

