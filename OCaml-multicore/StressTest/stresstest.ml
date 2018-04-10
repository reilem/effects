module Loop : sig
  val solve : int -> unit
end =
struct
  effect Check : bool

  let rec loop () = if perform Check then loop () else ()

  let solve n =
    let handler =
      match loop () with
      | effect Check k -> (fun s -> if s < n then continue k true (s + 1) else continue k false s)
      | x              -> (fun s -> x)
    in handler 0
end
