type tree =
  | Leaf of int
  | Node of tree * tree

module Fringe : sig
  val solve: tree -> tree -> bool
end =
struct
  effect Wait : int -> unit

  type 'a state =
    | Done
    | Waiting of int * (unit, 'a state) continuation

  let rec step = function
    | Leaf v       -> perform (Wait v)
    | Node (t1,t2) -> step t1; step t2

  let walk t =
    match step t with
    | effect (Wait v) k -> Waiting (v,k)
    | _                 -> Done

  let solve t1 t2 =
    let rec walker l r =
      match l (), r () with
      | Done, Done                       -> true
      | Waiting (v1,k1), Waiting (v2,k2) ->
        if v1 == v2 then walker (fun () -> continue k1 ()) (fun () -> continue k2 ())
        else false
      | _, _ -> false
    in walker (fun () -> walk t1) (fun () -> walk t2)
end
