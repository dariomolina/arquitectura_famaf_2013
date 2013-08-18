all: run

run: problema_2_tb
	ghdl -r problema_2_tb --stop-time=20ns --vcd=problema_2.vcd

problema_2_tb: problema_2 problema_2_tb.vhdl
	ghdl -a problema_2_tb.vhdl
	ghdl -e problema_2_tb

problema_2: components flip_flop problema_2.vhdl
	ghdl -a problema_2.vhdl

components: components.vhdl
	ghdl -a components.vhdl

flip_flop: flip_flop.vhdl
	ghdl -a flip_flop.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
