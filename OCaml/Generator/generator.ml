open Random
open Pervasives

module Generator : sig
val NQ      : int -> int
val RR      : int -> int
val BS      : int -> int list
val PRS     : int -> string
val TREE    : int -> int list
val STRESS  : int -> int list
end =
struct

let NQ n = n

let rec BS n =
    match n with
    | 0 -> []
    | _ -> Random.int 2 :: (BS (n-1))

let randomExp case =
    let bit1 = Random.int 2 in
    let bit2 = Random.int 2 in
    match case with
    | 0 -> ("AND " ^ (string_of_int bit1)) ^ (string_of_int bit2)
    | 1 -> ("OR " ^ (string_of_int bit1)) ^ (string_of_int bit2)
    | 2 -> "NOT " ^ (string_of_int bit1)

let rec PRS n =
    match n with
    | 0 -> ""
    | _ -> (randomExp (Random.int 3)) ^ (BS (n-1))



end
