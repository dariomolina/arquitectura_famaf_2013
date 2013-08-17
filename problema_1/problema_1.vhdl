library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;
use IEEE.numeric_std.all;

entity fulladder32bits is
  generic (width : positive := 32);
  port (a, b : in std_logic_vector(width - 1 downto 0);
        y : out std_logic_vector(width downto 0));
end entity;

architecture behaviour of fulladder32bits is
  signal outs : std_logic_vector(width downto 0);
  signal carries : std_logic_vector(width downto 0);
begin
  carries(0) <= '0';
  bucle : for i in 0 to (width - 1) generate
    fulladder : full_adder port map (a => a(i), b => b(i), c_in => carries(i), s => y(i), c_out => carries(i + 1));
  end generate;
  y(width) <= carries(width);
end architecture;

architecture easy_solution of fulladder32bits is
begin
  y <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));
end architecture;
