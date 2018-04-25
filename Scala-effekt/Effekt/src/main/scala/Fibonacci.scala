object Fibonacci {

  import effekt._

  trait Table extends Eff {
    def put(pair: (Int, Int)): Op[Unit]
    def get(key: Int): Op[Option[Int]]
  }

  object Pure {

    def put(pair: (Int,Int))(implicit u: Use[Table]): Control[Nothing] = use(u) { u.handler.put(pair) }
    def get(key: Int)(implicit u: Use[Table]): Control[Option[Int]] = use(u) { u.handler.get(key: Int) }

    def fibo_mem(n: Int)(implicit choice: Use[Selector]): Control[Int] = {
      n match {
        case 0 => Pure(0)
        case 1 => Pure(1)
        case 2 => Pure(1)
        case v => get(v) match {
          case Pure(Some(x)) => Pure(x)
          case Pure(None) => for {
            value1 <- fibo_mem(n - 1)
            value2 <- fibo_mem(n - 2)
            result <- put((n, value1+value2))
          } yield value1 + value2
        }
      }
    }

    def find(n: Int, l: List[(Int, Int)]): Option[Int] = {
      l match {
        case Nil => None
        case ((k,v)::tl) => for {
          bool <- n == k
          checkRecursive <- if (bool) Some(v) else find(n, tl)
        } yield checkRecursive
      }
    }

    def fibHandler = new Handler.Stateful[Int, Int, List[(Int, Int)]] with Table {
      override def put(pair: (Int, Int)): List[(Int, Int)] => (Unit => List[(Int, Int)] => Control[Int]) => Control[Int] = state => resume => resume()(pair::state)

      override def get(key: Int): List[(Int, Int)] => (Option[Int] => List[(Int, Int)] => Control[Int]) => Control[Int] = state => resume => resume(find(key,state))(state)

      override def unit: Int => Int = s => s
    }

    val handler = fibHandler { implicit h => fibo_mem(8) }


    def main(args: Array[String]): Unit = {
      val result = handler.run()
      println(result)
    }
  }
}
