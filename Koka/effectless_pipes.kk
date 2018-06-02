import std/time

fun negate' (x: int): int {
  if (x == 0) then -1 else x
}

fun subarray_search (lst: list<int>): list<int> {
  fun sub_search(sum: int, acc: list<int>, best: list<int>, array: list<int>): list<int> {
    match (array) {
      Nil -> best
      Cons(next, rest) -> {
        val newsum: int = sum + negate'(next)
        val newacc = acc + [next]
        if (newsum == 0) then
          sub_search(newsum, newacc, newacc, rest)
        else
          sub_search(newsum, newacc, best, rest)
      } 
    }
  }
  sub_search(0, Nil, Nil, lst)
}

fun solve (lst: list<int>) {
  fun find_best(best: list<int>, array: list<int>) {
    match (array) {
      Nil -> best
      Cons(x,xs) -> {
        val current_best = subarray_search(Cons(x,xs))
        if (length(current_best) > length(best)) then find_best(current_best, xs)
        else find_best(best, xs)
      } 
    }
  }
  find_best(Nil, lst)
}

// TIME TESTING CODE

fun gen(x: int) {
  fun rando(): ndet int {
    if (random-bool()) 1 else 0
  }
  fun random_gen(n: int, acc: list<int>) {
    if (n == 0) acc
    else random_gen(n - 1, [rando()] + acc)
  }
  random_gen(x, [])
}

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
  timer_loop(solve, 0, 500, 25, 10)
}

// :l ../effectless_pipes.kk