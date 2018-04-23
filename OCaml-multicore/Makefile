build:
	@chmod +x build.sh
	./build.sh

test:
	@echo "Running NQueens time tests with input sizes between 0 and 13."
	@echo "Each test is run an average of 5 times."
	@./run_timer NQ   0 13   5
	@echo "Running boolean parser time tests. Testing expression depths between 0 and 25."
	@echo "Each test is run an average of 10 times."
	@./run_timer PRS  0 25   10
	@echo "Running fibonacci time tests, calculating the 0th to 5000th fibonacci numbers in steps of 100."
	@echo "Each test is run an average of 75 times."
	@./run_timer FIB  0 5000 75 100
	@echo "Running pipes time tests, (find longest subarray of equal number of 1's and 0's). Arrays randomly generated with sizes between 0 and 500 in steps of 10."
	@echo "Each test is run an average of 25 times."
	@./run_timer PIP  0 500  25  10
	@echo "Running fringe time tests, (verify if two binary trees have same leaves). Trees randomly generated with depths between 0 and 20."
	@echo "Each test is run an average of 25 times."
	@./run_timer FRNG 0 20   25
	@echo "Running stress tests. Perform an effect loop 0 to 500000 times in steps of 10000."
	@echo "Each test is run an average of 50 times."
	@./run_timer STRS 10000 500000 50 10000

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
