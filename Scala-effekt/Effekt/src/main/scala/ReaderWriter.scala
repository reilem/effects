import effekt._

object ReaderWriter {

  import Reader._, Writer._

  // The effect signature
  trait Reader[S] extends Eff {
    def read(): Op[S]
  }
  trait Writer[S] extends Eff {
    def write(s: S): Op[Unit]
  }

  // Companion Boilerplate to make ops more elegant
  object Reader {
    def read[S]()(implicit u: Use[Reader[S]]) = use(u) { u.handler.read() }
  }
  object Writer {
    def write[S](s: S)(implicit u: Use[Writer[S]]) = use(u) { u.handler.write(s) }
  }

  // Handler of Reader and Writer Effects Combined
  def rwHandler[R, S] = new Reader[S] with Writer[S] with Handler.Stateful[R, R, List[S]] {

    def unit = a => a

    def read() = {
      case s :: rest => resume => resume(s)(rest)
      case _ => sys error "Not enough elements written to perform read"
    }
    def write(s: S) = rest => resume => resume(())(s :: rest)
  }

  def example(implicit r: Use[Reader[Int]], w: Use[Writer[Int]]): Control[Int] =
    for {
      _ <- write(5)
      _ <- write(9)
      x <- read()
      _ <- write(x * 11111)
      y <- read()
    } yield y

    def main(args: Array[String]): Unit = {
      val result = rwHandler(Nil) { implicit rw => example }.run()
      println(result)
    }
  }


