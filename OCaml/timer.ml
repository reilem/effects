let timer f x =
    let t0 = Sys.time()                                         
    in let () = f x                                            
    in let diff = (Sys.time() -. t0) *. 1000.0                         
    in diff
        
        
let run f n =

  match f n with
  | None -> print_endline "No solutions were found"
  | Some l -> print_endline "A solution was found"

      
let main () =
     let oc = open_out "test.txt" in
     fprintf oc "%f\n" (timer run "INSERT FUNCTION HERE" 8);
     close_out oc

     
let () = main ()