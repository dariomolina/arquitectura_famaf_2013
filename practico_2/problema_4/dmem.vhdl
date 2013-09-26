library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmem is
  port( a: in std_logic_vector(31 downto 0);
        wd: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        we: in std_logic;
        rd: out std_logic_vector(31 downto 0)
       );
end entity;

architecture behavior of dmem is
  type memory_ram is array (0 to 63) of std_logic_vector(31 downto 0);
  signal sa : std_logic_vector(5 downto 0);
  signal ram : memory_ram;
  begin
  -- descarto los bits de 32..8 y 1..0, es decir me quedo con los bits del 2..7
    sa <= a (7 downto 2);
    process (clk)
      begin
      if (clk'event and we = '1') then
        ram(to_integer(unsigned(a))) <= wd;
      end if;
    end process;
    rd <= ram(to_integer(unsigned(a)));
end architecture;
