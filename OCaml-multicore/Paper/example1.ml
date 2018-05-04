effect Push : int -> unit
effect Add : unit
effect Print : unit

let program1 () =
  perform (Push 2);
  perform (Push 8);
  perform Add;
  perform Print;
  perform (Push 20);
  perform Add;
  perform Print

let program2 () =
  perform (Push 10);
  perform (Push 15);
  perform (Push 20);
  perform Print;
  perform Add;
  perform Print;
  perform Add;
  perform Print

let handle f =
  let handler =
    match f () with
    | effect Add k -> (function
      | x::y::ys -> continue k () ((x + y)::ys)
      | s        -> continue k () s
    )
    | effect Print k -> (function
      | x::xs -> print_int x; print_newline (); continue k () (x::xs)
      | []    -> continue k () []
    )
    | effect (Push n) k -> (fun s -> continue k () (n::s))
    | x                 -> (fun s -> [x])
  in handler []

let _ = handle program2
