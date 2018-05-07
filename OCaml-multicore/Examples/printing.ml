effect Print : string -> unit

let program1 () =
  perform (Print "Hello ");
  perform (Print "World");
  perform (Print "!\n")

let handle f =
  match f () with
  | effect (Print a) k -> print_string a; continue k ()
  | x -> ()

let handle_rev f =
  match f () with
  | effect (Print a) k -> continue k (); print_string a
  | x -> ()

let _ =
  handle_rev program1;
  (* handle program1; *)
  print_newline ()
