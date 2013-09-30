library ieee;
use ieee.std_logic_1164.all;

entity signext is

  generic (width : positive := 32);
  port (y : out std_logic_vector ((width - 1) downto 0);
        a : in std_logic_vector (((width / 2) - 1) downto 0));

end entity;

architecture behaviour of signext is
begin

  process (a)

    variable most_significant_bit : std_logic;
    variable extension : std_logic_vector(((width / 2) - 1) downto 0);

  begin

    most_significant_bit := a((width / 2) - 1);

    bucle : for i in 0 to ((width / 2) - 1) loop
      extension(i) := most_significant_bit;
    end loop;

    y <=  extension & a;

  end process;
end architecture;
