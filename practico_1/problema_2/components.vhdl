library ieee;
use ieee.std_logic_1164.all;

package components is
  component flip_flop is
    port (d, reset, clk : in std_logic;
          q : out std_logic);
  end component;
end package;
