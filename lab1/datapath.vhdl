library ieee;
library work;
use work.components.all;
use ieee.std_logic_1164.all;

entity datapath is

  port(dump, clk, reset : in std_logic;
       pc, instr : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of datapath is

begin

  instr <= Instruction;
  PCSrc <= Branch and Zero;
  PCJump <= PCPlus4(31 downto 28) & Instruction(25 downto 0) & "00";

  FetchSeg     : fetch     port map (Jump => Jump, PcSrcM => PCSrc, clk => clk, reset => reset,
                                     PcBranchM => PCBranch, InstrF => InstrFD,
                                     PCF => PC , PcPlus4F => PCPlus4FD);

  IfDe         : if_de     port map (reset => reset, clk => clk,
                                     InstrF => InstrFD, PCPlus4F => PCPlus4FD,
                                     InstrD => InstrDF, PCPlus4D => PCPlus4DF);

  DecodeSeg    : decode    port map (InstrD => InstrDF, Wd3 => ResultWD,
                                     A3 => WriteRegWD, clk => clk, RegWrite => RegWrite,
                                     SignlmmD => Signlmm, RD1D => RD1DE, RD2D => RD2DE);

  DeEx         : de_ex     port map (reset => reset, clk => clk,
                                     PCPlus4D => PCPlus4DF, RD1D => RD1DE, RD2D => RD2DE, SignlmmD => Signlmm,
                                     RtD => InstrFD(20 downto 16), RdD => InstrFD(15 downto 11),
                                     PCPlus4E => PCPlus4EM, RD1E => RD1EM, RD2E => RD2EM,
                                     SignlmmE => SignlmmEM, RtE => RtEM, RdE => RdEM);

  ExecuteSeg   : execute   port map (RtE => RtEM, RdE => RdEM,
                                     RD1E => RD1EM, RD2E => RD2EM, PCPlus4E => PCPlus4EM, SignlmmE => SignlmmEM,
                                     RegDst => RegDst, AluSrc => AluSrc, AluControl => AluControl,
                                     WriteRegE => WriteRegEM, ZeroE => ZeroEM, AluOutE => AluOutEM,
                                     WriteDataE => WriteDataEM, PCBranchE => PCBranchEM);

  ExMe         : ex_me     port map (ZeroE => ZeroEM, ZeroM => ZeroMWB, reset => reset, clk => clk,
                                     WriteRegE => WriteRegEM, WriteRegM => WriteRegMWB,
                                     AluOutE => AluOutEM, WriteDataE => WriteDataEM,
                                     AluOutM => AluOutMWB, WriteDataM => WriteDataMWB,
                                     PCBranchE => PCBranchEM, PCBranchM => PCBranchMWB);

  MemorySeg    : memory    port map (AluOutM => AluOutEM, WriteDataM => WriteDataEM, MemWrite => MemWrite,
                                     Branch => Branch, ZeroM => ZeroEM, clk => clk, dump => dump,
                                     PcSrcM => PCSrcM, ReadDataM => ReadDataM);

  MeWb         : me_wb     port map (reset => reset, clk => clk,
                                     WriteRegM => WriteRegMWB, WriteRegW => WriteRegWD,
                                     AluOutM => AluOutMWB, ReadDataM => ReadDataM,
                                     AluOutW => AluOutWM, ReadDataW => ReadDataWM);

  WriteBackSeg : writeback port map (MemToReg => MemToReg, AluOutW => AluOutWM,
                                     ReadDataW => ReadDataWM, ResultW => ResultWD);

end architecture;
