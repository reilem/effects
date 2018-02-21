open Printf
open List
open Sys

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

  let output_file = "test.txt"

  let timer f x =
    let t0 = Sys.time()
    in let _ = f x
    in let diff = (Sys.time() -. t0) *. 1000.0
    in diff

  let evaluateF func upperlimit =
    let evaluate solver generator =
      printf "Running tests...\n";
      let oc = open_out output_file in
        for n = 1 to upperlimit do
          fprintf oc "%f\n" (timer solver (generator n));
        done;
      printf "Results output to: %s\n" output_file;
      close_out oc;
      printf "Tests finished!\n"
    in
    match func with
    | "NQ"     -> evaluate NQueens.solve Generator.nqueens
    | "PRS"    -> evaluate Parser.solve Generator.parse
    | "PIPES"   -> evaluate Pipes.solve Generator.pipes
    | "FIB"    -> evaluate Fibonacci.solve Generator.fibo
    | "STRESS" -> evaluate Loop.solve Generator.stress
    | _        -> printf "Invalid function name given\n"
    (* | "RR" -> evaluate NQueens.solve Generator.rr
    | "TREE" -> evaluate NQueens.solve Generator.tree *)
end

let _ = Evaluator.evaluateF argv.(1) (int_of_string argv.(2))
