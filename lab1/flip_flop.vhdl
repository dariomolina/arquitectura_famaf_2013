library ieee;
use ieee.std_logic_1164.all;

entity flip_flop is

  port (q : out std_logic;
        d, reset, clk : in std_logic);

end entity;

architecture behaviour of flip_flop is
begin

  process (clk, reset)
  begin

    if (reset = '1') then
      q <= '0';
    elsif (clk'event and clk = '1') then
      q <= d;
    end if;

  end process;

end architecture;
