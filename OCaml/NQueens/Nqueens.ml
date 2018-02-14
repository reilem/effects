open List
open Printf
open Sys

type result = Failure | Success of (int * int) list

module Printer : sig
  val print : (int * int) list -> unit
end =
struct
  let print lst =
    let rec aux = function
      | []          -> ()
      | (a,b) :: [] -> printf "(%d,%d)]\n" a b
      | (a,b) :: l  -> printf "(%d,%d)" a b; aux l
    in printf "["; aux lst; printf ""
end

module NQueens : sig
  val solve : int -> result
end =
struct
  effect Select : int list -> int

  let row n =
    let rec gen acc x = match x with
      | 0 -> acc
      | _ -> gen (x::acc) (x - 1)
    in gen [] n

  let noAttack (x1,y1) (x2,y2) =
    x1 <> x2 && y1 <> y2 && abs (x1 - x2) <> abs (y1 - y2)

  let available x n queens =
    filter (fun y -> for_all (noAttack (x,y)) queens) @@ row n

  let solve n = try
    let rec solver x qns =
      if x == (n + 1) then Success qns
      else let next = perform (Select (available x n qns))
      in solver(x + 1) ((x,next) :: qns)
    in solver 1 []
    with
    | effect (Select lst) k ->
      let rec attempt l =
        match l with
        | []    -> Failure
        | x::xs ->
          match continue (Obj.clone_continuation k) x with
            | Success y -> Printer.print(rev y); attempt xs
            | Failure   -> attempt xs
      in attempt lst
end
