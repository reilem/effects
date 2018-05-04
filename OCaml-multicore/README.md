# Running OCaml multicore code

(These instructions have been tried and tested on MacOS and Linux)

## Prerequisites

* An OCaml compiler (http://ocaml.org/docs/install.html)
* OPam, the OCaml package manager (https://opam.ocaml.org/)

## Multicore Installation

Add multicore from remote repo:

`$ opam remote add multicore https://github.com/ocamllabs/multicore-opam.git`

Switch to ocaml multicore compiler:

`$ opam switch 4.02.2+multicore`

Setup new switch in the current shell:

``$ eval `opam config env` ``

## Execution

Our ocaml multicore code can be built either with `make build` or by running the build
script `build.sh` directly. The output of the
build will provide details on how to run and execute the produced binary
for running individual tests. Alternatively you can run all the standard tests
with `make test`.

You can also run the `.ml` files individually by running the
`ocaml` command directly in your terminal (or with ledit `ledit ocaml`) and then
loading in files individually with `#use "file.ml"`. Make sure you have run
`opam switch 4.02.2+multicore` before attempting to run files individually.

Once the program is loaded, all functions inside the program can be freely
executed.

## Makefile overview

`make build` - build the executable binary

`make test` - run all tests

`make clean` - clean compile output and binary file

`make clean_results` - clean all results form the output folder

`make clean_all` - performs `make clean` and `make clean_results`
