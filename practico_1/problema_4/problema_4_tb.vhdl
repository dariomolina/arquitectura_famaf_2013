library ieee;
use ieee.std_logic_1164.all;

entity problema_4_tb is
  generic (width : positive := 32);
end entity;

architecture test_bench of problema_4_tb is
  function to_string (sv: std_logic_vector) return string is
    use std.textio.all;
    variable bv : bit_vector (sv'range) := to_bitvector (sv);
    variable lp : line;
  begin
    write (lp, bv);
    return lp.all;
  end;
  component sl2
    port (a : in std_logic_vector ((width - 1) downto 0);
          y : out std_logic_vector ((width - 1) downto 0));
  end component;
  signal sa : std_logic_vector ((width - 1) downto 0);
  signal sy : std_logic_vector((width - 1) downto 0);
begin
  tb_component : sl2 port map (a => sa, y => sy);
  process
  begin
    sa <= "11110010010011000110001110100110";
    wait for 5 ns;
--    report "sy vector value: " & to_string(sy);
    assert sy = "11001001001100011000111010011000";
    sa <= "11001001001100011000111010011000";
    wait for 5 ns;
--    report "sy vector value: " & to_string(sy);
    assert sy = "00100100110001100011101001100000";
  end process;
end architecture;
