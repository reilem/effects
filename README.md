# Effects & Effect Handlers
## Reinert Lemmens, Lucas Engels

### Introduction

The purpose of this repo is to test and compare the performance of different
implementations of algebraic effects and effect handlers.
This repo contains implementations for a number of algorithms in OCaml,
OCaml multicore, Eff, Koka and Scala. Each language also contains a time testing
method which will vary from language to language. See the README's in each
language's respective directory for more details.

### Results

Our results can be found at our github pages site at: https://reilem.github.io/effects/

Or in the per language `_results` folder that can be found in each language's directory.

### OCaml Setup

All OCaml-related code (Eff, OCaml, OCaml-multicore) in this repo will
require ocaml and opam to setup, compile and run.

OCaml compiler and library installation instructions can be found at:
https://ocaml.org/docs/install.html

Opam is a package manager for OCaml. Installation instructions can be found at:
http://opam.ocaml.org/doc/Install.html

#### Ledit

It is recommended to download and use ledit to run our ocaml code interactively. Ocaml and Eff provide a standard top level interpreter but ledit provides some much needed functionality.

Ledit can be setup with `opam install ledit`, and then used with either
`ledit ocaml` or `ledit eff`.

Note: The OCaml multicore top level interpreter does not work well together with ledit.

### Running code

Code building and execution instructions can be found in the READMEs for each
separate implementation in their respective folder.

### Problems or improvements

If you have any trouble running the code, suggestions or questions in general feel free
to contact me at: reilemx@gmail.com, or by making an issue on this repo.
