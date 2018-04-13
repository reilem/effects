import std/time

val number = 10000

effect check {
  fun do_check() : bool
}

fun looper () {
  if ( do_check() ) then looper()
}

val loop_handle = handler(s) {
  return x -> x
  do_check -> resume(s < number, (s+1))
}

fun solve () {
  loop_handle(0, looper)
}

# :l stresstest.kk
