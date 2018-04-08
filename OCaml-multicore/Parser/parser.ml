open Printf

module Parser : sig
  (* Takes a string and parses it *)
  val solve : string -> bool list
end =
struct
  exception Unrecognized_Symbol

  effect True : unit
  effect False : unit
  effect And: unit
  effect Or: unit
  effect Not: unit
  effect L_Br: unit
  effect R_Br: unit

  let explode s =
    let rec expl i l =
      if i < 0 then l else
      expl (i - 1) (s.[i] :: l) in
    expl (String.length s - 1) []

  let rec parse = function
    | '1'::xs           -> perform True; parse xs
    | '0'::xs           -> perform False; parse xs
    | 'A'::'N'::'D'::xs -> perform And; parse xs
    | 'O'::'R'::xs      -> perform Or; parse xs
    | 'N'::'O'::'T'::xs -> perform Not; parse xs
    (* | '('::xs           -> perform L_Br; parse xs
    | ')'::xs           -> perform R_Br; parse xs *)
    | ' '::xs           -> parse xs
    | []                -> false
    | v::xs             -> raise Unrecognized_Symbol

  let solve str =
    let s = ref [] in
    let solver =
      match parse @@ explode str with
      | effect And k   -> (fun s ->
        printf "And\n";
        match s with
        | [x]   -> (match continue k () [] with | [y] -> [x && y] | _ -> [])
        | _      -> [])
      | effect Or k    -> (fun s ->
        printf "Or\n";
        match s with
        | [x]   -> (match continue k () [] with | [y] -> [x || y] | _ -> [])
        | _      -> [])
      | effect Not k   -> (fun s ->
        printf "Not\n";
        match continue k () [] with
        | [y] -> [not y]
        | _   -> []
        )
      (* | effect L_Br k  -> printf "L\n"; (fun s -> continue k () [])
      | effect R_Br k  -> printf "R\n"; (fun s -> s) *)
      | effect True k  -> printf "True\n"; (fun s -> continue k () (true::s))
      | effect False k -> printf "False\n"; (fun s -> continue k () (false::s))
      | x              -> printf "End\n"; (fun s -> s)
    in solver []
end

let _ = Parser.solve "NOT 1 OR 1"

(*
#use "parser.ml";;
*)
