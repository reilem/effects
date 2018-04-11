open List
open Printf

module Parser : sig
  (* Takes a string and parses it *)
  val solve : string -> bool
end =
struct
  exception Unrecognized_Symbol
  exception Parse_Error

  let explode s =
    let rec expl i l =
      if i < 0 then l else
      expl (i - 1) (s.[i] :: l) in
    expl (String.length s - 1) []

  let analyse lst =
    let rec analyser acc d k lst =
      let depth_check xs a = if d = k then (a, xs) else analyser (a::acc) d k xs in
      let acc_check () = if length acc >= 1 then hd acc else raise Parse_Error in
      match lst with
      | 'A'::'N'::'D'::xs -> let (b,rs) = (analyser [] d d xs) in depth_check rs (acc_check () && b)
      | 'O'::'R'::xs      -> let (b,rs) = (analyser [] d d xs) in depth_check rs (acc_check () || b)
      | 'N'::'O'::'T'::xs -> let (a,rs) = (analyser [] d d xs) in depth_check rs (not a)
      | '0'::xs           -> depth_check xs false
      | '1'::xs           -> depth_check xs true
      | '('::xs           -> analyser acc (d + 1) k xs
      | ')'::xs           -> analyser acc (d - 1) k xs
      | ' '::xs           -> analyser acc d k xs
      | []                -> (hd acc, [])
      | _::xs             -> raise Unrecognized_Symbol
    in
    let (a,_) = analyser [] 0 0 lst in a

  let solve str = analyse @@ explode str

  let parse file =
    let ic = open_in file in
    try
      let line = input_line ic in
      let result = solve line in
      flush stdout;
      close_in ic;
      result
    with
      | e ->
        close_in_noerr ic;
        raise e
end
