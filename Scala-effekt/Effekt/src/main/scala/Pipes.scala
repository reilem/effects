import effekt._

import scala.util.Random

trait Checker extends Eff {
  def check(array: List[Int]): Op[Unit]
}

object Pipes {

  def check(array: List[Int])(implicit u: Use[Checker]): Control[Unit] = use(u) { u.handler.check(array) }

  def negate(n: Int): Int = {
    if (n == 0) -1 else n
  }

  def findSubArray(array: List[Int])(implicit handler: Use[Checker]): Control[List[Int]] = {
    array match {
      case Nil => pure(Nil)
      case (hd :: tl) => for {
        _ <- check(hd::tl)
        res <- findSubArray(tl)
      } yield res
    }
  }

  def subSearch(sum: Int, acc: List[Int], best: List[Int], array: List[Int]): List[Int] = {
    array match {
      case Nil => best
      case (next :: rest) => {
        val newSum = sum + negate(next)
        val newAcc = acc ::: List(next)
        if (newSum == 0) subSearch(newSum, newAcc, newAcc, rest)
        else subSearch(newSum, newAcc, best, rest)
      }
    }
  }

  def pipesHandler = new Handler.Basic[List[Int], List[Int]] with Checker {
    override def check(array: List[Int]): Unit => (Unit => Unit => Control[List[Int]]) => Control[List[Int]] =
      _ => resume => {
        val currentBest = subSearch(0, Nil, Nil, array)
        for {
          nextBest <- resume()()
        } yield if (currentBest.length > nextBest.length) currentBest else nextBest
      }

    override def unit: List[Int] => List[Int] = identity
  }

  def generate(i: Int): List[Int] = {
    val r = Random
    def gen(n: Int, acc: List[Int]): List[Int] = {
      if (n == 0) acc
      else gen(n - 1, r.nextInt(2)::acc)
    }
    gen(i, Nil)
  }

  def run(problem: List[Int]): List[Int] = pipesHandler { implicit h => findSubArray(problem) }.run()

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

