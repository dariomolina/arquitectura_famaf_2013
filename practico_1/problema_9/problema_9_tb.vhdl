library ieee;
use ieee.std_logic_1164.all;

entity problema_9_tb is
end entity;

architecture test_bench of problema_9_tb is
  function to_string (sv: Std_Logic_Vector) return string is
    use Std.TextIO.all;
    variable bv: bit_vector(sv'range) := to_bitvector(sv);
    variable lp: line;
  begin
    write (lp, bv);
    return lp.all;
  end;
  component aludec
    port (funct : in std_logic_vector(5 downto 0);
          aluop : in std_logic_vector(1 downto 0);
          alucontrol : out std_logic_vector(2 downto 0));
  end component;
  signal sfunct : std_logic_vector(5 downto 0);
  signal saluop : std_logic_vector(1 downto 0);
  signal salucontrol : std_logic_vector(2 downto 0);
begin
  tb_component : aludec port map (funct => sfunct, aluop => saluop, alucontrol => salucontrol);
  process
  begin
    saluop <= "00";
    wait for 5 ns;
--    report "salucontrol vector value: " & to_string(sy);
    assert salucontrol = "010";
    saluop <= "01";
    wait for 5 ns;
--    report "salucontrol vector value: " & to_string(sy);
    assert salucontrol = "110";
    saluop <= "10";
    sfunct <= "100000";
    wait for 5 ns;
--    report "salucontrol vector value: " & to_string(sy);
    assert salucontrol = "010";
    sfunct <= "100010";
    wait for 5 ns;
--    report "salucontrol vector value: " & to_string(sy);
    assert salucontrol = "110";
    sfunct <= "100100";
    wait for 5 ns;
--    report "salucontrol vector value: " & to_string(sy);
    assert salucontrol = "000";
    sfunct <= "100101";
    wait for 5 ns;
--    report "salucontrol vector value: " & to_string(sy);
    assert salucontrol = "001";
    sfunct <= "101010";
    wait for 5 ns;
--    report "salucontrol vector value: " & to_string(sy);
    assert salucontrol = "111";
  end process;
end architecture;
