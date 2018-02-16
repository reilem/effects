open List
open Printf

module Parser : sig
  (* Takes a file (string) and parses its contents *)
  val parse : string -> bool
  (* Takes a string and parses it *)
  val solve : string -> bool
end =
struct
  exception Lexical_Error
  exception Syntax_Error

  type expression = TRUE | FALSE
    | AND of expression * expression
    | OR of expression * expression
    | NOT of expression

  let rec print_expr = function
    | TRUE            -> printf "TRUE"
    | FALSE           -> printf "FALSE"
    | NOT exp         ->
      printf "NOT("; print_expr exp; printf ")"
    | AND (exp1,exp2) ->
      printf "AND("; print_expr exp1; printf ","; print_expr exp2; printf ")"
    | OR (exp1,exp2) ->
      printf "OR("; print_expr exp1; printf ","; print_expr exp2; printf ")"

  type token =
    | TRUE_T
    | FALSE_T
    | AND_T
    | OR_T
    | NOT_T
    | LEFT_T
    | RIGHT_T

  let print_token = function
    | TRUE_T  -> printf "TRUE;"
    | FALSE_T -> printf "FALSE;"
    | AND_T   -> printf "AND;"
    | OR_T    -> printf "OR;"
    | NOT_T   -> printf "NOT;"
    | LEFT_T  -> printf "LEFT_BRACK;"
    | RIGHT_T -> printf "RIGHT_BRACK;"

  let rec print_token_list = function
    | []      -> printf "\n"
    | a::rest -> print_token a; print_token_list rest

  let rec eval (expr : expression) : bool =
    match expr with
    | TRUE            -> true
    | FALSE           -> false
    | AND (exp1,exp2) -> eval exp1 && eval exp2
    | OR  (exp1,exp2) -> eval exp1 || eval exp2
    | NOT exp         -> not @@ eval exp

  let explode s =
    let rec expl i l =
      if i < 0 then l else
      expl (i - 1) (s.[i] :: l) in
    expl (String.length s - 1) []

  let rec analyse (acc: token list) (clist : char list) : token list =
    match clist with
    | []                  -> rev acc
    | 'A'::'N'::'D'::rest -> analyse (AND_T::acc) rest
    | 'O'::'R'::rest      -> analyse (OR_T::acc) rest
    | 'N'::'O'::'T'::rest -> analyse (NOT_T::acc) rest
    | '('::rest           -> analyse (LEFT_T::acc) rest
    | ')'::rest           -> analyse (RIGHT_T::acc) rest
    | '0'::rest           -> analyse (FALSE_T::acc) rest
    | '1'::rest           -> analyse (TRUE_T::acc) rest
    | ' '::rest           -> analyse acc rest
    | _::rest             -> raise Syntax_Error

  let rec find_next_exp_list (acc : token list) (lst : token list) (depth : int) : (token list * token list) =
    match lst with
    | []            -> (rev acc,[])
    | LEFT_T::rest  ->
      if depth == 0 then
        find_next_exp_list acc rest 1
      else
        find_next_exp_list (LEFT_T::acc) rest (depth + 1)
    | RIGHT_T::rest ->
      if depth == 1 then
        (rev acc,rest)
      else
        find_next_exp_list (RIGHT_T::acc) rest (depth - 1)
    | any::rest     ->
      if depth == 0 then
        ([any],rest)
      else
        find_next_exp_list (any::acc) rest depth

  let rec convert_token_list (lst : token list) : expression =
    match lst with
    | AND_T::rest   ->
      let (exp_left,remainder) = find_next_exp_list [] rest 0 in
      let (exp_right,_) = find_next_exp_list [] remainder 0 in
      AND (convert_token_list exp_left,convert_token_list exp_right)
    | OR_T::rest   ->
      let (exp_left,remainder) = find_next_exp_list [] rest 0 in
      let (exp_right,_) = find_next_exp_list [] remainder 0 in
      OR (convert_token_list exp_left,convert_token_list exp_right)
    | NOT_T::rest   ->
      let (exp,_) = find_next_exp_list [] rest 0 in
      NOT (convert_token_list exp)
    | TRUE_T::rest  -> TRUE
    | FALSE_T::rest -> FALSE
    | _             -> raise Lexical_Error

  let solve str =
    let clist = explode str in
    eval @@ convert_token_list @@ analyse [] clist

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
