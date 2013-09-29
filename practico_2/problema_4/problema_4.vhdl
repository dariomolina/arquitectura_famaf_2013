library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity datapath is

  port(MemToReg, MemWrite, Branch, AluSrc, reset : in std_logic;
       RegDst, RegWrite, Jump, dump, clk : in std_logic;
       AluControl : in std_logic_vector(2 downto 0);
       pc, instr : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of datapath is

  signal Zero, PCSrc : std_logic;
  signal PCJump, PCPlus4, PCNext, PCBranch, PC0 : std_logic_vector(31 downto 0);
  signal PC1, WriteReg, WriteData, SrcA, SrcB, Result, Signlmm : std_logic_vector(31 downto 0);
  signal Sl2Adder, ReadData, Instruction, ALUResult : std_logic_vector(31 downto 0);
  signal TmpAdder1, TmpAdder2 : std_logic_vector(32 downto 0);

begin

  PCPlus4 <= TmpAdder1(31 downto 0);
  PCBranch <= TmpAdder2(31 downto 0);
  pc <= PC1;
  instr <= Instruction;
  PCSrc <= Branch and Zero;
  PCJump <= PCPlus4(31 downto 28) & Instruction(25 downto 0) & "00";

  muxPC : mux2 port map (s => PCSrc, d0 => PCPlus4,
                         d1 => PCBranch, y => PCNext);

  muxJump : mux2 port map (s => Jump, d0 => PCNext,
                           d1 => PCJump, y => PC0);

  flopPC : flopr port map (reset => reset, clk => clk,
                           d => PC0, q => PC1);

  instruction_memory : imem port map (a => PC1(7 downto 2), rd => Instruction);

  addPC : adder port map (a => PC1, b => (2 => '1', others => '0'), y => TmpAdder1);

  rgfile : regfile port map (ra1 => Instruction(25 downto 21), ra2 => Instruction(20 downto 16),
                             wa3 => WriteReg(4 downto 0), wd3 => Result, we3 => RegWrite,
                             clk => clk, rd1 => SrcA, rd2 => WriteData);

  muxReg : mux2 generic map (width => 5) port map (s => RegDst, d0 => Instruction(20 downto 16),
                                                   d1 => Instruction(15 downto 11), y => WriteReg(4 downto 0));

  signExtMIPS : signext port map (a => Instruction(15 downto 0), y => Signlmm);

  muxALU : mux2 port map (s => AluSrc, d0 => WriteData,
                          d1 => Signlmm, y => SrcB);

  sl2PCBranch : sl2 port map (a => Signlmm, y => Sl2Adder);

  ALUMIPS : alu port map (alucontrol => AluControl, a => SrcA, b => SrcB,
                       zero => Zero, result => ALUResult);

  addPCBranch : adder port map (a => Sl2Adder, b => PCPlus4, y => TmpAdder2);

  memMIPS : dmem port map (a => ALUResult, wd => WriteData,
                           clk => clk, we => MemWrite, rd => ReadData, dump => dump);

  muxToReg : mux2 port map (s => MemToReg, d0 => ALUResult,
                            d1 => ReadData, y => Result);

end architecture;
