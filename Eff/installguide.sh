# DO NOT RUN THIS SCRIPT UNLESS YOU ARE SURE YOU ALREADY HAVE OCAML & OPAM
# INSTALLED. IT IS RECOMMENDED TO RUN THESE COMMANDS INDIVIDUALLY.

# Switch to latest (ca. 21/02/2018) Official ocaml release
# Run "opam switch list" to find latest official release.
opam switch 4.05.0
# Setup new switch in the current shell
eval `opam config env`

# Install menhir
opam install menhir
# Install js_of_ocaml
opam install js_of_ocaml
# Download and build Eff
opam pin add eff git@github.com:matijapretnar/eff.git


# Fancy version eff
opam switch 4.02.1
opam install ocamlfind
opam install pprint
opam install menhir

./eff --compile --no-opt --no-pervasives [eff file name]

[copy paste everything up until "No pervasives" onto the .eff.ml file and run]
