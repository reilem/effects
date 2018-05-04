build:
	@chmod +x build.sh
	./build.sh

test:
	@echo "Running time tests..."
	@echo "================ NQueens ================"
	./run_timer NQ   0 15   1
	@echo "================ Parser ================="
	./run_timer PRS  0 25   10
	@echo "=============== Fibonacci ==============="
	./run_timer FIB  0 5000 500 100
	@echo "================= Pipes ================="
	./run_timer PIP  0 750  25  10
	@echo "================ Fringe ================="
	./run_timer FRNG 0 20   25
	@echo "============== StressTest ==============="
	./run_timer STRS 0 500000 50 10000
	@echo "========================================="

clean:
	rm -f run_timer
	find . -name "*.cmi" -type f -delete
	find . -name "*.cmx" -type f -delete
	find . -name "*.o" -type f -delete

clean_results:
	rm -rf _out

clean_all:
	make clean
	make clean_results
