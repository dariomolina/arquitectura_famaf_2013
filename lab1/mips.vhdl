library ieee;
library work;
use work.components.all;
use ieee.std_logic_1164.all;

entity mips is

  port (reset, clk, dump : in std_logic;
        pc, instr : out std_logic_vector(31 downto 0));

end entity;

architecture behaviour of mips is

  signal AluControlE, AluControlD : std_logic_vector (2 downto 0);

  signal WriteRegW, WriteRegE, WriteRegM, RdE, RtE, RtD, RdD : std_logic_vector (4 downto 0);

  signal JumpM, PcSrcM, MemToRegW, RegWriteW, MemToRegM, RegWriteM, ZeroM, BranchM, MemWriteM, BranchE, JumpE, MemToRegE, RegWriteE, MemWriteE, ZeroE, AluSrcE, RegDstE, RegWriteD, RegDstD, JumpD, MemToRegD, AluSrcD, BranchD, MemWriteD : std_logic;

  signal PcBranchM, ReadDataW, AluOutW, ReadDataM, ResultW, AluOutM, AluOutE, PCBranchE, WriteDataE, WriteDataM, SignlmmE, PCPlus4E, RD1E, RD2E, InstrF, PCPlus4F, InstrD, PCPlus4D, SignlmmD, RD1D, RD2D : std_logic_vector(31 downto 0);

begin

  component_fetch      : fetch  port map (clk => clk, reset => reset, Jump => JumpM, PcSrcM => PcSrcM,
                                          PcBranchM => PcBranchM, InstrF => InstrF, PCF => pc, PcPlus4F => PcPlus4F);

  fetch_decode         : if_de  port map (clk => clk, reset => reset,
                                          InstrF => InstrF, PCPlus4F => PcPlus4F,
                                          InstrD => InstrD, PCPlus4D => PCPlus4D);

  component_decode     : decode port map (clk => clk, RegWriteW => RegWriteW, A3 => WriteRegW, RegWriteD => RegWriteD,
                                          InstrD => InstrD, Wd3 => ResultW, SignlmmD => SignlmmD, RegDstD => RegDstD, RD1D => RD1D,
                                          RD2D => RD2D, RtD => RtD, RdD => RdD, AluControlD => AluControlD, JumpD => JumpD,
                                          MemToRegD => MemToRegD, MemWriteD => MemWriteD, BranchD => BranchD, AluSrcD => AluSrcD);

  decode_execute       : de_ex  port map (clk => clk, reset => reset, PCPlus4D => PCPlus4D, RtE => RtE,
                                          RD1D => RD1D, RD2D => RD2D, SignlmmD => SignlmmD, JumpE => JumpE,
                                          RtD => RtD, RdD => RdD, RegWriteD => RegWriteD, MemToRegD => MemToRegD, RdE => RdE,
                                          MemWriteD => MemWriteD, JumpD => JumpD, BranchD => BranchD, AluControlD => AluControlD,
                                          AluSrcD => AluSrcD, RegDstD => RegDstD, PCPlus4E => PCPlus4E, RD1E => RD1E, RD2E => RD2E,
                                          SignlmmE => SignlmmE, RegWriteE => RegWriteE, MemToRegE => MemToRegE, AluSrcE => AluSrcE,
                                          MemWriteE => MemWriteE, BranchE => BranchE, AluControlE => AluControlE, RegDstE => RegDstE);

  component_execute    : execute port map (RD1E => RD1E, RD2E => RD2E, PCPlus4E => PCPlus4E, SignlmmE => SignlmmE, ZeroE => ZeroE,
                                           RegDst => RegDstE, AluSrc => AluSrcE, RtE => RtE, RdE => RdE, AluControl => AluControlE,
                                           WriteRegE => WriteRegE, AluOutE => AluOutE, WriteDataE => WriteDataE, PCBranchE => PCBranchE);

  execution_memory     : ex_me port map (clk => clk, reset => reset, ZeroE => ZeroE, MemWriteE => MemWriteE,
                                         WriteRegE => WriteRegE, RegWriteE => RegWriteE, MemToRegE => MemToRegE,
                                         JumpE => JumpE, BranchE => BranchE, AluOutE => AluOutE, WriteDataE => WriteDataE,
                                         PCBranchE => PCBranchE, AluOutM => AluOutM, WriteDataM => WriteDataM, JumpM => JumpM,
                                         ZeroM => ZeroM, WriteRegM => WriteRegM, RegWriteM => RegWriteM, MemToRegM => MemToRegM,
                                         MemWriteM => MemWriteM, PCBranchM => PcBranchM, BranchM => BranchM);

  component_memory     : memory port map (clk => clk, MemWrite => MemWriteM, dump => dump,
                                          BranchM => BranchM, ZeroM => ZeroM, ReadDataM => ReadDataM,
                                          AluOutM => AluOutM, WriteDataM => WriteDataM, PcSrcM => PcSrcM);

  memory_write_back    : me_wb port map (clk => clk, reset => reset, RegWriteM => RegWriteM, MemToRegM => MemToRegM,
                                         WriteRegM => WriteRegM, AluOutM => AluOutM, ReadDataM => ReadDataM, RegWriteW => RegWriteW,
                                         MemToRegW => MemToRegW, WriteRegW => WriteRegW, AluOutW => AluOutW, ReadDataW => ReadDataW);

  component_write_back : writeback port map (MemToReg => MemToRegW, ResultW => ResultW,
                                             AluOutW => AluOutW, ReadDataW => ReadDataW);

end architecture;
