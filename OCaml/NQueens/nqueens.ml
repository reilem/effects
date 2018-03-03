open List
open Printf
open Sys

module NQueens : sig
  val solve : int -> (int * int) list list
end =
struct
  effect Fail   : unit
  effect Select : bool

  let exit () = assert false

  let rec row = function | 0 -> [] | n -> n::row (n - 1);;

  let noAttack (i,j) (k,l) = i <> k && j <> l && abs (i - k) <> abs (j - l)

  let available x n queens =
    filter (fun y -> for_all (noAttack (x,y)) queens) @@ row n

  let rec choose = function
    | []    -> exit @@ perform Fail
    | x::xs -> if perform Select then x else choose xs

  let rec queens n =
    let rec put_queen x qns =
      if x > n then qns else
      let next = choose (available x n qns) in
      put_queen (x + 1) ((x,next)::qns)
    in put_queen 1 []

  let solve n =
    match queens n with
    | effect Select k -> continue (Obj.clone_continuation k) true @ continue (Obj.clone_continuation k) false
    | effect Fail   _ -> []
    | x               -> [x]
end
