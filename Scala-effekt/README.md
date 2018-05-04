# Running Scala code

Our Scala project code can be found in `Effekt/src/main/scala`.

## Setup

It is recommended to open the project in an IDE such as Intellij as it will
automatically complete the setup procedure. Alternatively you can use the
following links to aid in your setup:

https://www.scala-lang.org/download/

https://github.com/b-studios/scala-effekt

## Running the code

In order to run the JIT optimised tests, simply uncomment one of the first
three lines of the main function in `Effekt/src/main/scalaTimer.scala` and
run the program either through the Intellij IDE or your desired method.

To run the non-JIT optimised code you need to compile the `Fibonacci.scala`,
`NQueens.scala` and `StressTest.scala` files into their respective `.jar` files.
Then place them in their respective paths:

`Effekt/out/artifacts/nqueens_jar/effekt.jar`
`Effekt/out/artifacts/fibonacci_jar/effekt.jar`
`Effekt/out/artifacts/stresstest_jar/effekt.jar`

Now you can run the `timer.sh` script in the following way:

`$ ./timer.sh [FUNCTION_NAME] [LOWER_BOUNDS] [UPPER_BOUNDS] [AVERAGE_COUNT]z

Or you can run `make test`.
