import effekt._

trait Choice extends Eff {
  def select(): Op[Boolean]
  def fail(): Op[Int]
}

object Pure {

  def fail()(implicit u: Use[Choice]): Control[Int] = use(u) { u.handler.fail() }
  def select()(implicit u: Use[Choice]): Control[Boolean] = use(u) { u.handler.select() }

  def prog(implicit choice: Use[Choice]): Control[List[(Int, Int)]] = {
    def choose(list: List[Int]): Control[Int] = {
      list match {
        case Nil => fail()
        case (hd::tl) => for {
          x <- select()
          y <- if (x) pure(hd) else choose(tl)
        } yield y
      }
    }

    for {
      a <- choose(List(1, 2, 3))
      b <- choose(List(4, 5, 6))
      l <- pure(List((a, b)))
    } yield l
  }

  def pureHandler = new Handler.Basic[List[(Int, Int)], List[(Int, Int)]] with Choice {

    override def unit: List[(Int, Int)] => List[(Int, Int)] = identity

    override def select(): Unit => (Boolean => Unit => Control[List[(Int, Int)]]) => Control[List[(Int, Int)]] =
      _ => resume => for {
        list1 <- resume(true)()
        list2 <- resume(false)()
      } yield list1 ::: list2

    override def fail(): Unit => (Int => Unit => Control[List[(Int, Int)]]) => Control[List[(Int, Int)]] =
      _ => _ => pure(Nil)
  }

  val handler: Control[List[(Int, Int)]] = pureHandler { implicit h => prog }

  def main(args: Array[String]): Unit = {
    val result = handler.run()
    println(result)
  }
}



