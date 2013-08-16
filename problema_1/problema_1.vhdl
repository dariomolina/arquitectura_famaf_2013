library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity fulladder32bits is
  generic (width : positive := 32);
  port (a, b : in std_logic_vector(width - 1 downto 0);
        y : out std_logic_vector(width downto 0));
end entity;

architecture behaviour of fulladder32bits is
  signal outs : std_logic_vector(width downto 0);
  signal carries : std_logic_vector(width downto 0);
begin
  bucle : for i in 0 to (width - 1) generate
    fulladder : full_adder port map (a => a(i), b => b(i), c_in => carries(i), s => outs(i), c_out => carries(i + 1));
  end generate;
  y <= outs;
  carries(0) <= '0';
  y(width) <= carries(width);
end architecture;
