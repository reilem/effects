open Printf
open List
open Array
open Sys

type 'a result = Failure | Success of 'a

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

let print_list lst =
  printf "[";
  let rec aux = function
    | [] -> ()
    | [x] -> printf "%d" x
    | e :: l ->
      printf "%d, " e;
      aux l
  in
    aux lst;
    printf "]\n"

let rec print_result = function
  | Failure -> printf "Failed\n"
  | Success y -> print_tuple_list (rev y)

let board = ref []

let makeBoard n =
  let rec generate a acc =
    if a == n then board := acc
    else generate (a + 1) (acc @ [a])
  in generate 1 []

(*  noAttack -> (a,a) -> (a,a) -> bool:
    checks if two coordinates are valid and wont attack each other *)
let noAttack (x1,y1) (x2,y2) =
  x1 <> x2 && y1 <> y2 && abs (x1 - x2) <> abs (y1 - y2)

(* selection  a -> [(a, a)] -> [a]*)
let available x queens =
  filter (
    (fun y -> for_all (noAttack (x,y)) queens)
  ) [1; 2; 3; 4; 5; 6; 7; 8]

let handle p =
  try p 1 [] with
  | effect (Select lst) k -> (
    let rec attempt l =
      match l with
      | [] -> Failure
      | x::xs -> (
        match continue (Obj.clone_continuation k) x with
          | Failure -> attempt xs
          | Success y -> Success y
      )
    in
      attempt lst
  )

let rec queens x n qns =
  if x == 9 then
    Success qns
  else
    let next = perform (Select (available x qns)) in
      queens (x+1) ((x,next) :: qns)

let n =
  let return n =
    makeBoard n;
    n
  in
  if length argv > 1 then
    let res = arv.(1) in
      return res
  else
    return 8

let _ =
  let result = handle n queens in
    print_result result
