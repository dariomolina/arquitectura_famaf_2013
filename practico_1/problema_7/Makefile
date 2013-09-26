all: run

run: problema_7_tb
	ghdl -r problema_7_tb --stop-time=150ns --vcd=problema_7.vcd

problema_7_tb: problema_7 problema_7_tb.vhdl
	ghdl -a -Wc,-m32 -Wa,--32 problema_7_tb.vhdl
	ghdl -e -Wa,--32 -Wl,-m32 problema_7_tb

problema_7: problema_7.vhdl
	ghdl -a -Wc,-m32 -Wa,--32 problema_7.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
