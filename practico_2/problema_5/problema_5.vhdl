library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity mips is
  port ( reset, clk, dump : in std_logic;
         pc, instr        : out std_logic_vector(31 downto 0)
       );
end entity;

architecture behaviour of mips is
  signal sIns, sPC : std_logic_vector(31 downto 0);
  signal MemToReg, MemWrite, Branch     : std_logic;
  signal AluSrc, RegDst, RegWrite, Jump : std_logic;
  signal Aluop : std_logic_vector(1 downto 0);
  signal AluControl : std_logic_vector(2 downto 0);
begin

  sIns <= inicializacion;
  sPC  <= inicializacion;

  cont : controller port map (Op => sIns(31 downto 26), Instr => sIns(5 downto 0), MemToReg => MemToReg, MemWrite => MemWrite, Branch => Branch, AluSrc => AluSrc, RegDst => RegDst, RegWrite => RegWrite, Jump => Jump, Aluop => Aluop, AluControl => AluControl);
  
  dp   : datapath port map (MemToReg => MemToReg, MemWrite => MemWrite, Branch => Branch, AluSrc => AluSrc, RegDst => RegDst, RegWrite => RegWrite, Jump => Jump, AluControl => AluControl, dump => dump, reset => reset, clk => clk, pc => sPC, instr => sIns);

end architecture;
