build_test_all:
	cd Eff && $(MAKE) test_all && cd ..
	cd OCaml && $(MAKE) build && $(MAKE) test && cd ..
	cd OCaml-multicore && $(MAKE) build && $(MAKE) test && cd ..
	mkdir -p _out
	zip -r _out/eff_results.zip Eff/_out
	zip -r _out/ocaml_results.zip OCaml/_out
	zip -r _out/ocaml-m_results.zip OCaml-multicore/_out
