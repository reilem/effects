import effekt._

import scala.util.Random

trait Waiter extends Eff {
  def wait(value: Int): Op[Unit]
}

sealed trait Tree
case class Leaf(value: Int) extends Tree
case class Node(left: Tree, right: Tree) extends Tree

object Fringe {

  sealed trait State
  case class Done() extends Fringe.State
  case class Waiting(value: Int, continuation: Unit => Unit => Control[Fringe.State]) extends Fringe.State

  def wait(value: Int)(implicit u: Use[Waiter]): Control[Unit] = use(u) { u.handler.wait(value) }

  def step(t: Tree): Control[Fringe.State] = {
    def walk(tree: Tree)(implicit handler: Use[Waiter]): Control[Unit] = {
      tree match {
        case Leaf(v) => wait(v)
        case Node(left, right) => for {
          _ <- walk(left)
          _ <- walk(right)
        } yield ()
      }
    }
    def walkHandler = new Handler.Basic[Unit, Fringe.State] with Waiter {
      override def wait(value: Int): Unit => (Unit => Unit => Control[Fringe.State]) => Control[Fringe.State] =
        _ => resume => pure(Waiting(value, resume))
      override def unit: Unit => Fringe.State = _ => Done()
    }
    pure(walkHandler { implicit h => walk(t) }.run())
  }


  def fringe(t1: Tree, t2: Tree): Boolean = {
    def stepper(t: Tree)                                : Unit => Control[Fringe.State] = _ => step(t)
    def resume(k: Unit => Unit => Control[Fringe.State]): Unit => Control[Fringe.State] = k()
    def solve(l: Unit => Control[Fringe.State], r: Unit => Control[Fringe.State]): Control[Boolean] = for {
      left <- l()
      right <- r()
      result <- (left, right) match {
        case (Waiting(v1, k1), Waiting(v2, k2)) => if (v1 == v2) solve(resume(k1), resume(k2)) else pure(false)
        case (Done(), Done()) => pure(true)
        case (_, _) => pure(false)
      }
    } yield result
    solve(stepper(t1), stepper(t2)).run()
  }

  def generate(i: Int): Tree = {
    val r: Random = Random
    if (i == 0) Leaf(r.nextInt(100))
    else Node(generate(i - 1), generate(i - 1))
  }

  def run(t1: Tree, t2: Tree): Boolean = fringe(t1, t2)

  def main(args: Array[String]): Unit = {
    if (args.length >= 1) {
      val n = args(0).toInt
      val t = generate(n)
      val now = System.currentTimeMillis()
      run(t, t)
      val time = System.currentTimeMillis() - now
      println(time)
    }
  }
}

