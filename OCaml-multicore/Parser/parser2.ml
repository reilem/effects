open Printf

effect One  : unit
effect Plus : unit

let str = "1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1"

let explode s =
  let rec expl i l =
    if i < 0 then l else expl (i - 1) (s.[i] :: l) in
  expl (String.length s - 1) []

let rec program = function
  | '1'::xs       -> perform One; program xs
  | '+'::xs       -> perform Plus; program xs
  | _::xs         -> program xs
  | []            -> 0

let run =
  match program @@ explode str with
  | effect One  k   -> (fun s -> continue k () (1::s))
  | effect Plus k   -> (fun s -> match s with
    | [x]   -> (match continue k () [] with | [y] -> [(x + y)] | _ -> [])
    | _      -> [])
  | x               -> (fun s -> s)

let _ = run []

(* #use "parser2.ml";; *)
