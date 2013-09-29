library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity decode is

  port (InstrD, Wd3, PcBranchM : in std_logic_vector(31 downto 0);
        A3 : in std_logic_vector(4 downto 0);
        clk, RegWrite : in std_logic;
        SignlmmD, RD1D, RD2D : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of decode is
begin

  signExtMIPS : signext port map (a => InstrD(15 downto 0), y => SignlmmD);

  rgfile      : regfile port map (ra1 => InstrD(25 downto 21), ra2 => InstrD(20 downto 16),
                                  wa3 => A3, wd3 => Wd3, we3 => RegWrite, clk => clk, rd1 => RD1D, rd2 => RD2D);

end architecture;
