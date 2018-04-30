import NQueens.run
import effekt._

trait Stress extends Eff {
  def check(): Op[Boolean]
}

object StressTest {

  def check()(implicit u: Use[Stress]): Control[Boolean] = use(u) { u.handler.check() }

  def test()(implicit state: Use[Stress]): Control[Unit] = {
    for {
      check <- check()
      res   <- if (check) test() else pure()
    } yield res
  }

  def stressHandler = new Handler.Stateful[Unit, Unit, Int] with Stress {
    override def check(): Int => (Boolean => Int => Control[Unit]) => Control[Unit] =
      state => resume => resume(state > 0)(state - 1)
    override def unit: Unit => Unit = identity
  }

  def run(upperBound: Int): Unit = stressHandler(upperBound) { implicit h => test() }.run()

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

