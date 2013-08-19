all: run

run: problema_6_tb
	ghdl -r problema_6_tb --stop-time=150ns --vcd=problema_6.vcd

problema_6_tb: problema_6 problema_6_tb.vhdl
	ghdl -a problema_6_tb.vhdl
	ghdl -e problema_6_tb

problema_6: problema_6.vhdl
	ghdl -a problema_6.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
