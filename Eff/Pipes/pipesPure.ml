(*
=== GENERATED FROM pipes0.eff ===
commit SHA:
=== BEGIN SOURCE ===

external ( + ) : int -> int -> int = "+"
external ( ~- ) : int -> int = "~-"
external ( = ) : int -> int -> bool = "="
external ( > ) : int -> int -> bool = ">"

effect Check : int list -> unit

let reverse lst = let rec rev acc = function | [] -> acc | x::xs -> rev (x::acc) xs in rev [] lst
let length lst = let rec len acc = function | [] -> acc | _::xs -> len (acc + 1) xs in len 0 lst
let negate = function | 0 -> -1 | n -> n

let rec find_subarray = function
  | []    -> []
  | x::xs -> #Check (x::xs); find_subarray xs

let array_checker = handler
  | #Check sublst k ->
    let rec sub_search sum acc best = function
      | [] -> reverse best
      | next::rest ->
        let newsum = sum + (negate next) in
        let newacc  = next::acc in
        if newsum = 0 then
          sub_search newsum newacc newacc rest
        else
          sub_search newsum newacc best rest
    in
    let current_best = sub_search 0 [] [] sublst in
    let next_best = k () in
    if length current_best > length next_best then
      current_best
    else
      next_best

let solve lst = with array_checker handle find_subarray lst

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

module Pipes : sig
  val solve : int list -> int list computation
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
  let _var_1 x = lift_binary (+) x
  let _var_2 x = lift_unary (~-) x
  let _var_3 x = lift_binary (=) x
  let _var_4 x = lift_binary (>) x
  type (_,_) effect +=
    | Effect_Check: (int list,unit) effect
  let _reverse_5 _lst_6 =
    let rec _rev_7 _acc_8 =
      value
        (fun _gen_function_9  ->
           match _gen_function_9 with
           | [] -> value _acc_8
           | _x_10::_xs_11 ->
               (_rev_7 (_x_10 :: _acc_8)) >>
                 ((fun _gen_bind_12  -> _gen_bind_12 _xs_11))) in
    (_rev_7 []) >> (fun _gen_bind_13  -> _gen_bind_13 _lst_6)
  let _length_14 _lst_15 =
    let rec _len_16 _acc_17 =
      value
        (fun _gen_function_18  ->
           match _gen_function_18 with
           | [] -> value _acc_17
           | _::_xs_19 ->
               (((_var_1 _acc_17) >> (fun _gen_bind_22  -> _gen_bind_22 1)) >>
                  (fun _gen_bind_21  -> _len_16 _gen_bind_21))
                 >> ((fun _gen_bind_20  -> _gen_bind_20 _xs_19))) in
    (_len_16 0) >> (fun _gen_bind_23  -> _gen_bind_23 _lst_15)
  let _negate_24 _gen_function_25 =
    match _gen_function_25 with | 0 -> _var_2 1 | _n_26 -> value _n_26
  let rec _find_subarray_27 _gen_let_rec_function_28 =
    match _gen_let_rec_function_28 with
    | [] -> value []
    | _x_29::_xs_30 ->
        ((effect Effect_Check) (_x_29 :: _xs_30)) >>
          ((fun _  -> _find_subarray_27 _xs_30))
  let _array_checker_31 c =
    handler
      {
        value_clause = (fun _gen_id_par_64  -> value _gen_id_par_64);
        effect_clauses = fun (type a) -> fun (type b) ->
          fun (x : (a,b) effect)  ->
            (match x with
             | Effect_Check  ->
                 (fun (_sublst_32 : int list)  ->
                    fun (_k_33 : unit -> _ computation)  ->
                      let rec _sub_search_34 _sum_35 =
                        value
                          (fun _acc_36  ->
                             value
                               (fun _best_37  ->
                                  value
                                    (fun _gen_function_38  ->
                                       match _gen_function_38 with
                                       | [] -> _reverse_5 _best_37
                                       | _next_39::_rest_40 ->
                                           ((_var_1 _sum_35) >>
                                              (fun _gen_bind_42  ->
                                                 (_negate_24 _next_39) >>
                                                   (fun _gen_bind_43  ->
                                                      _gen_bind_42 _gen_bind_43)))
                                             >>
                                             ((fun _newsum_41  ->
                                                 let _newacc_44 = _next_39 ::
                                                   _acc_36 in
                                                 ((_var_3 _newsum_41) >>
                                                    (fun _gen_bind_46  ->
                                                       _gen_bind_46 0))
                                                   >>
                                                   (fun _gen_bind_45  ->
                                                      match _gen_bind_45 with
                                                      | true  ->
                                                          (((_sub_search_34
                                                               _newsum_41)
                                                              >>
                                                              (fun _gen_bind_49
                                                                  ->
                                                                 _gen_bind_49
                                                                   _newacc_44))
                                                             >>
                                                             (fun _gen_bind_48
                                                                ->
                                                                _gen_bind_48
                                                                  _newacc_44))
                                                            >>
                                                            ((fun _gen_bind_47
                                                                ->
                                                                _gen_bind_47
                                                                  _rest_40))
                                                      | false  ->
                                                          (((_sub_search_34
                                                               _newsum_41)
                                                              >>
                                                              (fun _gen_bind_52
                                                                  ->
                                                                 _gen_bind_52
                                                                   _newacc_44))
                                                             >>
                                                             (fun _gen_bind_51
                                                                ->
                                                                _gen_bind_51
                                                                  _best_37))
                                                            >>
                                                            ((fun _gen_bind_50
                                                                ->
                                                                _gen_bind_50
                                                                  _rest_40)))))))) in
                      ((((_sub_search_34 0) >>
                           (fun _gen_bind_56  -> _gen_bind_56 []))
                          >> (fun _gen_bind_55  -> _gen_bind_55 []))
                         >> (fun _gen_bind_54  -> _gen_bind_54 _sublst_32))
                        >>
                        (fun _current_best_53  ->
                           (_k_33 ()) >>
                             (fun _next_best_57  ->
                                (((_length_14 _current_best_53) >>
                                    (fun _gen_bind_60  -> _var_4 _gen_bind_60))
                                   >>
                                   (fun _gen_bind_59  ->
                                      (_length_14 _next_best_57) >>
                                        (fun _gen_bind_61  ->
                                           _gen_bind_59 _gen_bind_61)))
                                  >>
                                  (fun _gen_bind_58  ->
                                     match _gen_bind_58 with
                                     | true  -> value _current_best_53
                                     | false  -> value _next_best_57))))
             | eff' -> (fun arg  -> fun k  -> Call (eff', arg, k)) : a ->
                                                                      (b ->
                                                                      _
                                                                      computation)
                                                                      ->
                                                                      _
                                                                      computation)
      } c
  let _solve_62 _lst_63 = _array_checker_31 (_find_subarray_27 _lst_63)

  let solve lst = _solve_62 lst
end
