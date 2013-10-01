library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity decode is

  port (clk, RegWriteW : in std_logic;
        A3 : in std_logic_vector(4 downto 0);
        RtD, RdD : out std_logic_vector(4 downto 0);
        AluControlD : out std_logic_vector(2 downto 0);
        InstrD, Wd3 : in std_logic_vector(31 downto 0);
        SignlmmD, RD1D, RD2D : out std_logic_vector(31 downto 0);
        MemToRegD, MemWriteD, BranchD, AluSrcD, RegDstD, RegWriteD, JumpD : out std_logic);

end entity;

architecture behavior of decode is
begin

  RtD <= InstrD(20 downto 16);
  RdD <= InstrD(15 downto 11);

  cont        : controller port map (Op => InstrD(31 downto 26), Funct => InstrD(5 downto 0), MemToReg => MemToRegD,
                                     MemWrite => MemWriteD, Branch => BranchD, AluSrc => AluSrcD, RegDst => RegDstD,
                                     RegWrite => RegWriteD, Jump => JumpD, AluControl => AluControlD);

  MipsSignExt : signext port map (a => InstrD(15 downto 0), y => SignlmmD);

  Registers   : regfile port map (ra1 => InstrD(25 downto 21), ra2 => InstrD(20 downto 16),
                                  wa3 => A3, wd3 => Wd3, we3 => RegWriteW, clk => clk, rd1 => RD1D, rd2 => RD2D);

end architecture;
