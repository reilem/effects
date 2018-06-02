module Fibonacci : sig
  val solve : int -> int
end =
struct
  let rec find n ((m1, v1), (m2, v2)) =
    if n = m1 then Some v1 else if n = m2 then Some v2 else None
  ;;

  let solve n =
    let state = ref ((0, 0), (1, 1))  in
      let rec fibo_mem m = match find m !state with
        | Some x -> x
        | None -> let value = fibo_mem (m - 2) + fibo_mem (m - 1) in
            let ((n1, v1),(n2,v2)) = !state in state := ((n2, v2),(m, value)); value
      in fibo_mem n
end

(* let _ = print_int @@ Fibonacci.solve 10000 *)
