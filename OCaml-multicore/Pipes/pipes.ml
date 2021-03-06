module Pipes : sig
  val solve : int list -> int list
end =
struct
  effect Check : int list -> unit

  let negate = function | 0 -> -1 | n -> n

  let rec find_subarray = function
  | []    -> []
  | x::xs -> perform (Check (x::xs)); find_subarray xs

  let solve (lst : int list) =
    try find_subarray lst with
    | effect (Check sublst) k ->
      let rec sub_search sum acc best = function
        | []         -> best
        | next::rest ->
          let newsum = sum + (negate next) in
          let newacc  = acc @ [next] in
          if newsum == 0 then
            sub_search newsum newacc newacc rest
          else
            sub_search newsum newacc best rest
      in
      let current_best = sub_search 0 [] [] sublst in
      let next_best = continue k () in
      if List.length current_best > List.length next_best then
        current_best
      else
        next_best
end
