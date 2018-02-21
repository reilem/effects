<<<<<<< HEAD
open Printf
open List
open Nqueens
open Generator


module Evaluator : sig
val evaluateF : string -> int -> unit
end =
struct
  let timer f x =
    let t0 = Sys.time()                                         
    in let _ = f x                                            
    in let diff = (Sys.time() -. t0) *. 1000.0                         
    in diff
    
  let evaluate solver generator =
    let oc = open_out "test.txt" in
      for n = 1 to upperlimit do
        fprintf oc "%f\n" (timer solver (generator n));
      done;
    close_out oc
    
  let evaluateF fun upperlimit =
    match fun with
    | "NQ" -> evaluate NQueens.solve Generator.NQ
    | "BS" -> evaluate NQueens.solve Generator.BS
    | "RR" -> evaluate NQueens.solve Generator.BS
    | "PRS" -> evaluate NQueens.solve Generator.PRS
    | "PIPE" -> evaluate NQueens.solve Generator.PIPE
    | "TREE" -> evaluate NQueens.solve Generator.NQ
    | "STRESS" -> evaluate NQueens.solve Generator.NQ
    

end






=======
open Random
open Printf
open List

let timer f x =
    let t0 = Sys.time()                                         
    in let () = f x                                            
    in let diff = (Sys.time() -. t0) *. 1000.0                         
    in diff
        
        
let run f n =

  match f n with
  | None -> print_endline "No solutions were found"
  | Some l -> print_endline "A solution was found"

  
let rec bitstring_generator n =
    match n with
    | 0 -> []
    | n -> Random.int 2 :: (bitstring_generator (n-1))

      
let main () =

    List.iter print_int (bitstring_generator 9)
    
(*
     let oc = open_out "test.txt" in
     fprintf oc "%f\n" (timer queens_generator "INSERT FUNCTION HERE" 8);
     close_out oc
*) 
     
     
     (*
let queens_generator upperlimit =
    for n = 1 to upperlimit do
        run "FUNCTION" n
    done
    *)
    

    
     
let () = main ()
>>>>>>> 47a8df5710074a8261c12b6d21e3a9047129b240

