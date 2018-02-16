open List
open Printf

effect Check : int list -> int list

let negate = function | 0 -> -1 | n -> n

module Pipes : sig
  val solve : int list -> int list
end =
struct
  let rec find_subarray lst =
    let rec find_sub best = function
      | [] -> best
      | ary ->
        let current_best = perform (Check ary) in
        let next_best = find_sub best (tl ary) in
        if (length current_best) > (length next_best) then
          rev current_best
        else
          next_best
    in find_sub [] lst

  let solve (lst : int list) =
    try find_subarray lst with
    | effect (Check sublst) k ->
      let rec sub_search sum acc best = function
        | [] -> best
        | next::rest ->
          let newsum = sum + (negate next) in
          let newacc  = next::acc in
          if newsum == 0 then
            sub_search newsum newacc newacc rest
          else
            sub_search newsum newacc best rest
      in
      let current_best = sub_search 0 [] [] sublst in
      continue k current_best
end
