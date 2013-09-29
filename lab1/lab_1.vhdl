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
  signal PCBranch, Instruction, PCPlus4, WriteReg, WriteData : std_logic_vector(31 downto 0);
  signal Signlmm, rd1, rd2, PCJump, ResultW, AluOut, ReadData : std_logic_vector(31 downto 0);
begin

  instr <= Instruction;
  PCSrc <= Branch and Zero;
  PCJump <= PCPlus4(31 downto 28) & Instruction(25 downto 0) & "00";

  Instruction_Fetch : fetch port map (Jump => Jump, PcSrcM => PCSrc, clk => clk, reset => reset,
                                      PcBranchM => PCBranch, InstrF => Instruction,
                                      PCF => PC , PcPlus4F => PCPlus4);

  Instruction_Decode : decode port map (InstrD => Instruction, Wd3 => ResultW, PcBranchM => PCBranch,
                                        A3=> WriteReg(4 downto 0), clk => clk, RegWrite => RegWrite,
                                        SignlmmD => Signlmm, RD1D => rd1, RD2D => rd2);

  Instruction_Execute : execute port map (RtE => Instruction(20 downto 16), RdE => Instruction(15 downto 11),
                                          RD1E => rd1, RD2E => rd2, PCPlus4E => PCPlus4, SignlmmE => Signlmm,
                                          RegDst => RegDst, AluSrc => AluSrc, AluControl => AluControl,
                                          WriteRegE => WriteReg(4 downto 0), ZeroE => Zero, AluOutE => AluOut,
                                          WriteDataE => WriteData, PCBranchE => PCBranch);

  Memory_Access : memory port map (AluOutM => AluOut, WriteDataM => WriteData, MemWrite => MemWrite,
                                   Branch => Branch, ZeroM => Zero, clk => clk, dump => dump,
                                   PcSrcM => PCSrc, ReadDataM => ReadData);

  Write_Back : writeback port map (MemToReg => MemToReg, AluOutW => AluOut,
                                   ReadDataW => ReadData, ResultW => ResultW);
  
end architecture;
