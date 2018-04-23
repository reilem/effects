import std/time

effect choice {
  fun fail() : int
  fun select() : bool
}

fun noAttack (i : int, j : int, lst : list<(int, int)>) : bool {
  match (lst) {
    Nil            -> True
    Cons((k : int, l : int),xs) -> { i != k && j != l && abs(i - k) != abs(j - l) && noAttack(i, j, xs) }
  }
}

fun available (n : int, x : int, qs : list<(int, int)>) {
  fun check (acc : list<int>, y : int) {
    if (y == 0) then acc
    elif (noAttack(x,y,qs)) then check([y] + acc, y - 1)
    else check(acc, y - 1)
  }
  check([], n)
}

fun choose (lst) {
  match (lst) {
    Nil        -> fail()
    Cons(x,xs) -> if (select()) then x else choose(xs)
  }
}

fun queens (n) {
  fun put_queen (x,qns) {
    if (x == 0) then qns
    else {
      val next = choose(available(n, x, qns))
      put_queen(x - 1, [(x, next)] + qns)
    }
  }
  put_queen(n, [])
}

val queens_handler = handler {
  return x  -> [x]
  fail()    -> []
  select()  -> resume(True) + resume(False)
}


fun solve (n : int) {
  fun solver () { queens(n) }
  queens_handler(solver)
}

fun display(result : list<list<(int, int)>>) {
  println("[")
  result.foreach fun(x) {
    print("[")
    val len = x.length()
    var c := 0
    x.foreach fun(y) {
      print("(")
      print(y.fst)
      print(", ")
      print(y.snd)
      if (c == len - 1) then print(")") else print("), ")
      c := c + 1
    }
    println("]")
  }
  println("]")
}

// TIME TESTING CODE

fun gen (x) { return x }

fun timer (f, n : int, m : int)  {
  fun calc_average_time (sum : double, next : int) {
    if (next == 0) then return ((sum / double(m)) / 1000000.0)
    else {
      fun test () { f(gen(n)) }
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
  timer_loop(solve, 0, 10, 20, 1)
  timer_loop(solve, 11, 13, 1, 1)
}

// :l ../nqueens.kk
