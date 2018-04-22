(*
=== GENERATED FROM nqueens0.eff ===
commit SHA:
=== BEGIN SOURCE ===

external ( <> ) : int -> int -> bool = "<>"
external ( < ) : int -> int -> bool = "<"
external ( > ) : int -> int -> bool = ">"
external ( - ) : int -> int -> int = "-"
external ( + ) : int -> int -> int = "+"
external ( ~- ) : int -> int = "~-"
external ( = ) : int -> int -> bool = "="

effect Fail   : unit -> int
effect Select : unit -> bool

let abs x = if x < 0 then -x else x

let rec (@) xs ys =
  match xs with
  | [] -> ys
  | x :: xs -> x :: (xs @ ys)


let rec noAttack (i,j) = function
  | [] -> true
  | (k,l)::xs -> i <> k && j <> l && (abs (i - k)) <> (abs (j - l)) && noAttack (i,j) xs

let available n x qs =
  let rec checker acc y =
    if y = 0 then acc
    else if noAttack (x, y) qs then checker (y::acc) (y - 1)
    else checker acc (y - 1)
  in
  checker [] n

let rec choose = function
  | []    -> #Fail ()
  | x::xs -> if #Select () then x else choose xs

(* NQUEENS *)
let rec queens n =
  let rec put_queen x qns =
    if x = 0 then qns else
    let next = choose (available n x qns) in
    put_queen (x - 1) ((x,next)::qns)
  in put_queen n []

(* SOLVER / HANDLER *)
let selector = handler
  | #Select _ k -> k true @ k false
  | #Fail   _ _ -> []
  | val x     -> [x]

let solve n = with selector handle queens n

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

module NQueens : sig
  val solve : int -> (int * int) list list computation
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
  let _var_1 x = lift_binary (<>) x
  let _var_2 x = lift_binary (<) x
  let _var_3 x = lift_binary (>) x
  let _var_4 x = lift_binary (-) x
  let _var_5 x = lift_binary (+) x
  let _var_6 x = lift_unary (~-) x
  let _var_7 x = lift_binary (=) x
  type (_,_) effect +=
    | Effect_Fail: (unit,int) effect
  type (_,_) effect +=
    | Effect_Select: (unit,bool) effect
  let _abs_8 _x_9 =
    ((_var_2 _x_9) >> (fun _gen_bind_11  -> _gen_bind_11 0)) >>
      (fun _gen_bind_10  ->
         match _gen_bind_10 with | true  -> _var_6 _x_9 | false  -> value _x_9)
  let rec _var_12 _xs_13 =
    value
      (fun _ys_14  ->
         match _xs_13 with
         | [] -> value _ys_14
         | _x_15::_xs_16 ->
             ((_var_12 _xs_16) >> (fun _gen_bind_18  -> _gen_bind_18 _ys_14))
               >> ((fun _gen_bind_17  -> value (_x_15 :: _gen_bind_17))))
  let rec _noAttack_19 (_i_20,_j_21) =
    value
      (fun _gen_function_22  ->
         match _gen_function_22 with
         | [] -> value true
         | (_k_23,_l_24)::_xs_25 ->
             ((_var_1 _i_20) >> (fun _gen_bind_27  -> _gen_bind_27 _k_23)) >>
               ((fun _gen_bind_26  ->
                   match _gen_bind_26 with
                   | true  ->
                       ((_var_1 _j_21) >>
                          (fun _gen_bind_29  -> _gen_bind_29 _l_24))
                         >>
                         ((fun _gen_bind_28  ->
                             match _gen_bind_28 with
                             | true  ->
                                 (((((_var_4 _i_20) >>
                                       (fun _gen_bind_34  -> _gen_bind_34 _k_23))
                                      >>
                                      (fun _gen_bind_33  -> _abs_8 _gen_bind_33))
                                     >>
                                     (fun _gen_bind_32  -> _var_1 _gen_bind_32))
                                    >>
                                    (fun _gen_bind_31  ->
                                       (((_var_4 _j_21) >>
                                           (fun _gen_bind_37  ->
                                              _gen_bind_37 _l_24))
                                          >>
                                          (fun _gen_bind_36  ->
                                             _abs_8 _gen_bind_36))
                                         >>
                                         (fun _gen_bind_35  ->
                                            _gen_bind_31 _gen_bind_35)))
                                   >>
                                   ((fun _gen_bind_30  ->
                                       match _gen_bind_30 with
                                       | true  ->
                                           (_noAttack_19 (_i_20, _j_21)) >>
                                             ((fun _gen_bind_38  ->
                                                 _gen_bind_38 _xs_25))
                                       | false  -> value false))
                             | false  -> value false))
                   | false  -> value false)))
  let _available_39 _n_40 =
    value
      (fun _x_41  ->
         value
           (fun _qs_42  ->
              let rec _checker_43 _acc_44 =
                value
                  (fun _y_45  ->
                     ((_var_7 _y_45) >> (fun _gen_bind_47  -> _gen_bind_47 0))
                       >>
                       (fun _gen_bind_46  ->
                          match _gen_bind_46 with
                          | true  -> value _acc_44
                          | false  ->
                              ((_noAttack_19 (_x_41, _y_45)) >>
                                 (fun _gen_bind_49  -> _gen_bind_49 _qs_42))
                                >>
                                ((fun _gen_bind_48  ->
                                    match _gen_bind_48 with
                                    | true  ->
                                        (_checker_43 (_y_45 :: _acc_44)) >>
                                          ((fun _gen_bind_50  ->
                                              ((_var_4 _y_45) >>
                                                 (fun _gen_bind_52  ->
                                                    _gen_bind_52 1))
                                                >>
                                                (fun _gen_bind_51  ->
                                                   _gen_bind_50 _gen_bind_51)))
                                    | false  ->
                                        (_checker_43 _acc_44) >>
                                          ((fun _gen_bind_53  ->
                                              ((_var_4 _y_45) >>
                                                 (fun _gen_bind_55  ->
                                                    _gen_bind_55 1))
                                                >>
                                                (fun _gen_bind_54  ->
                                                   _gen_bind_53 _gen_bind_54))))))) in
              (_checker_43 []) >> (fun _gen_bind_56  -> _gen_bind_56 _n_40)))
  let rec _choose_57 _gen_let_rec_function_58 =
    match _gen_let_rec_function_58 with
    | [] -> (effect Effect_Fail) ()
    | _x_59::_xs_60 ->
        ((effect Effect_Select) ()) >>
          ((fun _gen_bind_61  ->
              match _gen_bind_61 with
              | true  -> value _x_59
              | false  -> _choose_57 _xs_60))
  let rec _queens_62 _n_63 =
    let rec _put_queen_64 _x_65 =
      value
        (fun _qns_66  ->
           ((_var_7 _x_65) >> (fun _gen_bind_68  -> _gen_bind_68 0)) >>
             (fun _gen_bind_67  ->
                match _gen_bind_67 with
                | true  -> value _qns_66
                | false  ->
                    ((((_available_39 _n_63) >>
                         (fun _gen_bind_72  -> _gen_bind_72 _x_65))
                        >> (fun _gen_bind_71  -> _gen_bind_71 _qns_66))
                       >> (fun _gen_bind_70  -> _choose_57 _gen_bind_70))
                      >>
                      ((fun _next_69  ->
                          (((_var_4 _x_65) >>
                              (fun _gen_bind_75  -> _gen_bind_75 1))
                             >>
                             (fun _gen_bind_74  -> _put_queen_64 _gen_bind_74))
                            >>
                            (fun _gen_bind_73  ->
                               _gen_bind_73 ((_x_65, _next_69) :: _qns_66)))))) in
    (_put_queen_64 _n_63) >> (fun _gen_bind_76  -> _gen_bind_76 [])
  let _selector_77 c =
    handler
      {
        value_clause = (fun _x_82  -> value [_x_82]);
        effect_clauses = fun (type a) -> fun (type b) ->
          fun (x : (a,b) effect)  ->
            (match x with
             | Effect_Select  ->
                 (fun (_ : unit)  ->
                    fun (_k_78 : bool -> _ computation)  ->
                      ((_k_78 true) >>
                         (fun _gen_bind_80  -> _var_12 _gen_bind_80))
                        >>
                        (fun _gen_bind_79  ->
                           (_k_78 false) >>
                             (fun _gen_bind_81  -> _gen_bind_79 _gen_bind_81)))
             | Effect_Fail  ->
                 (fun (_ : unit)  ->
                    fun (_ : int -> _ computation)  -> value [])
             | eff' -> (fun arg  -> fun k  -> Call (eff', arg, k)) : a ->
                                                                      (b ->
                                                                      _
                                                                      computation)
                                                                      ->
                                                                      _
                                                                      computation)
      } c
  let _solve_83 _n_84 = _selector_77 (_queens_62 _n_84)

  let solve n = _solve_83 n
end
