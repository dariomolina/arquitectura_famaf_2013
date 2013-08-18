all: run

run: problema_9_tb
	ghdl -r problema_9_tb --stop-time=20ns --vcd=problema_9.vcd

problema_9_tb: problema_9 problema_9_tb.vhdl
	ghdl -a problema_9_tb.vhdl
	ghdl -e problema_9_tb

problema_9: problema_9.vhdl
	ghdl -a problema_9.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
