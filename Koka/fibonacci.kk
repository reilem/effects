import std/time

effect state {
  fun put(x : int, y : int) : ()
  fun get(x : int) : int
}

fun find (n: int, lst: list<(int, int)>) : int {
  match(lst) {
    Nil        -> -1
    Cons(x,xs) -> if (n == x.fst()) then x.fst() else find(n, xs)
  }
}

fun fibo_mem (n : int) : <state,div,console> int {
  if (n <= 0) then 0
  elif (n == 1 || n == 2) then 1
  else {
    val x = get(n)
    if (x != -1) then x
    else {
      val y = fibo_mem(n - 2) + fibo_mem(n - 1)
      put(n, y)
      y
    }
  }
}

fun solve (n : int) {
  val fibo_handler = handler (s : list<(int, int)>) {
    return x -> x
    get (i)  -> resume(find(i, s), s)
    put (x, y) -> resume((), [(x,y)] + s)
  }
  fun fibonacci () {
    fibo_mem(n)
  }
  fibo_handler([], fibonacci)
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

// :l ../fibonacci.kk
