import effekt._

import scala.annotation.tailrec

trait Choice extends Eff {
  def select(): Op[Boolean]
  def fail(): Op[Int]
}

object NQueens {

  def fail()(implicit u: Use[Choice0]): Control[Int] = use(u) { u.handler.fail() }
  def select()(implicit u: Use[Choice0]): Control[Boolean] = use(u) { u.handler.select() }

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

  def queens(implicit choice: Use[Choice0]): Control[List[(Int, Int)]] = {
    val n = 8

    def choose(list: List[Int]): Control[Int] = {
      list match {
        case Nil => fail()
        case (hd :: tl) => for {
          x <- select()
          y <- if (x) pure(hd) else choose(tl)
        } yield y
      }
    }

    def put_queen(x: Int, qns: List[(Int, Int)]): Control[List[(Int, Int)]] = {
      if (x == 0) return pure(qns)
      for {
        next <- choose(available(n, x, qns))
        result <- put_queen(x - 1, (x,next)::qns)
      } yield result
    }
    put_queen(n, Nil)
  }

  def queensHandler = new Handler.Basic[List[(Int, Int)], List[List[(Int, Int)]]] with Choice0 {

    override def select(): Unit => (Boolean => Unit => Control[List[List[(Int, Int)]]]) => Control[List[List[(Int, Int)]]] =
      _ => resume => for {
        list1 <- resume(true)()
        list2 <- resume(false)()
      } yield list1 ::: list2

    override def fail(): Unit => (Int => Unit => Control[List[List[(Int, Int)]]]) => Control[List[List[(Int, Int)]]] =
      _ => _ => pure(Nil)

    override def unit: List[(Int, Int)] => List[List[(Int, Int)]] = s => List(s)
  }

  val handler: Control[List[List[(Int, Int)]]] = queensHandler { implicit h => queens }

  def main(args: Array[String]): Unit = {
    val result = handler.run()
    println(result)
  }
}



