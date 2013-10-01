library ieee;
library work;
use work.components.all;
use ieee.std_logic_1164.all;

entity de_ex is

  port(reset, clk : in std_logic;
       RtD, RdD : in std_logic_vector(4 downto 0);
       RtE, RdE : out std_logic_vector(4 downto 0);
       AluControlD : in std_logic_vector(2 downto 0);
       AluControlE : out std_logic_vector(2 downto 0);
       PCPlus4D, RD1D, RD2D, SignlmmD : in std_logic_vector(31 downto 0);
       PCPlus4E, RD1E, RD2E, SignlmmE : out std_logic_vector(31 downto 0);
       RegWriteD, MemToRegD, MemWriteD, JumpD, BranchD, AluSrcD, RegDstD : in std_logic;
       RegWriteE, MemToRegE, MemWriteE, JumpE, BranchE, AluSrcE, RegDstE : out std_logic);

end entity;

architecture behavior of de_ex is
begin

  RD1_FF        : flopr port map (reset => reset, clk => clk, d => RD1D, q => RD1E);
  RD2_FF        : flopr port map (reset => reset, clk => clk, d => RD2D, q => RD2E);
  PCPlus_FF     : flopr port map (reset => reset, clk => clk, d => PCPlus4D, q => PCPlus4E);
  Signlmm_FF    : flopr port map (reset => reset, clk => clk, d => SignlmmD, q => SignlmmE);
   
  Rt_FF         : flopr generic map (width => 5) port map (reset => reset, clk => clk, d => RtD, q => RtE);
  Rd_FF         : flopr generic map (width => 5) port map (reset => reset, clk => clk, d => RdD, q => RdE);
  AluControl_FF : flopr generic map (width => 3) port map (reset => reset, clk => clk, d => AluControlD, q => AluControlE);
   
  Jump_FF       : flip_flop port map (reset => reset, clk => clk, d => JumpD, q => JumpE);
  Branch_FF     : flip_flop port map (reset => reset, clk => clk, d => BranchD, q => BranchE);
  AluSrc_FF     : flip_flop port map (reset => reset, clk => clk, d => AluSrcD, q => AluSrcE);
  RegDst_FF     : flip_flop port map (reset => reset, clk => clk, d => RegDstD, q => RegDstE);
  RegWrite_FF   : flip_flop port map (reset => reset, clk => clk, d => RegWriteD, q => RegWriteE);
  MemToReg_FF   : flip_flop port map (reset => reset, clk => clk, d => MemToRegD, q => MemToRegE);
  MemWrite_FF   : flip_flop port map (reset => reset, clk => clk, d => MemWriteD, q => MemWriteE);

end architecture;
