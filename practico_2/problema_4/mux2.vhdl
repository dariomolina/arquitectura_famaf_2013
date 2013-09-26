library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
  generic (width : positive := 32);
  port (s : in std_logic;
        d0, d1 : in std_logic_vector((width - 1) downto 0);
        y : out std_logic_vector((width - 1) downto 0));
end entity;

architecture behaviour of mux2 is
begin
  process (s)
  begin
    if (s = '0') then
      y <= d0;
    elsif (s = '1') then
      y <= d1;
    end if;
  end process;
end architecture;
