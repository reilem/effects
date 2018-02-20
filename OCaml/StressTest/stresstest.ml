open Printf
open Sys

effect E : unit -> bool

module Loop : sig
  val solve : int -> unit
end =
struct
  let rec loop () =
    if perform (E ()) then
      loop ()
    else
      ()

  let solve n =
    let count = ref 0 in
    try loop () with
    | effect (E a) k ->
      count := !count + 1;
      if !count < n then
        continue k true
      else
        continue k false
end
