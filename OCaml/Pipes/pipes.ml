
module Pipes : sig
  val solve : int list -> int list
end =
struct
  effect Check : int list -> unit

  let rec reverse lst =
    let rec rev acc = function
      | []    -> acc
      | x::xs -> rev (x::acc) xs
    in rev [] lst

  let rec length = function
    | []    -> 0
    | _::xs -> 1 + length xs

  let negate = function | 0 -> -1 | n -> n

  let rec find_subarray = function
  | []  -> []
  | x::xs -> perform (Check (x::xs)); find_subarray @@ xs

  let solve (lst : int list) =
    try find_subarray lst with
    | effect (Check sublst) k ->
      let rec sub_search sum acc best = function
        | [] -> reverse best
        | next::rest ->
          let newsum = sum + (negate next) in
          let newacc  = next::acc in
          if newsum == 0 then
            sub_search newsum newacc newacc rest
          else
            sub_search newsum newacc best rest
      in
      let current_best = sub_search 0 [] [] sublst in
      let next_best = continue k () in
      if length current_best > length next_best then
        current_best
      else
        next_best
end
