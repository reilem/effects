module Fibonacci : sig
  val solve : int -> int
end =
struct
  effect Put : ((int * int)) -> unit
  effect Get : int -> int option

  let rec find n = function
    | []    -> None
    | (v,x)::r -> if n == v then Some x else find n r

  let rec fibo_mem = function
    | 0 -> 0 | 1 -> 1 | 2 -> 1
    | n -> match perform (Get n) with
      | Some x -> x
      | None -> let value = fibo_mem (n - 1) + fibo_mem (n - 2) in
          perform (Put (n,value)); value

  let solve n =
    let handler =
      match fibo_mem n with
      | effect (Get n) k ->
        (fun s -> continue k (find n s) s)
      | effect (Put tup) k ->
        (fun s -> continue k () (tup::s))
      | x ->
        (fun s -> x)
    in handler []
end
