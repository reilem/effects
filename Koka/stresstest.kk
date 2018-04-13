import std/time

effect check {
  fun do_check() : bool
}

fun looper () {
  if ( do_check() ) then looper()
}

val loop_handle = handler(s) {
  return x -> x
  do_check -> resume(s > 0, (s - 1))
}

fun solve (n) {
  loop_handle(n, looper)
}

# :l ../stresstest.kk
