library ieee;
use ieee.std_logic_1164.all;

entity full_adder is

  port (s, c_out : out std_logic;
        a, b, c_in : in std_logic);

end entity;

architecture behaviour of full_adder is
begin

  s <= a xor b xor c_in;
  c_out <= (c_in and (a xor b)) or (a and b);

end architecture;
