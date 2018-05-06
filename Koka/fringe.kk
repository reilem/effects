type tree {
  Node( l : tree, r : tree)
  Leaf( value : int)
}

type state {
  Done
  Waiting( i : int, k : (result : ()) -> state)
}

fun show(s: state) {
  match(s) {
    Done -> println("Done")
    Waiting(i, _any) -> {
      print("Waiting: ")
      println(i)
    }
  }
}

effect pause {
  fun wait(i : int) : ()
}

fun step(t : tree) {
  fun walk(w : tree) {
    match(w) {
      Leaf(v)    -> {
        wait(v)
      }
      Node(l, r) -> {
        walk(l)
        walk(r)
      }
    }
  }
  val step_handler = handler {
    wait(v)  -> {
      Waiting(v, resume)
    }
    return _any -> Done
  }
  step_handler(fun() { walk(t) })
}

fun solve(t1: tree, t2: tree) {
  fun stepper(t) {
    return fun() { step(t) }
  }
  fun resumer(k: (result : ()) -> state) {
    return fun() { k( () ) }
  }
  fun fringe(l : () -> state, r : () -> state) : <div, exn> bool {
    val s1 = l()
    val s2 = r()

    match (s1) {
      Waiting(v1, k1) -> {
        match (s2) {
          Waiting(v2, k2) -> if (v1 == v2) fringe(resumer(k1), resumer(k2)) else False
          _               -> False
        }
      }
      Done            -> {
        match (s2) {
          Done            -> True
          _               -> False
        }
      }
    }
  }
  fringe(stepper(t1), stepper(t2))
}



// TESTING CODE

fun print_tree(t : tree) {
  fun printer(p : tree) {
    match(p) {
      Node(l, r) -> {
        print('(')
        printer(l)
        print(',')
        printer(r)
        print(')')
      }
      Leaf(v)    -> print(v)
    }
  }
  printer(t)
  println("")
}

fun tree_test() {
  val t1 = Node(Node(Leaf(3), Leaf(8)), Leaf(4))
  val t2 = Node(Leaf(3), Node(Leaf(8), Leaf(4)))

  print_tree(t1)
  print_tree(t2)
  solve(t1, t2)
}


fun main() {
  tree_test()
}

// :l ../fringe.kk

