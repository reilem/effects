# Give execution permission to this script:
# $ chmod +x make.sh
# Run this script:
# $ ./make.sh

# Compile the generator
ocamlopt -c Generator/generator.ml
# Compile the problem solvers
ocamlopt -c NQueens/nqueens.ml
ocamlopt -c Memoization/fibonacci.ml
ocamlopt -c StressTest/stresstest.ml
ocamlopt -c Pipes/pipes.ml
ocamlopt -c Parser/parser.ml
# Compile the timer
ocamlopt -c -I Generator -I NQueens -I Memoization \
-I StressTest -I Pipes -I Parser Timer/timer.ml

# Make executable
ocamlopt -o Executables/run Generator/generator.cmx NQueens/nqueens.cmx \
Memoization/fibonacci.cmx StressTest/stresstest.cmx Pipes/pipes.cmx \
Parser/parser.cmx Timer/timer.cmx
