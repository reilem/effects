
effect One  : unit
effect Plus : bool

let str = "+ 1 + 2 1"

let explode s =
  let rec expl i l =
    if i < 0 then l else
      let chr = s.[i] in
        if chr == ' ' then expl (i - 1) l else expl (i - 1) (s.[i] :: l)
     in
  expl (String.length s - 1) []

let rec program = function
  | '1'::xs       -> 1
  | '2'::xs       -> 2
  | '3'::xs       -> 3
  | '+'::(x::xs)  -> if perform Plus then program (x::xs) else program xs
  | _::xs         -> program xs
  | []            -> 0


let run =
  match program @@ explode str with
  | effect Plus k   -> (continue (Obj.clone_continuation k) true) + (continue (Obj.clone_continuation k) false)
  | x               -> x


(* #use "parser2.ml";; *)
