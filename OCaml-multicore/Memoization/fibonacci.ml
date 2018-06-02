module Fibonacci : sig
  val solve : int -> int
end =
struct
  effect Put : (int * int) -> unit
  effect Get : int -> int option

  let rec find n ((m1, v1), (m2, v2)) =
    if n = m1 then Some v1 else if n = m2 then Some v2 else None
  ;;

  let rec fibo_mem = function
    | 0 -> 0 | 1 -> 1 | 2 -> 1
    | n -> match perform (Get n) with
      | Some x -> x
      | None   -> let value = fibo_mem (n - 2) + fibo_mem (n - 1) in
          perform (Put (n,value)); value

  let solve n =
    let handler =
      match fibo_mem n with
      | effect (Get n) k    -> (fun s -> continue k (find n s) s)
      | effect (Put tup) k  -> (fun (_, s) -> continue k () (s, tup))
      | x                   -> (fun s -> x)
    in handler ((0, 0), (1, 1))
end
