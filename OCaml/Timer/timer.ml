open Printf
open List
open Generator

open Nqueens
open Parser
open Pipes
open Fibonacci
open Stresstest

module Evaluator : sig
  val evaluateF : string -> int -> unit
end =
struct
  let timer f x =
    let t0 = Sys.time()
    in let _ = f x
    in let diff = (Sys.time() -. t0) *. 1000.0
    in diff

  let evaluateF func upperlimit =
    let evaluate solver generator =
      let oc = open_out "test.txt" in
        for n = 1 to upperlimit do
          fprintf oc "%f\n" (timer solver (generator n));
        done;
      close_out oc
    in
    match func with
    | "NQ"     -> evaluate NQueens.solve Generator.nqueens
    | "PRS"    -> evaluate Parser.solve Generator.parse
    | "PIPE"   -> evaluate Pipes.solve Generator.pipes
    | "FIB"    -> evaluate Fibonacci.solve Generator.fibo
    | "STRESS" -> evaluate Loop.solve Generator.stress
    | _    -> ()
    (* | "RR" -> evaluate NQueens.solve Generator.rr
    | "TREE" -> evaluate NQueens.solve Generator.tree *)
end
