library ieee;
library work;
use work.components.all;
use ieee.std_logic_1164.all;

entity de_ex is

  port(reset, clk : in std_logic;
       PCPlus4D, RD1D, RD2D, SignlmmD, RtD, RdD : in std_logic_vector(31 downto 0);
       PCPlus4E, RD1E, RD2E, SignlmmE, RtE, RdE : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of de_ex is
begin

--  PCPlus_FF     : flopr port map (reset => reset, clk => clk, d => PCPlus4D, q => PCPlus4E);
--  RD1_FF        : flopr port map (reset => reset, clk => clk, d => RD1D, q => RD1E);
--  RD2_FF        : flopr port map (reset => reset, clk => clk, d => RD2D, q => RD2E);
--  Signllm_FF    : flopr port map (reset => reset, clk => clk, d => SignllmD, q => SignllmE);
--  Rt_FF         : flopr port map (reset => reset, clk => clk, d => RtD, q => RtE);
--  Rd_FF         : flopr port map (reset => reset, clk => clk, d => RdD, q => RdE);
--  RegWrite_FF   : flopr port map (reset => reset, clk => clk, d => RegWriteD, q => RegWriteE);
--  MemToReg_FF   : flopr port map (reset => reset, clk => clk, d => MemToRegD, q => MemToRegE);
--  MemWrite_FF   : flopr port map (reset => reset, clk => clk, d => MemWriteD, q => MemWriteE);
--  Jump_FF       : flopr port map (reset => reset, clk => clk, d => JumpD, q => JumpE);
--  Branch_FF     : flopr port map (reset => reset, clk => clk, d => BranchD, q => BranchE);
--  AluControl_FF : flopr generic map (width => 2) port map (reset => reset, clk => clk, d => AluControlD, q => AluControlE);
--  AluSrc_FF     : flopr port map (reset => reset, clk => clk, d => AluSrcD, q => AluSrcE);
--  RegDst_FF     : flopr port map (reset => reset, clk => clk, d => RegDstD, q => RegDstE);

  PCPlus4E    <= PCPlus4D;
  RD1E        <= RD1D;
  RD2E        <= RD2D;
  SignllmE    <= SignllmD;
  RtE         <= RtD;
  RdE         <= RdD;
  RegWriteE   <= RegWriteD;
  MemToRegE   <= MemToRegD;
  MemWriteE   <= MemWriteD;
  JumpE       <= JumpD;
  BranchE     <= BranchD;
  AluControlE <= AluControlD;
  AluSrcE     <= AluSrcD;
  RegDstE     <= RegDstD;
end architecture;
