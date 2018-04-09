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

  let step t =
    let rec walk = function
      | Leaf v       -> perform (Wait v)
      | Node (t1,t2) -> walk t1; walk t2
    in
    match walk t with
    | effect (Wait v) k -> Waiting (v,k)
    | _                 -> Done

  let solve t1 t2 =
    let stepper t = (fun () -> step t) in
    let resume k = (fun () -> continue k ()) in
    let rec fringe l r =
      match l (), r () with
      | Done, Done                       -> true
      | Waiting (v1,k1), Waiting (v2,k2) -> if v1 = v2 then fringe (resume k1) (resume k2) else false
      | _, _                             -> false
    in fringe (stepper t1) (stepper t2)
end
