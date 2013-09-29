library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity controller is
  port(MemToReg, MemWrite, Branch : out std_logic;
       AluSrc, RegDst, RegWrite, Jump : out std_logic;
       Op : in std_logic_vector(5 downto 0);
       Funct : in std_logic_vector(5 downto 0);
       AluControl : out std_logic_vector(2 downto 0));
end controller;

architecture behavior of controller is
  signal sAluOp : std_logic_vector(1 downto 0);
begin
  main_dec : maindec port map (Op => Op, MemToReg => MemToReg, MemWrite => MemWrite,
                               Branch => Branch, AluSrc => AluSrc, RegDst => RegDst,
                               RegWrite => RegWrite, Jump => Jump, AluOp => sAluOp);

  alu_dec : aludec port map (AluOp => sAluOp, Funct => Funct, AluControl => AluControl);
end architecture;
