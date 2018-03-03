module NQueens : sig
  val solve : int -> (int * int) list list
end =
struct
  effect Fail   : int
  effect Select : bool

  let rec filter f = function
    | []    -> []
    | x::xs -> if f x then x::(filter f xs) else filter f xs

  let rec for_all f = function
    | []    -> true
    | x::xs -> if f x then for_all f xs else false

  (* NQUEENS ASSIST *)
  let rec row = function | 0 -> [] | n -> n::row (n - 1);;

  let noAttack (i,j) (k,l) = i <> k && j <> l && abs (i - k) <> abs (j - l)

  let available x n queens =
    filter (fun y -> for_all (noAttack (x,y)) queens) @@ row n

  let rec choose = function
    | []    -> perform Fail
    | x::xs -> if perform Select then x else choose xs

  (* NQUEENS *)
  let rec queens n =
    let rec put_queen x qns =
      if x > n then qns else
      let next = choose (available x n qns) in
      put_queen (x + 1) ((x,next)::qns)
    in put_queen 1 []

  (* SOLVER / HANDLER *)
  let solve n =
    match queens n with
    | effect Select k -> continue (Obj.clone_continuation k) true @ continue (Obj.clone_continuation k) false
    | effect Fail   _ -> []
    | x               -> [x]
end
