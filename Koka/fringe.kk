import std/time/timer
import std/time/duration

type tree {
  Node( l : tree, r : tree)
  Leaf( value : int)
}

type state {
  Done
  Waiting( i : int, k : (result : ()) -> state)
}

// fun show(s: state) {
//   match(s) {
//     Done -> println("Done")
//     Waiting(i, _any) -> {
//       print("Waiting: ")
//       println(i)
//     }
//   }
// }

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

fun show-tree(t : tree) { 
  fun printer(p : tree) {
    match(p) { 
      Node(l, r) -> { 
        "Node(" + printer(l) + "," + printer(r) + ")"
      } 
      Leaf(v:int)    -> "Leaf(" + show(v) + ")"
    }
  }
  printer(t) 
} 



// TIME TESTING CODE

fun gen(x: int) {
  fun random_gen(depth: int) {
    if (depth == 0) Leaf(random-int())
    else Node(random_gen(depth - 1), random_gen(depth - 1))
  }
  random_gen(x)
}

fun timer (f, n : int, m : int)  {
  fun calc_average_time (sum : double, next : int) {
    if (next == 0) then return ((sum / double(m)) / 1000000.0)
    else {
      val t = gen(n)
      fun test () { f(t, t) }
      val (duration, _) = elapsed(test)
      val nanos = double(nano-seconds(duration))
      return calc_average_time(sum + nanos, next - 1)
    }
  }
  return calc_average_time(0.0, m)
}

fun timer_loop(f, start : int, stop : int, avg : int, step : int) {
  fun looper (i : int) {
    if ( i <= stop ) then {
      print(i)
      print(",")
      println(timer(f, i, avg))
      looper(i + step)
    }
  }
  println("n,x")
  looper(start)
}

fun main () {
  timer_loop(solve, 16, 16, 5, 1)
}

// :l ../fringe.kk

