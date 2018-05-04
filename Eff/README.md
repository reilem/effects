# Running Eff code

(These instructions have been tried and tested on MacOS and Linux)

## Installation

To run our interpreted time tests in eff you need to install our custom branch
of eff. To do this either run `make install_eff` or follow these commands:

`$ git clone git@github.com:reilem/eff.git`

`$ cd eff`

`$ ./configure`

`$ make`

`$ sudo make install`

Complete installation instructions for the regular version of eff can be found at: https://github.com/matijapretnar/eff

## Execution

### With the eff interpreter

Once our version of Eff has been installed on your system, you can either run our eff tests indiviudally or with either `make run_all_eff` or `make test_all_eff`.

To run the tests individually, run Eff top-level with the `eff` command in your terminal or by using ledit `ledit eff`. Once you have have Eff running, load in individual `.eff` programs with `#use`. For example:

`#use "main.eff";;`

(Note: it is required to type the `#` symbol in order to get the command working.
Your terminal input should look something like this: `# #use "file.ml";;`)

Once the program is loaded, all functions inside the loaded source code can be  executed.

### With OCaml

We have already gone through the trouble of compiling the eff code found in this repo to OCaml. To run the compiled ocaml code you can either run `make build_ocaml` and then `make test_ocaml`, or you can run the build script `./build.sh` and follow the instructions printed to terminal.

## Makefile overview

`make install_eff` - installs our custom version of eff

`make run_all_eff` - runs all interpreted tests and prints output to terminal

`make test_all_eff` - runs all interpreted tests and captures output to a csv file found in the _out folder

`make build_ocaml` - builds the eff to ocaml compiled code into a binary

`make test_ocaml` - runs all the eff to ocaml compiled tests using the built binary

`make clean_ocaml` - cleans all ocaml compilation files from this dir

`make clean_results` - cleans all results form the output folder

`make clean_all` - performs `make clean` and `make clean_results`
