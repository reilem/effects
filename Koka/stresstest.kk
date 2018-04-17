import std/time

effect check {
  fun do_check() : bool
}

fun looper () {
  if ( do_check() ) then looper()
}

fun solve (n : int) {
  val loop_handler = handler (s : int) {
    return x -> x
    do_check -> resume(s > 0, (s - 1))
  }
  loop_handler(n, looper)
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
  timer_loop(solve, 10000, 500000, 50, 10000)
}

// :l ../stresstest.kk
