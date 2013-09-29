all: run

run: problema_4_tb
	ghdl -r problema_4_tb --stop-time=50ns --vcd=problema_4.vcd

problema_4_tb: problema_4 problema_4_tb.vhdl
	ghdl -a problema_4_tb.vhdl
	ghdl -e problema_4_tb

problema_4: components adder flopr alu imem dmem mux2 sl2 regfile signext problema_4.vhdl
	ghdl -a problema_4.vhdl

components: components.vhdl
	ghdl -a components.vhdl

full_adder: full_adder.vhdl
	ghdl -a full_adder.vhdl

adder: components full_adder adder.vhdl
	ghdl -a adder.vhdl

flopr: components flip_flop flopr.vhdl
	ghdl -a flopr.vhdl

flip_flop: flip_flop.vhdl
	ghdl -a flip_flop.vhdl

alu: alu.vhdl
	ghdl -a alu.vhdl

imem: imem.vhdl
	ghdl -a imem.vhdl

dmem: dmem.vhdl
	ghdl -a dmem.vhdl

mux2: mux2.vhdl
	ghdl -a mux2.vhdl

sl2: sl2.vhdl
	ghdl -a sl2.vhdl

regfile: regfile.vhdl
	ghdl -a regfile.vhdl

signext: signext.vhdl
	ghdl -a signext.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
	rm -rf *.dump
