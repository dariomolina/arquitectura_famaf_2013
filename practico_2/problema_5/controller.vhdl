library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity controller is
  port( Op         : in std_logic_vector(5 downto 0);
        Funct      : in std_logic_vector(5 downto 0);
        MemToReg   : out std_logic;
        MemWrite   : out std_logic;
        Branch     : out std_logic;
        AluSrc     : out std_logic;
        RegDst     : out std_logic;
        RegWrite   : out std_logic;
        Jump       : out std_logic;
        Aluop      : out std_logic_vector(1 downto 0);
        AluControl : out std_logic_vector(2 downto 0)
       );
end controller;

architecture behavior of controller is
  signal saluop : std_logic_vector(1 downto 0);
  begin
   main_dec : maindec port map (Op => Op, MemToReg => MemToReg, MemWrite => MemWrite, Branch => Branch, AluSrc => AluSrc, RegDst => RegDst,
                             RegWrite => RegWrite, Jump => Jump, Aluop => saluop);

   alu_dec  : aludec port map  (Aluop => saluop, Funct => Funct, AluControl => AluControl);
end architecture;
