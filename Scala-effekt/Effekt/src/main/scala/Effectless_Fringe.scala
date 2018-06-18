import scala.util.Random

sealed trait BTree
case class BLeaf(value: Int) extends BTree
case class BNode(left: BTree, right: BTree) extends BTree

object Effectless_Fringe {

  sealed trait State
  case class Done() extends Effectless_Fringe.State
  case class Waiting(value: Int, BTrees: List[BTree]) extends Effectless_Fringe.State

  def next(t: List[BTree]): State = {
    t match {
      case BLeaf(v)::xs    => Waiting(v, xs)
      case BNode(l, r)::xs => next(l::r::xs)
      case _              => Done()
    }
  }

  def fringe(t1: BTree, t2: BTree): Boolean = {
    def solve(l: List[BTree], r: List[BTree]): Boolean = {
      (next(l), next(r)) match {
        case (Waiting(v1, k1), Waiting(v2, k2)) => if (v1 == v2) solve(k1, k2) else false
        case (Done(), Done()) => true
        case (_, _) => false
      }
    }
    solve(List(t1), List(t2))
  }

  def generate(i: Int): BTree = {
    val r: Random = Random
    if (i == 0) BLeaf(r.nextInt(100))
    else BNode(generate(i - 1), generate(i - 1))
  }

  def run(t1: BTree, t2: BTree): Boolean = fringe(t1, t2)

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

