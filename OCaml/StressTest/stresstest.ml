open Printf
open Sys

effect E : bool

module Loop : sig
  val solve : int -> unit
end =
struct
  let rec loop () =
    if perform E then loop ()
    else ()

  let solve n =
    let handler =
      match loop () with
      | effect E k -> (fun s -> let next = s + 1 in
          if next < n then continue k true next
          else continue k false next)
      | x -> (fun s -> x)
    in
    handler 0
end
