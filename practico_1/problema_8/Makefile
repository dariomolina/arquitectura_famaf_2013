all: run

run: problema_8_tb
	ghdl -r problema_8_tb --stop-time=150ns --vcd=problema_8.vcd

problema_8_tb: problema_8 problema_8_tb.vhdl
	ghdl -a problema_8_tb.vhdl
	ghdl -e problema_8_tb

problema_8: problema_8.vhdl
	ghdl -a problema_8.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
