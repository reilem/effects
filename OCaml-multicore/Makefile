build:
	chmod +x build.sh
	./build.sh

test:
	./run_timer NQ  10 5
	./run_timer PRS 15 75
	./run_timer FIB 500 10
	./run_timer PIP 250 10
	./run_timer FRNG 15 10

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
