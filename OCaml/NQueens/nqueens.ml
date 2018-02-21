open List
open Printf
open Sys

type result = Failure | Success of (int * int) list

module NQueens : sig
  val solve : int -> result
end =
struct
  effect Select : int list -> int

  let print lst =
    let rec aux = function
      | []          -> ()
      | (a,b) :: [] -> printf "(%d,%d)" a b
      | (a,b) :: l  -> printf "(%d,%d)|" a b; aux l
    in printf "["; aux lst; printf "]\n"

  let rec row = function | 0 -> [] | n -> n::row (n - 1)

  let noAttack (i,j) (k,l) = i <> k && j <> l && abs (i - k) <> abs (j - l)

  let available x n queens =
    filter (fun y -> for_all (noAttack (x,y)) queens) @@ row n

  let solve n = try
    let rec solver x qns =
      if x == (n + 1) then Success qns
      else let next = perform (Select (available x n qns)) in
      solver(x + 1) ((x,next) :: qns)
    in solver 1 []
    with
    | effect (Select lst) k ->
      let rec attempt l =
        match l with
        | []    -> Failure
        | x::xs ->
          match continue (Obj.clone_continuation k) x with
            | Success y -> print (rev y); attempt xs
            | Failure   -> attempt xs
      in attempt lst
end
