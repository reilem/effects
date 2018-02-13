open Printf

let rec show = function
  | [] -> ()
  | [x] -> printf "%d\n" x
  | e :: l ->
    print_int e;
    print_string " ";
    show l

let n =
  if Array.length Sys.argv > 1 then
    int_of_string Sys.argv.(1)
  else 8

let solutions n =
  let rec safe i j k = function
    | [] -> true
    | h::t -> h<>i && h<>j && h<>k && safe i (j+1) (k-1) t in
  let rec loop col p =
    for i = 1 to n
    do
      if safe i (i+1) (i-1) p then
        let p' = i::p in
        if col = n then show p'
        else loop (col+1) p'
    done in
  loop 1 []

let _ = solutions n
