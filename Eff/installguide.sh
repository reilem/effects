# DO NOT RUN THIS SCRIPT UNLESS YOU ARE SURE YOU ALREADY HAVE OCAML & OPAM
# INSTALLED. IT IS RECOMMENDED TO RUN THESE COMMANDS INDIVIDUALLY.
# Do not forget to make sure this script has execution permissions
# if you wish to run this script: "chmod +x installguide.sh"

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
