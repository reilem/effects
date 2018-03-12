module NQueens : sig
  val solve : int -> (int * int) list list
end =
struct
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

  let solve n =
    let rec place (x, qs) =
      if x > n then [qs] else
        let rec choose = function
          | [] -> []
          | y :: ys ->
              place ((x + 1), ((x, y) :: qs)) @ choose ys
        in
        choose (available (n, x, qs))
    in
    place (1, [])
end
