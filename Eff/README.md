# Running Eff code

(These instructions have been tried and tested on MacOS and Linux)

## Installation

The install guide script `installguide.sh` contains a guide and all necessary
commands to install eff. It is recommended to run each command individually
but running the script directly is also an option and should be sufficient.

## Execution

(Make sure you have run `opam switch 4.05.0`, or whichever latest stable version you are running before continuing)

Once Eff has been installed on your system, simply run Eff with the `eff`
command in your terminal or by using ledit `ledit eff`.
Once you have have Eff running, load in individual `.eff` programs with `#use`. For example:

`#use "main.eff";;`

(Note: it is required to type the `#` symbol in order to get the command working.
Your terminal input should look something like this: `# #use "file.ml";;`)

Once the program is loaded, all functions inside the program can be freely executed.
