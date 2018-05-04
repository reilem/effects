run_all_eff:
	eff Memoization/fibonacci.eff
	@echo ""
	eff NQueens/nqueens.eff
	@echo ""
	eff Parser/parser.eff
	@echo ""
	eff Pipes/pipes.eff
	@echo ""
	eff StressTest/stresstest.eff
	@echo ""
	eff TreeAlgorithm/fringe.eff

test_all_eff:
	mkdir -p _out
	eff Memoization/fibonacci.eff | tail -n 27 > _out/FIB.csv
	@echo ""
	eff NQueens/nqueens.eff.      | tail -n 13 > _out/NQ.csv
	@echo ""
	eff Parser/parser.eff 	      | tail -n 19 > _out/PRS.csv
	@echo ""
	eff Pipes/pipes.eff           | tail -n 52 > _out/PIP.csv
	@echo ""
	eff StressTest/stresstest.eff | tail -n 19 > _out/STRS.csv
	@echo ""
	eff TreeAlgorithm/fringe.eff  | tail -n 18 > _out/FRNG.csv

install_eff_compile:
	git clone git@github.com:reilem/eff.git
	cd eff
	./configure
	make
	sudo make install

build_ocaml:
	@chmod +x build.sh
	./build.sh

test_ocaml:
	@echo "Running NQueens time tests with input sizes between 1 and 11."
	@echo "Each test is run an average of 1 times."
	@./run_timer NQ   0 14   1 1
	@echo "Running fibonacci time tests, calculating the 1st to 1500th fibonacci numbers in steps of 100."
	@echo "Each test is run an average of 10 times."
	@./run_timer FIB  0 3000 20 100
	@echo "Running pipes time tests, (find longest subarray of equal number of 1's and 0's). Arrays randomly generated with sizes between 0 and 500 in steps of 10."
	@echo "Each test is run an average of 5 times."
	@./run_timer PIP  0 750  25 10
	@echo "Running stress tests. Perform an effect loop 10000 to 150000 times in steps of 10000."
	@echo "Each test is run an average of 1 times."
	@./run_timer STRS 0 500000 50 10000

clean_ocaml:
	rm run_timer
	find . -name "*.cmi" -type f -delete
	find . -name "*.cmx" -type f -delete
	find . -name "*.o" -type f -delete

clean_results_ocaml:
	rm -r _out

clean_all_ocaml:
	make clean
	make clean_results
