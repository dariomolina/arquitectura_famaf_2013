library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imem is
  port( a: in std_logic_vector(5 downto 0);
        d: out std_logic_vector(31 downto 0)
       );
end imem;

architecture behavior of imem is
  type memory_rom is array (0 to 63) of std_logic_vector(31 downto 0);
  signal rom : memory_rom;
  begin

  d <= rom(to_integer(unsigned (a)));
end architecture;
