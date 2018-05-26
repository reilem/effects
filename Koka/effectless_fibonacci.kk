import std/time

fun find (n: int, lst: list<(int, int)>) : int {
  match(lst) {
    Nil        -> -1
    Cons((i, j),xs) -> if (n == i) then j else find(n, xs)
  }
}

fun solve (n : int) : div int {
  var state : list<(int, int)> := [(0, 0), (1, 1), (2, 1)]
  fun fibo_mem(m : int) : <div, read<_h>,write<_h>> int {
    val x = find(m, state)
    if (x != -1) then x
    else {
      val y = fibo_mem(m - 2) + fibo_mem(m - 1)
      state := Cons((m, y), state)
      y
    }
  }
  fibo_mem(n)
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
  timer_loop(solve, 0, 5000, 25, 100)
}

// :l ../effectless_fibonacci.kk
