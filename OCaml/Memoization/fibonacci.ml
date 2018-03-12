module Fibonacci : sig
  val solve : int -> int
end =
struct
  let rec find n = function
    | []       -> None
    | ((v:int), (x:int))::r -> if n = v then Some x else find n r
  ;;

  let solve n =
    let lst = ref [(0,0);(1,1);(2,1)]  in
      let rec fibo_mem = function
        | m -> match find m !lst with
          | Some x -> x
          | None -> let value = fibo_mem (m - 1) + fibo_mem (m - 2) in
              lst := ((m,value)::!lst); value
      in fibo_mem n
end

let _ = Fibonacci.solve 10000
