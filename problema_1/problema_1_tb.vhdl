library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity problema_1_tb is
  generic (width : positive := 32);
end entity;

architecture test_bench of problema_1_tb is
  function to_string (sv: Std_Logic_Vector) return string is
    use Std.TextIO.all;
    variable bv: bit_vector(sv'range) := to_bitvector(sv);
    variable lp: line;
  begin
    write (lp, bv);
    return lp.all;
  end;
  component adder
    port (a, b : in std_logic_vector((width - 1) downto 0);
          y : out std_logic_vector(width downto 0));
  end component;
  signal sa, sb : std_logic_vector((width - 1) downto 0);
  signal sy : std_logic_vector(width downto 0);
begin
  -- Here you can pass as argument the
  -- name of the architecture
  -- that you want to use for the test bench
  tb_component : entity work.adder(behaviour) port map (a => sa, b => sb, y => sy);
  process
  begin
    sa <= (0 => '1', others => '0');
    sb <= (0 => '1', others => '0');
    wait for 5 ns;
--    report "sy vector value: " & to_string(sy);
    assert sy = "000000000000000000000000000000010";
    sa <= (5 => '1', others => '0');
    sb <= (5 => '1', others => '0');
    wait for 5 ns;
--    report "sy vector value: " & to_string(sy);
    assert sy = "000000000000000000000000001000000";
    sa <= (10 => '1', others => '0');
    sb <= (10 => '1', others => '0');
    wait for 5 ns;
--    report "sy vector value: " & to_string(sy);
    assert sy = "000000000000000000000100000000000";
    sa <= "11101001010001010001011110011100";
    sb <= "11110010010011000110001110100110";
    wait for 5 ns;
--    report "sy vector value: " & to_string(sy);
    assert sy = "111011011100100010111101101000010";
  end process;
end architecture;
