all: run

run: problema_3_tb
	ghdl -r problema_3_tb --stop-time=150ns --vcd=problema_3.vcd

problema_3_tb: problema_3 problema_3_tb.vhdl
	ghdl -a problema_3_tb.vhdl
	ghdl -e problema_3_tb

problema_3: components maindec aludec problema_3.vhdl
	ghdl -a problema_3.vhdl

components: components.vhdl
	ghdl -a components.vhdl

maindec: maindec.vhdl
	ghdl -a maindec.vhdl

aludec: aludec.vhdl
	ghdl -a aludec.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
