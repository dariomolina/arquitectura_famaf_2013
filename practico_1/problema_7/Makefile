all: run

run: problema_7_tb
	ghdl -r problema_7_tb --stop-time=150ns --vcd=problema_7.vcd

problema_7_tb: problema_7 problema_7_tb.vhdl
	ghdl -a problema_7_tb.vhdl
	ghdl -e problema_7_tb

problema_7: problema_7.vhdl
	ghdl -a problema_7.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
