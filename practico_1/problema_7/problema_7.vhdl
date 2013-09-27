library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imem is
  port(a: in std_logic_vector(5 downto 0);
       d: out std_logic_vector(31 downto 0));
end entity;

architecture behavior of imem is
  function valid_address(arg: std_logic_vector) return std_logic is
    variable result: std_logic;
  begin
    result := '0';
    for i in arg'range loop
      result := result or arg(i) or (not arg(i));
    end loop;
    return result;
  end;
  type rom is array (0 to 63) of std_logic_vector(31 downto 0);
  signal memory : rom;
begin
  bucle : for i in 0 to 63 generate
    memory(i) <= std_logic_vector(to_unsigned(i, d'length));
  end generate;
  process (a)
  begin
    if (valid_address(a) = '1') then
      d <= memory(to_integer(unsigned(a)));
    else
      d <= (others => 'X');
    end if;
  end process;
end architecture;
