import NQueens.run
import effekt._

trait State extends Eff {
  def put(pair: (Int, Int)): Op[Unit]
  def get(key: Int): Op[Option[Int]]
}

object Fibonacci {

  def put(pair: (Int,Int))(implicit u: Use[State]): Control[Unit] = use(u) { u.handler.put(pair) }
  def get(key: Int)(implicit u: Use[State]): Control[Option[Int]] = use(u) { u.handler.get(key: Int) }

  def find(n: Int, l: List[(Int, Int)]): Option[Int] = {
    l match {
      case Nil => None
      case ((k,v)::tl) => if (n == k) Some(v) else find(n, tl)
    }
  }

  def fibo_mem(n: Int)(implicit state: Use[State]): Control[Int] = {
    n match {
      case 0 => pure(0)
      case 1 | 2 => pure(1)
      case _ => for {
        c <- get(n)
        v <- c match {
          case Some(x) => pure(x)
          case None => for {
            v1 <- fibo_mem(n - 1)
            v2 <- fibo_mem(n - 2)
            _  <- put((n, v1 + v2))
          } yield v1 + v2
        }
      } yield v
    }
  }

  def fibHandler = new Handler.Stateful[Int, Int, List[(Int, Int)]] with State {
    override def put(pair: (Int, Int)): List[(Int, Int)] => (Unit => List[(Int, Int)] => Control[Int]) => Control[Int]
    = state => resume => resume()(pair::state)

    override def get(key: Int): List[(Int, Int)] => (Option[Int] => List[(Int, Int)] => Control[Int]) => Control[Int]
    = state => resume => resume(find(key,state))(state)

    override def unit: Int => Int = s => s
  }

  def run(bound: Int): Int = fibHandler(Nil) { implicit h => fibo_mem(bound) }.run()

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

