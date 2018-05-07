effect Check : bool

let rec program = function
  | 0 -> 20
  | n -> if perform Check then 15 else program (n - 1)

let handle f n =
  let continue' k value = continue (Obj.clone_continuation k) value in
  match f n with
  | effect Check k -> continue' k true + continue' k false
  | x              -> x

let _ = print_int @@ handle program 60; print_newline ()
