open Printf
open List
open Array
open Sys

type result = Failure | Success of (int * int) list

effect Select : int list -> int

let rec print_tuple_list lst =
  printf "[";
  let rec aux = function
    | [] -> ()
    | [(a,b)] -> printf "(%d,%d)" a b
    | (a,b) :: l ->
      printf "(%d,%d)" a b;
      aux l
  in
    aux lst;
    printf "]\n"

let board = ref []

let makeBoard n =
  let rec generate a acc =
    if a == n then board := acc
    else generate (a + 1) (acc @ [a])
  in generate 1 []

let n =
  let return n =
    makeBoard n;
    n
  in
  if length argv > 1 then
    return (int_of_string argv.(1))
  else
    return 8

(* noAttack : (a,a) -> (a,a) -> bool:
    checks if two coordinates are valid and wont attack each other *)
let noAttack (x1,y1) (x2,y2) =
  x1 <> x2 && y1 <> y2 && abs (x1 - x2) <> abs (y1 - y2)

(* available :  a -> [(a, a)] -> [a]*)
let available x queens =
  filter (
    (fun y -> for_all (noAttack (x,y)) queens)
  ) [1; 2; 3; 4; 5; 6; 7; 8]

let handle program =
  try program n with
  | effect (Select lst) k ->
    let rec attempt l =
      match l with
      | [] -> Failure
      | x::xs -> (
        match continue (Obj.clone_continuation k) x with
          | Success y -> print_tuple_list (rev y); attempt xs
          | Failure -> attempt xs
      )
    in
      attempt lst

let queens n =
  let rec solve x qns =
    if x == (n + 1) then
      Success qns
    else
      let next = perform (Select (available x qns)) in
        solve (x + 1) ((x,next) :: qns)
  in
  solve 1 []

let _ = handle queens
