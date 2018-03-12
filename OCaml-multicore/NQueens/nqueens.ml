module NQueens : sig
  val solve : int -> (int * int) list list
end =
struct
  effect Fail   : int
  effect Select : bool

  let no_attack (x, y) (x', y') =
    x <> x' && y <> y' && abs (x - x') <> abs (y - y')

  let rec not_attacked x' = function
    | [] -> true
    | x :: xs -> if no_attack x' x then not_attacked x' xs else false

  let available (number_of_queens, x, qs) =
    let rec loop (possible, y) =
      if y < 1 then
        possible
      else if not_attacked (x, y) qs then
        loop ((y :: possible), (y - 1))
      else
        loop (possible, (y - 1))
    in
    loop ([], number_of_queens)

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
