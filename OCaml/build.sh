set -e
# INSTRUCTIONS:
# Give execution permission to this script:
# $ chmod +x make.sh
# Run this script:
# $ ./make.sh
# Run the executable:
# $ ./run

# Build function
build() {
  # Define output folder
  OUT="_out"
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

  # Compile the problem solvers
  ocamlopt -c NQueens/nqueens.ml
  ocamlopt -c Memoization/fibonacci.ml
  ocamlopt -c Pipes/pipes.ml
  ocamlopt -c Parser/parser.ml
  ocamlopt -c TreeAlgorithm/fringe.ml
  # Compile the generator
  ocamlopt -c -I TreeAlgorithm Generator/generator.ml
  # Compile the timer
  ocamlopt -c -I Generator -I NQueens -I Memoization \
  -I Pipes -I Parser -I TreeAlgorithm Timer/timer.ml

  # Make executable
  ocamlopt -o run_timer Generator/generator.cmx NQueens/nqueens.cmx \
  Memoization/fibonacci.cmx Pipes/pipes.cmx \
  Parser/parser.cmx TreeAlgorithm/fringe.cmx Timer/timer.cmx

  # Output message
  echo "# Build successful"
  echo "# Commands to run tests:"
  echo "# $ ./run_timer [FUNCTION] [UPPER_LIMIT]"
  echo "# $ ./run_timer [FUNCTION] [UPPER_LIMIT] [AVERAGE_RUNS]"
  echo "# $ ./run_timer [FUNCTION] [LOWER_LIMIT] [UPPER_LIMIT] [AVERAGE_RUNS]"
  echo "# $ ./run_timer [FUNCTION] [LOWER_LIMIT] [UPPER_LIMIT] [AVERAGE_RUNS] [STEP_SIZE]"
  echo "#   Use a FUNCTION name from the give list below."
  echo "#   All other values to be given as integer values."
  echo "#   Default value of 1 will be used for unpassed parameters."
  echo "# Working function list:"
  echo "# NQ (nqueens)"
  echo "# FIB (fibonacci)"
  echo "# PRS (parser)"
  echo "# PIP (pipes)"
  echo "# FRNG (fringe)"
}
# Switch to multicore opam and configure
echo "# Switching to multicore compiler"
opam switch 4.05.0 >/dev/null
eval `opam config env`
echo "# Building..."
# Run main build function
build
