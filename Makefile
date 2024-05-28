CAPUT := caput
VCD := caput.vcd
GTKWAVED := /cygdrive/c/Users/ethan.miller/Downloads/gtkwave-3.3.90-bin-win64/gtkwave64/bin/gtkwave.exe

build:
	@cd src && make

run: build
	./$(CAPUT)

wave_run: build
	./$(CAPUT)
	/cygdrive/c/Users/ethan.miller/Downloads/gtkwave-3.3.90-bin-win64/gtkwave64/bin/gtkwave.exe $(VCD)
	

clean:
	@rm -rf $(CAPUT) $(VCD)
