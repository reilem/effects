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







