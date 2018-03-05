module Fibonacci : sig
  val solve : int -> int
end =
struct

  let rec find n = function
    | []    -> None
    | (v,x)::r -> if n = v then Some x else find n r
  ;;

  let solve n =
    let lst = ref [] in
    let rec fibo_mem = function
      | 0 -> 0 | 1 -> 1 | 2 -> 1
      | n -> match find n lst with
        | Some x -> x
        | None -> let value = fibo_mem (n - 1) + fibo_mem (n - 2) in
            ref := ((n,value))::!ref); value
    in
end
