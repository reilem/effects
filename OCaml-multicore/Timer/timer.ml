open Printf
open Array
open Sys

open Generator
open Nqueens
open Parser
open Pipes
open Fibonacci
open Fringe
open Stresstest

module Evaluator : sig
  val evaluateF : string -> int -> int -> int -> int -> unit
end =
struct

  let timer f x m =
    let rec calc_average_time sum = function
    | 0 -> sum /. (float m)
    | n ->
      let t0 = Sys.time() in
      let _ = f x in
      let diff = (Sys.time() -. t0) *. 1000.0 in
      calc_average_time (sum +. diff) (n - 1)
    in
    calc_average_time 0.0 m

  let evaluateF func strt up avg stp =
    let output_file =  "_out/" ^ func ^ ".csv" in
    let ary = init (((up - strt) / stp) + 1) (fun i -> strt + (stp * i)) in
    let evaluate solver gen =
      let oc = open_out output_file in
        fprintf oc "n,x\n";
        iter (fun n -> fprintf oc "%d,%f\n" n (timer solver (gen n) avg)) ary;
      close_out oc;
      printf "Results printed to: %s\n" output_file;
    in
    match func with
    | "NQ"   -> evaluate NQueens.solve Generator.nqueens
    | "PRS"  -> evaluate Parser.solve Generator.parse
    | "PIP"  -> evaluate Pipes.solve Generator.pipes
    | "FIB"  -> evaluate Fibonacci.solve Generator.fibo
    | "STRS" -> evaluate Loop.solve Generator.stress
    | "FRNG" -> failwith "Generator not implemented"
    | _      -> failwith "Invalid function name given"
end

let getInt n = int_of_string argv.(n)

let _ =
  match length argv with
  | 3 ->
    Evaluator.evaluateF argv.(1) 1 (getInt 2) 1 1
  | 4 ->
    Evaluator.evaluateF argv.(1) 1 (getInt 2) (getInt 3) 1
  | 5 ->
    Evaluator.evaluateF argv.(1) (getInt 2) (getInt 3) (getInt 4) 1
  | 6 ->
    Evaluator.evaluateF argv.(1) (getInt 2) (getInt 3) (getInt 4) (getInt 5)
  | _ -> failwith "Invalid argument count"
