library ieee;
use ieee.std_logic_1164.all;

entity problema_3_tb is
  generic (width : positive := 32);
end entity;

architecture test_bench of problema_3_tb is
  function to_string (sv: Std_Logic_Vector) return string is
    use Std.TextIO.all;
    variable bv: bit_vector(sv'range) := to_bitvector(sv);
    variable lp: line;
  begin
    write (lp, bv);
    return lp.all;
  end;
  component mux2
    port (s : in std_logic;
          d0, d1 : in std_logic_vector((width - 1) downto 0);
          y : out std_logic_vector((width - 1) downto 0));
  end component;
  signal ss : std_logic;
  signal sd0, sd1, sy : std_logic_vector((width - 1) downto 0);
begin
  tb_component : mux2 port map (s => ss, d0 => sd0, d1 => sd1, y => sy);
  process
  begin
    sd0 <= "01001000101110011100110010110110";
    sd1 <= "11110010010011000110001110100110";
    ss <= '0';
    wait for 5 ns;
--    report "sy vector value: " & to_string(sy);
    assert sy = "01001000101110011100110010110110";
    ss <= '1';
    wait for 5 ns;
--    report "sy vector value: " & to_string(sy);
    assert sy = "11110010010011000110001110100110";
  end process;
end architecture;
