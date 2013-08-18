library ieee;
use ieee.std_logic_1164.all;

entity problema_5_tb is
  generic (width : positive := 32);
end entity;

architecture test_bench of problema_5_tb is
  function to_string (sv: Std_Logic_Vector) return string is
    use Std.TextIO.all;
    variable bv: bit_vector(sv'range) := to_bitvector(sv);
    variable lp: line;
  begin
    write (lp, bv);
    return lp.all;
  end;
  component signext
  port (a : in std_logic_vector (((width / 2) - 1) downto 0);
        y : out std_logic_vector ((width - 1) downto 0));
  end component;
  signal sa : std_logic_vector (((width / 2) - 1) downto 0);
  signal sy : std_logic_vector((width - 1) downto 0);
begin
  tb_component : signext port map (a => sa, y => sy);
  process
  begin
    sa <= "1100010110111000";
    wait for 5 ns;
--    report "sy vector value: " & to_string(sy);
    assert sy = "11111111111111111100010110111000";
    sa <= "0010101110101100";
    wait for 5 ns;
--    report "sy vector value: " & to_string(sy);
    assert sy = "00000000000000000010101110101100";
  end process;
end architecture;
