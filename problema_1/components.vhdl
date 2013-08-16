library ieee;
use ieee.std_logic_1164.all;

package components is
  component full_adder is
    port (a, b, c_in : std_logic;
          s, c_out : std_logic);
  end component;
end package;
