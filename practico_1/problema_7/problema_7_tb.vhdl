library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity problema_7_tb is
end entity;

architecture test_bench of problema_7_tb is
  function to_string (sv: std_logic_vector) return string is
    use std.textio.all;
    variable bv : bit_vector (sv'range) := to_bitvector (sv);
    variable lp : line;
  begin
    write (lp, bv);
    return lp.all;
  end;
  component imem
  port(a: in std_logic_vector(5 downto 0);
       d: out std_logic_vector(31 downto 0));
  end component;
  signal sa : std_logic_vector(5 downto 0);
  signal sd : std_logic_vector(31 downto 0);
begin
  tb_component : imem port map (a => sa, d => sd);
  process
  begin
    bucle : for i in 0 to 63 loop
      sa <= std_logic_vector(to_unsigned(i, sa'length));
      wait for 1 ns;
--      report "sa vector value: " & to_string(sa);
      assert sd = std_logic_vector(to_unsigned(i, sd'length));
    end loop;
  end process;
end architecture;
