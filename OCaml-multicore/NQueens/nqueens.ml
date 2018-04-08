module NQueens : sig
  val solve : int -> (int * int) list list
end =
struct
  effect Fail   : int
  effect Select : bool

  let rec noAttack (i,j) = function
    | [] -> true
    | (k,l)::xs -> i <> k && j <> l && abs (i - k) <> abs (j - l) && noAttack (i,j) xs

  let available n x qs =
    let rec check acc y =
      if y == 0 then acc
      else if noAttack (x, y) qs then check (y::acc) (y - 1)
      else check acc (y - 1)
    in
    check [] n

  let rec choose = function
    | []    -> perform Fail
    | x::xs -> if perform Select then x else choose xs

  (* NQUEENS *)
  let rec queens n =
    let rec put_queen x qns =
      if x == 0 then qns else
      let next = choose @@ available n x qns in
      put_queen (x - 1) ((x,next)::qns)
    in put_queen n []

  (* SOLVER / HANDLER *)
  let solve n =
    match queens n with
    | effect Select k -> continue (Obj.clone_continuation k) true @ continue (Obj.clone_continuation k) false
    | effect Fail   _ -> []
    | x               -> [x]
end
