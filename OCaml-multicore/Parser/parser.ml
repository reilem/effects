module Parser : sig
  (* Takes a string and parses it *)
  val solve : string -> bool
end =
struct
  exception Unrecognized_Symbol
  exception Parse_Error

  effect True : unit
  effect False : unit
  effect And: unit
  effect Or: unit
  effect Not: unit
  effect L_Br: unit
  effect R_Br: unit

  type 'a state =
    | State of bool list
    | Resume of bool list * (unit, 'a state -> 'a state) continuation

  let error () = raise Parse_Error

  let empty = State []

  let append k b = function
    | State s -> continue k () (State (b::s))
    | _       -> error ()

  let resume k = function
    | State s -> Resume (s, k)
    | _       -> error ()

  let binary_operation k f = function
    | State [x] -> (match continue k () empty with
      | State [y]       -> State [f x y]
      | Resume ([y],k') -> continue k' () @@ State [f x y]
      | _               -> error ())
    | _         -> error ()

  let unary_operation k f = function
    | State [] -> (match continue k () empty with
      | State [x]       -> State [f x]
      | Resume ([x],k') -> continue k' () @@ State [f x]
      | _               -> error ())
    | _        -> error ()

  let str_to_char_list s =
    let rec to_list i l =
      if i < 0 then l else to_list (i - 1) (s.[i] :: l) in
    to_list (String.length s - 1) []

  let rec parse = function
    | '1'::xs           -> perform True; parse xs
    | '0'::xs           -> perform False; parse xs
    | 'A'::'N'::'D'::xs -> perform And; parse xs
    | 'O'::'R'::xs      -> perform Or; parse xs
    | 'N'::'O'::'T'::xs -> perform Not; parse xs
    | '('::xs           -> perform L_Br; parse xs
    | ')'::xs           -> perform R_Br; parse xs
    | ' '::xs           -> parse xs
    | []                -> false
    | v::xs             -> raise Unrecognized_Symbol

  let solve str =
    let solver =
      match parse @@ str_to_char_list str with
      | effect And k   -> binary_operation k (&&)
      | effect Or k    -> binary_operation k (||)
      | effect Not k   -> unary_operation  k (not)
      | effect L_Br k  -> (fun s -> continue k () empty)
      | effect R_Br k  -> resume k
      | effect True k  -> append k true
      | effect False k -> append k false
      | x              -> (fun s -> s)
    in
    match solver empty with
    | State [x] -> x
    | _         -> false
end
