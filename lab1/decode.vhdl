library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity decode is

  port (InstrD, Wd3, PcBranchM : in std_logic_vector(31 downto 0);
        A3 : in std_logic_vector(4 downto 0);
        clk, RegWrite : in std_logic;
        SignImmD, RD1D, RD2D : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of decode is

  signal SignImm, rd1, rd2 : std_logic_vector(31 downto 0);

begin

  xSignImmD <= SignImm;
  RD1D <= rd1;
  RD2D <= rd2;

  signExtMIPS : signext port map (a => InstrD(15 downto 0), y => Signlmm);

  rgfile      : regfile port map (ra1 => InstrD(25 downto 21), ra2 => InstrD(20 downto 16),
                                  wa3 => A3, wd3 => Wd3, we3 => RegWrite, clk => clk, rd1 => rd1, rd2 => rd2);

end architecture;
