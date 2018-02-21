open Random
open Pervasives

module Generator : sig
  val nqueens : int -> int
  val pipes   : int -> int list
  val parse   : int -> string
  val stress  : int -> int
  val fibo    : int -> int
  (* val rr      : int -> int
  val tree    : int -> int list *)
end =
struct
  let id x = x

  let nqueens = id
  let stress = id
  let fibo = id

  let rec pipes n =
    match n with
    | 0 -> []
    | _ -> Random.int 2 :: (pipes (n-1))

  let randomExp case =
    let bit1 = Random.int 2 in
    let bit2 = Random.int 2 in
    match case with
    | 0 -> ("AND " ^ (string_of_int bit1)) ^ (string_of_int bit2)
    | 1 -> ("OR " ^ (string_of_int bit1)) ^ (string_of_int bit2)
    | 2 -> "NOT " ^ (string_of_int bit1)
    | _ -> ""

  let rec parse n =
    match n with
    | 0 -> ""
    | _ -> (randomExp (Random.int 3)) ^ (parse (n-1))
end
