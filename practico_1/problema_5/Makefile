all: run

run: problema_5_tb
	ghdl -r problema_5_tb --stop-time=20ns --vcd=problema_5.vcd

problema_5_tb: problema_5 problema_5_tb.vhdl
	ghdl -a problema_5_tb.vhdl
	ghdl -e problema_5_tb

problema_5: problema_5.vhdl
	ghdl -a problema_5.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
