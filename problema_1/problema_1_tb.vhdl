library ieee;
use ieee.std_logic_1164.all;

entity problema_1_tb is
  generic (width : positive := 32);
end entity;

architecture test_bench of problema_1_tb is
  component fulladder32bits
    port (a, b : in std_logic_vector((width - 1) downto 0);
          y : out std_logic_vector(width downto 0));
  end component;
  signal sa, sb : std_logic_vector((width - 1) downto 0);
  signal sy : std_logic_vector(width downto 0);
begin
  tb_component : fulladder32bits port map (a => sa, b => sb, y => sy);
  process
  begin
    sa <= (0 => '1', others => '0');
    sb <= (0 => '1', others => '0');
    assert sy = "00000000000000000000000000000010";
    report "Pasa primera verificación";
    wait for 50 ns;
    sa <= (5 => '1', others => '0');
    sb <= (5 => '1', others => '0');
    assert sy = "000000000000000000000000001000000";
    report "Pasa segunda verificación";
    wait for 50 ns;
    sa <= (10 => '1', others => '0');
    sb <= (10 => '1', others => '0');
    assert sy = "00000000000000000000100000000000";
    report "Pasa tercera verificación";
    sa <= "11101001010001010001011110011100";
    sb <= "11110010010011000110001110100110";
    assert sy = "111011011100100010111101101000010"
    report "Pasa última verificación";
  end process;
end architecture;
