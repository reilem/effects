# Effects & Effect Handlers
## Reinert Lemmens, Lucas Engels

### Introduction

This repo currently contains implementations for a number of problems in Eff
and OCaml multicore. This repo is a work in progress.

### Results

Our results can be found at our github pages site at: https://reilem.github.io/effects/

Or in the per language `_results` folder that can be found in each language's directory.

### Setup

#### OCaml setup (Eff, OCaml-multicore, OCaml)

All OCaml code in this repo will require ocaml and opam to setup, compile and run.

OCaml compiler and library installation instructions can be found at:
https://ocaml.org/docs/install.html

Opam is a package manager for OCaml. Installation instructions can be found at:
http://opam.ocaml.org/doc/Install.html

#### Scala setup

#### Koka setup

### Running code

Code building and execution instructions can be found in the READMEs for each
separate implementation in their respective folder.

#### Ledit

It is recommended to download and use ledit to run our code interactively.
Ocaml and Eff provide a standard top level interpreter put ledit provides some much needed functionality.

Ledit can be setup with `opam install ledit`, and then used with either
`ledit ocaml` or `ledit eff`.

Note: The OCaml multicore compiler may not work well together with ledit.
