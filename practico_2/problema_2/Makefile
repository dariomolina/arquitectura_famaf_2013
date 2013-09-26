all: run

run: problema_2_tb
	ghdl -r problema_2_tb --stop-time=150ns --vcd=problema_2.vcd

problema_2_tb: problema_2 problema_2_tb.vhdl
	ghdl -a problema_2_tb.vhdl
	ghdl -e problema_2_tb

problema_2: problema_2.vhdl
	ghdl -a problema_2.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
