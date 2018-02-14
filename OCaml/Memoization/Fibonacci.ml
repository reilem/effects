open Hashtbl

module Fibonacci : sig
  val solve : int -> int
end =
struct
  effect Put : (int * int) -> unit

  effect Get : int -> int option

  let rec fibo_mem = function
    | 0 -> 1
    | 1 -> 1
    | n -> match perform (Get n) with
      | Some x -> x
      | None -> let value = fibo_mem (n - 1) + fibo_mem (n - 2) in
          perform (Put (n,value)); value

  let solve n =
    let store = Hashtbl.create 100 in
      try fibo_mem n with
      | effect (Put (a,b)) k ->
        Hashtbl.add store a b;
        continue k ()
      | effect (Get n)     k ->
        if Hashtbl.mem store n then
          continue k (Some (Hashtbl.find store n))
        else
          continue k None
end
