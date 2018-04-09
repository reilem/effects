module Pipes : sig
  val solve : int list -> int list
end =
struct
  let negate = function | 0 -> -1 | n -> n

  let subarray_search sublst =
    let rec sub_search sum acc best = function
      | []         -> best
      | next::rest ->
        let newsum = sum + (negate next) in
        let newacc  = acc @ [next] in
        if newsum == 0 then
          sub_search newsum newacc newacc rest
        else
          sub_search newsum newacc best rest
    in sub_search 0 [] [] sublst

  let solve lst =
    let rec find_subarray best = function
    | []    -> best
    | x::xs ->
      let current_best = subarray_search (x::xs) in
      if List.length current_best > List.length best then
        find_subarray current_best xs
      else
        find_subarray best xs
    in find_subarray [] lst
end
