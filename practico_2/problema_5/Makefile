all: run

run: problema_5_tb
	ghdl -r problema_5_tb --stop-time=150ns --vcd=problema_5.vcd

problema_5_tb: problema_5 problema_5_tb.vhdl
	ghdl -a problema_5_tb.vhdl
	ghdl -e problema_5_tb

problema_5: components datapath controller problema_5.vhdl
	ghdl -a problema_5.vhdl

datapath: components adder flopr alu imem dmem mux2 sl2 regfile signext datapath.vhdl
	ghdl -a datapath.vhdl

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

controller: components maindec aludec controller.vhdl
	ghdl -a controller.vhdl

maindec: maindec.vhdl
	ghdl -a maindec.vhdl

aludec: aludec.vhdl
	ghdl -a aludec.vhdl

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
