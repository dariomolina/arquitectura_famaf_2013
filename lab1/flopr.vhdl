library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity flopr is

  generic (width : positive := 32);
  port (reset, clk : in std_logic;
        d : in std_logic_vector((width - 1) downto 0);
        q : out std_logic_vector((width - 1) downto 0));

end entity;

architecture behaviour of flopr is
begin

  bucle : for i in 0 to (width - 1) generate
    flipflop : flip_flop port map (reset => reset, clk => clk, d => d(i), q => q(i));
  end generate;

end architecture;

architecture easy_solution of flopr is
begin

  process (clk, reset)
  begin

    if (reset = '1') then
      q <= (others => '0');
    elsif (clk'event and clk = '1') then
      q <= d;
    end if;

  end process;

end architecture;
