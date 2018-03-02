set -e
# INSTRUCTIONS:
# Give execution permission to this script:
# $ chmod +x make.sh
# Run this script:
# $ ./make.sh
# Run the executable:
# $ ./run

# Make main make function
make() {
  # Define output folder
  OUT="out"
  # Check if existing dir with same name.
  if ! [ -d $OUT ]; then
    # If no dir exists check if file with same name exists.
    if [ -f $OUT ]; then
      # If file exists and it's not a directory, warn user.
      echo "# File with path \"$OUT\" detected in folder."
      echo "# Please remove and re-run this script."
      return
    else
      # If no dir and no file exists, create it.
      mkdir $OUT
      echo "# Output directory created."
    fi
  fi

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
  ocamlopt -o run Generator/generator.cmx NQueens/nqueens.cmx \
  Memoization/fibonacci.cmx StressTest/stresstest.cmx Pipes/pipes.cmx \
  Parser/parser.cmx Timer/timer.cmx

  # Output message
  echo "# Compiled succesfully."
  echo "# Command to run tests: ./run [FUNC_NAME] [UPPER_LIMIT]"
  echo "# Working function list:"
  echo "# \"NQ\""
  echo "# \"PRS\""
  echo "# \"PIPES\""
  echo "# \"FIB\""
  echo "# \"STRESS\""
}
# Run main make function
make
