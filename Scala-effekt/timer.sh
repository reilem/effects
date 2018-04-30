
timer () {
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

  f_name="$1"
  lower_bounds="$2"
  upper_bounds="$3"
  avg="$4"
  step="$5"

  if [ "$f_name" == "NQ" ]
  then
    func="java -jar Effekt/out/artifacts/nqueens_jar/effekt.jar"
  elif [ "$f_name" == "FIB" ]
  then
    func="java -jar Effekt/out/artifacts/fibonacci_jar/effekt.jar"
  elif [ "$f_name" == "STRS" ]
  then
    func="java -jar Effekt/out/artifacts/stresstest_jar/effekt.jar"
  else
    return
  fi

  file="_out/$f_name.csv"
  echo "n,x"
  echo "n,x" > $file
  size_counter=$lower_bounds
  while [ $size_counter -le $upper_bounds ]
  do
    avg_counter=1
    time_counter=0
    while [ $avg_counter -le $avg ]
    do
      time=$($func $size_counter)
      ((time_counter+=$time))
      ((avg_counter++))
    done
    time_avg=$((time_counter / avg))
    result="$size_counter,$time_avg"
    echo $result
    echo $result >> $file
    ((size_counter+=$step))
  done
  echo "Results outputted to $file"
}
timer $1 $2 $3 $4 $5
