library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity mips is

  port (reset, clk, dump : in std_logic;
        pc, instr : out std_logic_vector(31 downto 0));

end entity;

architecture behaviour of mips is

  signal sAluop : std_logic_vector(1 downto 0);
  signal sIns, sPC : std_logic_vector(31 downto 0);
  signal sAluControl : std_logic_vector(2 downto 0);
  signal sMemToReg, sMemWrite, sBranch : std_logic;
  signal sAluSrc, sRegDst, sRegWrite, sJump : std_logic;

begin

  pc <= sPC;
  instr <= SIns;

  cont : controller port map (Op => sIns(31 downto 26), Funct => sIns(5 downto 0), MemToReg => sMemToReg,
                              MemWrite => sMemWrite, Branch => sBranch, AluSrc => sAluSrc, RegDst => sRegDst,
                              RegWrite => sRegWrite, Jump => sJump, AluControl => sAluControl);

  dp : datapath port map (MemToReg => sMemToReg, MemWrite => sMemWrite, Branch => sBranch,
                          AluSrc => sAluSrc, RegDst => sRegDst, RegWrite => sRegWrite, Jump => sJump,
                          AluControl => sAluControl, dump => dump, reset => reset, clk => clk,
                          pc => sPC, instr => sIns);

end architecture;
