install_eff:
	git clone git@github.com:reilem/eff.git
	cd eff
	./configure
	make
	sudo make install

run_all:
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

test_all:
	mkdir -p _out
	eff Memoization/fibonacci.eff | tail -n 41 > _out/FIB.csv
	@echo ""
	eff NQueens/nqueens.eff 			| tail -n 12 > _out/NQ.csv
	@echo ""
	eff Parser/parser.eff 				| tail -n 16 > _out/PRS.csv
	@echo ""
	eff Pipes/pipes.eff 					| tail -n 51 > _out/PIP.csv
	@echo ""
	eff StressTest/stresstest.eff | tail -n 16 > _out/STRS.csv
	@echo ""
	eff TreeAlgorithm/fringe.eff 	| tail -n 16 > _out/FRNG.csv
