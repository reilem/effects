open Printf
open List
open Sys

type result = Failure | Success of (int * int) list

effect Select : int list -> int

(* Prints the result in readable from *)
let rec print_tuple_list lst =
  let rec aux = function
    | []          -> ()
    | (a,b) :: [] -> printf "(%d,%d)]\n" a b
    | (a,b) :: l  -> printf "(%d,%d)" a b; aux l
  in printf "["; aux lst

(* Fetches n from input args or uses 8 as default *)
let n =
  if Array.length argv > 1 then int_of_string argv.(1) else 8

(* Uses n to generate a default row, ex n = 4, row = [1;2;3;4] *)
let row =
  let rec gen acc x = match x with
    | 0 -> acc
    | _ -> gen (x::acc) (x - 1)
  in gen [] n

(* noAttack : (a,a) -> (a,a) -> bool:
    checks if two coordinates are valid and wont attack each other *)
let noAttack (x1,y1) (x2,y2) =
  x1 <> x2 && y1 <> y2 && abs (x1 - x2) <> abs (y1 - y2)

(* available :  a -> [(a, a)] -> [a]*)
let available x queens =
  filter (fun y -> for_all (noAttack (x,y)) queens) row

(* Effect handler *)
let handle program =
  try program n with
  | effect (Select lst) k ->
    let rec attempt l =
      match l with
      | []    -> Failure
      | x::xs ->
        match continue (Obj.clone_continuation k) x with
          | Success y -> print_tuple_list (rev y); attempt xs
          | Failure   -> attempt xs
    in attempt lst

(* Queens solver *)
let queens n =
  let rec solve x qns =
    if x == (n + 1) then Success qns
    else let next = perform (Select (available x qns))
    in solve (x + 1) ((x,next) :: qns)
  in solve 1 []

(* Main *)
let _ = handle queens
