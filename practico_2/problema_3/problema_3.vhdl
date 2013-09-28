library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity controller is
  port(Op         : in std_logic_vector(5 downto 0);
       Funct      : in std_logic_vector(5 downto 0);
       MemToReg   : out std_logic;
       MemWrite   : out std_logic;
       Branch     : out std_logic;
       AluSrc     : out std_logic;
       RegDst     : out std_logic;
       RegWrite   : out std_logic;
       Jump       : out std_logic;
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
