import scala.util.Random

object Effectless_Pipes {
  def negate(x: Int): Int = if (x == 0) -1 else x

  def subArraySearch(lst: List[Int]): List[Int] = {
    def subSearch(sum: Int, acc: List[Int], best: List[Int], array: List[Int]): List[Int] = {
      array match {
        case Nil => best
        case next::rest =>
          val new_sum = sum + negate(next)
          val new_acc  = acc:::List(next)
          if (new_sum == 0) subSearch(new_sum, new_acc, new_acc, rest)
          else subSearch(new_sum, new_acc, best, rest)
      }
    }
    subSearch(0, Nil, Nil, lst)
  }

  def findSubArray(list: List[Int]): List[Int] = {
    def findBest(best: List[Int], array: List[Int]): List[Int] = {
      array match {
        case Nil      => best
        case (x::xs)  => {
          val current_best = subArraySearch(x::xs)
          if (current_best.length > best.length) findBest(current_best, xs)
          else findBest(best, xs)
        }
      }
    }
    findBest(Nil, list)
  }

  def generate(i: Int): List[Int] = {
    val r = Random
    def gen(n: Int, acc: List[Int]): List[Int] = {
      if (n == 0) acc
      else gen(n - 1, r.nextInt(2)::acc)
    }
    gen(i, Nil)
  }

  def run(problem: List[Int]): List[Int] = findSubArray(problem)

  def main(args: Array[String]): Unit = {
    if (args.length >= 1) {
      val n = args(0).toInt
      val t = generate(n)
      val now = System.currentTimeMillis()
      run(t)
      val time = System.currentTimeMillis() - now
      println(time)
    }
  }
}
