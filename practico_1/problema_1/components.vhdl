library ieee;
use ieee.std_logic_1164.all;

package components is
  component full_adder is
    port (a, b, c_in : in std_logic;
          s, c_out : out std_logic);
  end component;
end package;
