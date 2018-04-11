type tree =
  | Leaf of int
  | Node of tree * tree

module Fringe : sig
  val solve: tree * tree -> bool
end =
struct
  type 'a state =
    | Done
    | Wait of int * tree list

  let rec next = function
    | (Leaf v)::xs      -> Wait (v,xs)
    | (Node (l, r))::xs -> next (l::r::xs)
    | _                 -> Done

  let solve (t1,t2) =
    let rec fringe l r =
      match (next l, next r) with
      | Wait (x,t1), Wait (y,t2) -> if x == y then fringe t1 t2 else false
      | Done, Done               -> true
      | _                        -> false
    in fringe [t1] [t2]
end
