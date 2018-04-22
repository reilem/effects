(*
=== GENERATED FROM fibonacci0.eff ===
commit SHA:
=== BEGIN SOURCE ===

external ( = ) : int -> int -> bool = "="
external ( - ) : int -> int -> int = "-"
external ( + ) : int -> int -> int = "+"
type 'a option = None | Some of 'a

effect Put : (int * int) -> unit
effect Get : int -> int option

let rec find n = function
  | []       -> None
  | (v,x)::r -> if n = v then Some x else find n r

let rec fibo_mem = function
  | 0 -> 0 | 1 -> 1 | 2 -> 1
  | n -> match #Get n with
    | Some x -> x
    | None -> let value = fibo_mem (n - 1) + fibo_mem (n - 2) in #Put (n,value); value

let store = handler
  | #Get n k    -> (fun s -> k (find n s) s)
  | #Put tup k  -> (fun s -> k () (tup::s))
  | val x       -> (fun s -> x)

let solve n = (with store handle fibo_mem n) []

=== END SOURCE ===
*)

type ('eff_arg,'eff_res) effect = ..
type 'a computation =
  | Value: 'a -> 'a computation
  | Call: ('eff_arg,'eff_res) effect* 'eff_arg* ('eff_res -> 'a computation)
  -> 'a computation
type ('eff_arg,'eff_res,'b) effect_clauses =
  ('eff_arg,'eff_res) effect -> 'eff_arg -> ('eff_res -> 'b) -> 'b
type ('a,'b) handler_clauses =
  {
  value_clause: 'a -> 'b ;
  effect_clauses: 'eff_arg 'eff_res . ('eff_arg,'eff_res,'b) effect_clauses }

module Fibonacci : sig
  val solve : int -> int computation
end =
struct
  let rec (>>) (c : 'a computation) (f : 'a -> 'b computation) =
    match c with
    | Value x -> f x
    | Call (eff,arg,k) -> Call (eff, arg, ((fun y  -> (k y) >> f)))
  let rec handler (h : ('a,'b) handler_clauses) =
    (let rec handler =
       function
       | Value x -> h.value_clause x
       | Call (eff,arg,k) ->
           let clause = h.effect_clauses eff  in
           clause arg (fun y  -> handler (k y))
        in
     handler : 'a computation -> 'b)

  let value (x : 'a) = (Value x : 'a computation)
  let call (eff : ('a,'b) effect) (arg : 'a) (cont : 'b -> 'c computation) =
    (Call (eff, arg, cont) : 'c computation)
  let rec lift (f : 'a -> 'b) =
    (function
     | Value x -> Value (f x)
     | Call (eff,arg,k) -> Call (eff, arg, ((fun y  -> lift f (k y)))) :
    'a computation -> 'b computation)
  let effect eff arg = call eff arg value
  let run =
    function | Value x -> x | Call (eff,_,_) -> failwith "Uncaught effect"
  let ( ** ) =
    let rec pow a =
      let open Pervasives in
        function
        | 0 -> 1
        | 1 -> a
        | n ->
            let b = pow a (n / 2)  in
            (b * b) * (if (n mod 2) = 0 then 1 else a)
       in
    pow
  let string_length _ = assert false
  let to_string _ = assert false
  let lift_unary f x = value (f x)
  let lift_binary f x = value (fun y  -> value (f x y))
  ;;"End of pervasives"
  let _var_1 x = lift_binary (=) x
  let _var_2 x = lift_binary (-) x
  let _var_3 x = lift_binary (+) x
  type 't1 option =
    | None
    | Some of 't1
  type (_,_) effect +=
    | Effect_Put: ((int* int),unit) effect
  type (_,_) effect +=
    | Effect_Get: (int,int option) effect
  let rec _find_4 _n_5 =
    value
      (fun _gen_function_6  ->
         match _gen_function_6 with
         | [] -> value None
         | (_v_7,_x_8)::_r_9 ->
             ((_var_1 _n_5) >> (fun _gen_bind_11  -> _gen_bind_11 _v_7)) >>
               ((fun _gen_bind_10  ->
                   match _gen_bind_10 with
                   | true  -> value (Some _x_8)
                   | false  ->
                       (_find_4 _n_5) >>
                         ((fun _gen_bind_12  -> _gen_bind_12 _r_9)))))
  let rec _fibo_mem_13 _gen_let_rec_function_14 =
    match _gen_let_rec_function_14 with
    | 0 -> value 0
    | 1 -> value 1
    | 2 -> value 1
    | _n_15 ->
        ((effect Effect_Get) _n_15) >>
          ((fun _gen_bind_25  ->
              match _gen_bind_25 with
              | Some _x_16 -> value _x_16
              | None  ->
                  (((((_var_2 _n_15) >> (fun _gen_bind_21  -> _gen_bind_21 1))
                       >> (fun _gen_bind_20  -> _fibo_mem_13 _gen_bind_20))
                      >> (fun _gen_bind_19  -> _var_3 _gen_bind_19))
                     >>
                     (fun _gen_bind_18  ->
                        (((_var_2 _n_15) >>
                            (fun _gen_bind_24  -> _gen_bind_24 2))
                           >> (fun _gen_bind_23  -> _fibo_mem_13 _gen_bind_23))
                          >> (fun _gen_bind_22  -> _gen_bind_18 _gen_bind_22)))
                    >>
                    ((fun _value_17  ->
                        ((effect Effect_Put) (_n_15, _value_17)) >>
                          (fun _  -> value _value_17)))))
  let _store_26 c =
    handler
      {
        value_clause = (fun _x_37  -> value (fun _s_38  -> value _x_37));
        effect_clauses = fun (type a) -> fun (type b) ->
          fun (x : (a,b) effect)  ->
            (match x with
             | Effect_Get  ->
                 (fun (_n_31 : int)  ->
                    fun (_k_32 : int option -> _ computation)  ->
                      value
                        (fun _s_33  ->
                           (((_find_4 _n_31) >>
                               (fun _gen_bind_36  -> _gen_bind_36 _s_33))
                              >> (fun _gen_bind_35  -> _k_32 _gen_bind_35))
                             >> (fun _gen_bind_34  -> _gen_bind_34 _s_33)))
             | Effect_Put  ->
                 (fun (_tup_27 : (int* int))  ->
                    fun (_k_28 : unit -> _ computation)  ->
                      value
                        (fun _s_29  ->
                           (_k_28 ()) >>
                             (fun _gen_bind_30  ->
                                _gen_bind_30 (_tup_27 :: _s_29))))
             | eff' -> (fun arg  -> fun k  -> Call (eff', arg, k)) : a ->
                                                                      (b ->
                                                                      _
                                                                      computation)
                                                                      ->
                                                                      _
                                                                      computation)
      } c
  let _solve_39 _n_40 =
    (_store_26 (_fibo_mem_13 _n_40)) >> (fun _gen_bind_41  -> _gen_bind_41 [])

  let solve n = _solve_39 n
end
