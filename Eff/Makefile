install_eff:
	git clone git@github.com:reilem/eff.git
	cd eff
	./configure
	make
	sudo make install

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
	eff Memoization/fibonacci.eff | tail -n 26 > _out/FIB.csv
	@echo ""
	eff NQueens/nqueens.eff 			| tail -n 12 > _out/NQ.csv
	@echo ""
	eff Parser/parser.eff 				| tail -n 18 > _out/PRS.csv
	@echo ""
	eff Pipes/pipes.eff 					| tail -n 51 > _out/PIP.csv
	@echo ""
	eff StressTest/stresstest.eff | tail -n 18 > _out/STRS.csv
	@echo ""
	eff TreeAlgorithm/fringe.eff 	| tail -n 17 > _out/FRNG.csv

build_ocaml:
	@chmod +x build.sh
	./build.sh

test_ocaml:
	@echo "Running NQueens time tests with input sizes between 1 and 11."
	@echo "Each test is run an average of 1 times."
	@./run_timer NQ   1 11   1 1
	# @echo "Running boolean parser time tests. Testing expression depths between 1 and 25."
	# @echo "Each test is run an average of 10 times."
	# @./run_timer PRS  1    25   10
	@echo "Running fibonacci time tests, calculating the 1st to 1500th fibonacci numbers in steps of 100."
	@echo "Each test is run an average of 10 times."
	@./run_timer FIB  0 1500 10 100
	@echo "Running pipes time tests, (find longest subarray of equal number of 1's and 0's). Arrays randomly generated with sizes between 0 and 500 in steps of 10."
	@echo "Each test is run an average of 5 times."
	@./run_timer PIP  0 500  5 10
	# @echo "Running fringe time tests, (verify if two binary trees have same leaves). Trees randomly generated with depths between 1 and 20."
	# @echo "Each test is run an average of 25 times."
	# @./run_timer FRNG 1    20   25
	@echo "Running stress tests. Perform an effect loop 10000 to 150000 times in steps of 10000."
	@echo "Each test is run an average of 1 times."
	@./run_timer STRS 10000 150000 1 10000

clean_ocaml:
	rm -f run_timer
	find . -name "*.cmi" -type f -delete
	find . -name "*.cmx" -type f -delete
	find . -name "*.o" -type f -delete

clean_results_ocaml:
	rm -rf _out

clean_all_ocaml:
	make clean
	make clean_results
