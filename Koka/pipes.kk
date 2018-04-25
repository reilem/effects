import std/time/timer
import std/time/duration

effect checker {
  fun check(array: list<int>) : ()
}

fun zero_negation(x: int) : int {
  if (x == 0) -1 else 1
}

fun find_sub(array: list<int>) : checker list<int> {
  match(array) {
    Nil        -> Nil
    Cons(_,xs) -> {
      check(array)
      find_sub(xs)
    }
  }
}

val pipes_handler = handler {
  return x -> x
  check(array) -> {
    fun sub_search(sum: int, acc: list<int>, best: list<int>, ary: list<int>) : list<int> {
      match(ary) {
        Nil             -> best
        Cons(next,rest) -> {
          val newsum = sum + zero_negation(next)
          val newacc = acc + [next]
          if (newsum == 0) {
            sub_search(newsum, newacc, newacc, rest)
          } else {
            sub_search(newsum, newacc, best, rest)
          }
        }
      }
    }
    val current_best: list<int> = sub_search(0, [], [], array)
    val next_best: list<int> = resume(())
    if (length(current_best) > length(next_best)) {
      current_best
    } else {
      next_best
    }
  }
}

fun solve(array: list<int>) {
  fun pipes() { find_sub(array) }
  pipes_handler(pipes)
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
      fun test () { f(gen(n)) }
      val (duration, _) = elapsed(test)
      val nanos = double(milli-seconds(duration))
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

// :l ../pipes.kk

