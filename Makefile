ARIOSTO := ariosto
VCD := ariosto.vcd
GTKWAVED := /cygdrive/c/Users/ethan.miller/Downloads/gtkwave-3.3.90-bin-win64/gtkwave64/bin/gtkwave.exe

build:
	@cd rtl && make

run: build
	./$(ARIOSTO)

wave_run: build
	./$(ARIOSTO)
	/cygdrive/c/Users/ethan.miller/Downloads/gtkwave-3.3.90-bin-win64/gtkwave64/bin/gtkwave.exe waveform.gtkw

clean:
	@rm -rf $(ARIOSTO) $(VCD)
