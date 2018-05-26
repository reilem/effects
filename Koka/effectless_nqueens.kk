import std/time

fun noAttack (i : int, j : int, lst : list<(int, int)>) : bool {
  match (lst) {
    Nil                         -> True
    Cons((k : int, l : int),xs) -> { i != k && j != l && abs(i - k) != abs(j - l) && noAttack(i, j, xs) }
  }
}

fun available (n : int, x : int, qs : list<(int, int)>) : div list<int> {
  fun check (acc : list<int>, y : int) {
    if (y == 0) then acc
    elif (noAttack(x,y,qs)) then check([y] + acc, y - 1)
    else check(acc, y - 1)
  }
  check([], n)
}

fun solve (n : int) : div list<list<(int, int)>> {
  fun place (x : int, qs : list<(int, int)>) : div list<list<(int, int)>> {
    if (x == 0) then [qs]
    else {
      fun choose (lst : list<(int)>) : div list<list<(int, int)>> {
        match(lst) {
          Nil        -> Nil
          Cons(y,ys) -> place(x - 1, Cons((x,y), qs)) + choose(ys)
        }
      }
      choose(available(n, x, qs))
    }
  }
  place(n, Nil)
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
      val t = gen(n)
      fun test () { f(t) }
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
  timer_loop(solve, 11, 14, 1, 1)
}

// :l ../effectless_nqueens.kk
