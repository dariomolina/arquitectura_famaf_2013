library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity problema_2_tb is
  generic (width : positive := 32);
end entity;

architecture test_bench of problema_2_tb is
  function to_string (sv: Std_Logic_Vector) return string is
    use Std.TextIO.all;
    variable bv: bit_vector(sv'range) := to_bitvector(sv);
    variable lp: line;
  begin
    write (lp, bv);
    return lp.all;
  end;
  component flopr
    port (reset, clk : in std_logic;
          d : in std_logic_vector((width - 1) downto 0);
          q : out std_logic_vector((width - 1) downto 0));
  end component;
  signal sreset, sclk : std_logic;
  signal sd, sq : std_logic_vector((width - 1) downto 0);
begin
  -- Here you can pass as argument the
  -- name of the architecture
  -- that you want to use for the test bench
  tb_component : entity work.flopr(easy_solution) port map (reset => sreset, clk => sclk, d => sd, q => sq);
  process
  begin
    sclk <= '1';
    wait for 1 ns;
    sclk <= '0';
    wait for 1 ns;
  end process;
  process
  begin
    sreset <= '1';
    wait for 5 ns;
--    report "sq vector value: " & to_string(sq);
    assert sq = "00000000000000000000000000000000";
    sreset <= '0';
    sd <= "11110010010011000110001110100110";
    wait for 5 ns;
--    report "sq vector value: " & to_string(sq);
    assert sq = "11110010010011000110001110100110";
    sreset <= '1';
    wait for 0.1 ns;
--    report "sq vector value: " & to_string(sq);
    assert sq = "00000000000000000000000000000000";
    sreset <= '0';
    sd <= "01001000101110011100110010110110";
    wait for 5 ns;
--    report "sq vector value: " & to_string(sq);
    assert sq = "01001000101110011100110010110110";
  end process;
end architecture;
