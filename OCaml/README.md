# Running OCaml multicore code

(These instructions have been tried and tested on MacOS and Linux)

## Prerequisites

* An OCaml compiler (http://ocaml.org/docs/install.html)
* OPam, the OCaml package manager (https://opam.ocaml.org/)

## Execution

Our ocaml code can be built either with `make build` or by running the build
script `build.sh` directly. (Make sure to give execution permissions to the
`build.sh` script with `chmod +x make.sh` before running). The output of the
make script will provide details on how to run and execute the produced binary
for running individual tests. Alternatively you can run the full test suite
with `make test`.

You can also run the `.ml` files individually by running the
`ocaml` command directly in your terminal (or with ledit `ledit ocaml`) and then
loading in files individually with `#use "file.ml"`.

Once the program is loaded, all functions inside the program can be freely
executed.

## Makefile overview

`make build` - build the executable binary

`make test` - run all tests

`make clean` - clean compile output and binary file

`make clean_results` - clean all results form the output folder

`make clean_all` - performs `make clean` and `make clean_results`
