library ieee;
use ieee.std_logic_1164.all;

entity sl2 is
  generic (width : positive := 32);
  port (a : in std_logic_vector ((width - 1) downto 0);
        y : out std_logic_vector ((width - 1) downto 0));
end entity;

architecture behaviour of sl2 is
begin
  y <= a((width - 3) downto 0) & "00";
end architecture;
