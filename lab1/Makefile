all: run

run: mips_tb
	ghdl -r mips_tb --stop-time=150ns --vcd=mips.vcd

mips_tb: mips mips_tb.vhdl
	ghdl -a mips_tb.vhdl
	ghdl -e mips_tb

mips: components controller maindec aludec fetch decode execute memory write_back adder flopr alu imem dmem mux2 sl2 regfile signext datapath if-de de-ex ex-me me-wb mips.vhdl
	ghdl -a mips.vhdl

if-de: if-de.vhdl
	ghdl -a if-de.vhdl

de-ex: de-ex.vhdl
	ghdl -a if-de.vhdl

ex-me: ex-me.vhdl
	ghdl -a ex-me.vhdl

me-wb: if-de.vhdl
	ghdl -a me-wb.vhdl

maindec: maindec.vhdl
	ghdl -a maindec.vhdl

aludec: aludec.vhdl
	ghdl -a aludec.vhdl

controller: components controller.vhdl
	ghdl -a controller.vhdl

datapath: components datapath.vhdl
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
