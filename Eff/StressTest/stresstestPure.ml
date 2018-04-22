(*
=== GENERATED FROM stresstest0.eff ===
commit SHA:
=== BEGIN SOURCE ===

external ( < ) : int -> int -> bool = "<"
external ( + ) : int -> int -> int = "+"

effect Check : unit -> bool

let rec loop () = if #Check () then loop () else ()

let looper n = handler
  | val x              -> (fun s -> ())
  | #Check _ k -> (fun s -> if s < n then k true (s + 1) else k false s)

let solve n = (with (looper n) handle loop ()) 0

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

module Loop : sig
  val solve : int -> unit computation
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
  let _var_1 x = lift_binary (<) x
  let _var_2 x = lift_binary (+) x
  type (_,_) effect +=
    | Effect_Check: (unit,bool) effect
  let rec _loop_3 () =
    ((effect Effect_Check) ()) >>
      (fun _gen_bind_4  ->
         match _gen_bind_4 with | true  -> _loop_3 () | false  -> value ())
  let _looper_5 _n_6 =
    value
      (fun c  ->
         handler
           {
             value_clause = (fun _x_15  -> value (fun _s_16  -> value ()));
             effect_clauses = fun (type a) -> fun (type b) ->
               fun (x : (a,b) effect)  ->
                 (match x with
                  | Effect_Check  ->
                      (fun (_ : unit)  ->
                         fun (_k_7 : bool -> _ computation)  ->
                           value
                             (fun _s_8  ->
                                ((_var_1 _s_8) >>
                                   (fun _gen_bind_10  -> _gen_bind_10 _n_6))
                                  >>
                                  (fun _gen_bind_9  ->
                                     match _gen_bind_9 with
                                     | true  ->
                                         (_k_7 true) >>
                                           ((fun _gen_bind_11  ->
                                               ((_var_2 _s_8) >>
                                                  (fun _gen_bind_13  ->
                                                     _gen_bind_13 1))
                                                 >>
                                                 (fun _gen_bind_12  ->
                                                    _gen_bind_11 _gen_bind_12)))
                                     | false  ->
                                         (_k_7 false) >>
                                           ((fun _gen_bind_14  ->
                                               _gen_bind_14 _s_8)))))
                  | eff' -> (fun arg  -> fun k  -> Call (eff', arg, k)) :
                 a -> (b -> _ computation) -> _ computation)
           } c)
  let _solve_17 _n_18 =
    ((_looper_5 _n_18) >> (fun _gen_bind_20  -> _gen_bind_20 (_loop_3 ()))) >>
      (fun _gen_bind_19  -> _gen_bind_19 0)

  let solve n = _solve_17 n
end
