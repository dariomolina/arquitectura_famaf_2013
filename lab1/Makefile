all: run

run: datapath_tb
	ghdl -r datapath_tb --stop-time=150ns --vcd=datapath.vcd

datapath_tb: datapath datapath_tb.vhdl
	ghdl -a datapath_tb.vhdl
	ghdl -e datapath_tb

datapath: components fetch decode execute memory write_back adder flopr alu imem dmem mux2 sl2 regfile signext datapath.vhdl
	ghdl -a datapath.vhdl

fetch: components fetch.vhdl
	ghdl -a fetch.vhdl

decode: components decode.vhdl
	ghdl -a decode.vhdl

execute: components execute.vhdl
	ghdl -a execute.vhdl

memory: components memory.vhdl
	ghdl -a memory.vhdl

write_back: components write_back.vhdl
	ghdl -a write_back.vhdl

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
