library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmem is
  port(a, wd: in std_logic_vector(31 downto 0);
       rd: out std_logic_vector(31 downto 0);
       clk, we: in std_logic);
end dmem;

architecture behavior of dmem is
  function valid_address(arg: std_logic_vector) return std_logic is
    variable result: std_logic;
  begin
    result := '0';
    for i in arg'range loop
      result := result or arg(i) or (not arg(i));
    end loop;
    return result;
  end;
  type ram is array (0 to 63) of std_logic_vector(31 downto 0);
  signal sa : std_logic_vector(5 downto 0);
  signal memory : ram;
begin
  process (clk, a)
  begin
    if (valid_address(sa) = '1') then
      sa <= a(7 downto 2);
      if (clk'event and clk = '1' and we = '1') then
        memory(to_integer(unsigned(sa))) <= wd;
      end if;
      rd <= memory(to_integer(unsigned(sa)));
    else
      rd <= (others => 'X');
    end if;
 end process;
end architecture;
