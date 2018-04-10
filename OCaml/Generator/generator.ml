open Random
open Pervasives
open Fringe

module Generator : sig
  val nqueens : int -> int
  val pipes   : int -> int list
  val parse   : int -> string
  val stress  : int -> int
  val fibo    : int -> int
  val fringe  : int -> (tree * tree)
  (* val rr      : int -> int
  val tree    : int -> int list *)
end =
struct
  let id x = x

  let nqueens = id
  let fibo = id
  let stress = id

  let rec pipes = function
    | 0 -> []
    | n -> Random.int 2 :: (pipes (n-1))

  let rec parse n =
    let rand_exp f g n =
      if n < 40 then "AND " ^ f () ^ " " ^ g ()
      else if n < 80 then "OR " ^ f () ^ " " ^ g ()
      else "NOT " ^ f ()
    in
    let e = Random.int 99 in
    let b1 = Random.int 2 in
    let b2 = Random.int 2 in
    let gen_expr f g = "(" ^ rand_exp f g e ^ ")" in
    match n with
    | 0 -> gen_expr (fun () -> string_of_int b1) (fun () -> string_of_int b2)
    | n -> gen_expr (fun () -> parse @@ n - 1) (fun () -> parse @@ n - 1)

  (* Returns a tuple containing two identical balanced trees *)
  let fringe depth =
    let rec gen_tree = function
    | 0 -> Leaf (Random.int 100)
    | x -> Node (gen_tree @@ x - 1, gen_tree @@ x - 1)
    in
    let t = gen_tree depth in (t, t)
end
