all: run

run: problema_1_tb
	ghdl -r problema_1_tb --stop-time=150ns --vcd=problema_1.vcd

problema_1_tb: problema_1 problema_1_tb.vhdl
	ghdl -a problema_1_tb.vhdl
	ghdl -e problema_1_tb

problema_1: components full_adder problema_1.vhdl
	ghdl -a problema_1.vhdl

components: components.vhdl
	ghdl -a components.vhdl

full_adder: full_adder.vhdl
	ghdl -a full_adder.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
