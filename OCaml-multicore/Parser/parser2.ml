open Str

effect Val  : int -> unit
effect Plus : unit

let str = "7 + 8 + 99"

let split s = split_delim (regexp " ") s

let rec program = function
  | "+"::xs       -> perform Plus; program xs
  | x::xs         -> perform (Val (int_of_string x)); program xs
  | []            -> 0

let run =
  match program @@ split str with
  | effect (Val n) k   -> (fun s -> continue k () (n::s))
  | effect Plus k   -> (fun s -> match s with
    | [x]   -> (match continue k () [] with | [y] -> [(x + y)] | _ -> [])
    | _      -> [])
  | x               -> (fun s -> s)


let _ = run []

(*
#load "str.cma";;
#use "parser2.ml";;
*)
