open Str

effect Val  : int -> unit
effect Plus : unit
effect Times : unit
effect Minus : unit

let str = "7 - 8 + 99 * 2"

let split s = split_delim (regexp " ") s

let rec program = function
  | "+"::xs       -> perform Plus; program xs
  | "-"::xs       -> perform Minus; program xs
  | "*"::xs       -> perform Times; program xs
  | x::xs         -> perform (Val (int_of_string x)); program xs
  | []            -> 0

let do_op k (op: int -> int -> int) = (fun s -> match s with
  | [x]   -> (match continue k () [] with | [y] -> [op x y] | _ -> [])
  | _      -> [])

let run =
  match program @@ split str with
  | effect (Val n) k   -> (fun s -> continue k () (n::s))
  | effect Plus k   -> do_op k (+)
  | effect Minus k  -> do_op k (-)
  | effect Times k  -> do_op k (fun a b -> a * b)
  | x               -> (fun s -> s)


let _ = run []

(*
#load "str.cma";;
#use "parser2.ml";;
*)
