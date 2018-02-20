open List

module Pipes : sig
  val solve : int list -> int list
end =
struct
  effect Check : int list -> unit

  let negate = function | 0 -> -1 | n -> n

  let rec find_subarray = function
  | []  -> []
  | ary -> perform (Check ary); find_subarray @@ tl ary

  let solve (lst : int list) =
    try find_subarray lst with
    | effect (Check sublst) k ->
      let rec sub_search sum acc best = function
        | [] -> rev best
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
