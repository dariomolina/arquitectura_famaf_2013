library ieee;
library work;
use work.components.all;
use ieee.std_logic_1164.all;

entity ex_me is

  port(ZeroM : out std_logic;
       ZeroE, reset, clk : in std_logic;
       WriteRegE : in std_logic_vector(4 downto 0);
       WriteRegM : out std_logic_vector(4 downto 0);
       AluOutE, WriteDataE, PCBranchE : in std_logic_vector(31 downto 0);
       AluOutM, WriteDataM, PCBranchM : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of ex_me is
begin

--  Zero_FF      : flip_flop port map (reset => reset, clk => clk, d => ZeroE, q => ZeroM);
--  AluOut_FF    : flopr     port map (reset => reset, clk => clk, d => AluOutE, q => AluOutM);
--  PCBranch_FF  : flopr     port map (reset => reset, clk => clk, d => PCBranchE, q => PCBranchM);
--  WriteData_FF : flopr     port map (reset => reset, clk => clk, d => WriteDataE, q => WriteDataM);
--  WriteReg_FF  : flopr     generic map (width => 4) port map (reset => reset, clk => clk, d => WriteRegE, q => WriteRegM);

--  RegWrite_FF   : flopr port map (reset => reset, clk => clk, d => RegWriteE, q => RegWriteM);
--  MemToReg_FF   : flopr port map (reset => reset, clk => clk, d => MemToRegE, q => MemToRegM);
--  MemWrite_FF   : flopr port map (reset => reset, clk => clk, d => MemWriteE, q => MemWriteM);
--  Jump_FF       : flopr port map (reset => reset, clk => clk, d => JumpE, q => JumpM);
--  Branch_FF     : flopr port map (reset => reset, clk => clk, d => BranchE, q => BranchM);

  ZeroM       <= ZeroE;
  AluOutM     <= AluOutE;
  PCBranchM   <= PCBranchE;
  WriteDataM  <= WriteDataE;
  WriteRegM   <= WriteRegE;
  RegWriteM   <= RegWriteE;
  MemToRegM   <= MemToRegE;
  MemWriteM   <= MemWriteE;
  JumpM       <= JumpE;
  BranchM     <= BranchE;
  -- Esto no se si va aca, pero es correcto.
  PCSrcM      <= BranchM and ZeroM;
end architecture;
