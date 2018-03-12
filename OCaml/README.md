# Running OCaml multicore code

(These instructions have been tried and tested on MacOS and Linux)

## Installation

The install guide script `installguide.sh` contains a guide and all necessary
commands to install ocaml. It is recommended to run each command
individually but running the script directly is also an option and should be
sufficient.

## Execution

Our ocaml code can be built using the `make.sh` script. (Make sure to
give execution permissions to the `make.sh` script with `chmod +x make.sh`
before running). The output of the make script will provide details on how to
run and execute the produced binary.

Alternatively you can choose to run `.ml` files individually by running the
`ocaml` command directly in your terminal (or with ledit `ledit ocaml`) and then
loading in files individually with `#use "file.ml"`.

(Note: it is required to type the `#` symbol in order to get the command working.
Your terminal input should look something like this: `# #use "mail.ml";;`)

Once the program is loaded, all functions inside the program can be freely
executed.
