library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
  port( ra1, ra2, wa3: in std_logic_vector(4 downto 0);
        wd3: in std_logic_vector(31 downto 0);
        we3, clk: in std_logic;
        rd1, rd2: out std_logic_vector(31 downto 0)
       );
end regfile;

architecture behavior of regfile is
  type reg_memory is array (0 to 31) of std_logic_vector(31 downto 0);
  signal memory : reg_memory;
  begin
  process(clk)
    begin
      if (clk'event and we3 = '1') then
        memory(to_integer(unsigned(wa3))) <= wd3;
      end if;
  end process;

  rd1 <= memory(to_integer(unsigned(ra1)));
  rd2 <= memory(to_integer(unsigned(ra2)));
end architecture;
