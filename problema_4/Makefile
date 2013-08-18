all: run

run: problema_4_tb
	ghdl -r problema_4_tb --stop-time=20ns --vcd=problema_4.vcd

problema_4_tb: problema_4 problema_4_tb.vhdl
	ghdl -a problema_4_tb.vhdl
	ghdl -e problema_4_tb

problema_4: problema_4.vhdl
	ghdl -a problema_4.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
