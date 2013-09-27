library ieee;
use ieee.std_logic_1164.all;

entity problema_6_tb is
end entity;

architecture test_bench of problema_6_tb is
  function to_string (sv: std_logic_vector) return string is
    use std.textio.all;
    variable bv : bit_vector (sv'range) := to_bitvector (sv);
    variable lp : line;
  begin
    write (lp, bv);
    return lp.all;
  end;
  component alu
  port (alucontrol : in std_logic_vector(2 downto 0);
        a, b : in std_logic_vector(31 downto 0);
        zero : out std_logic;
        result : out std_logic_vector(31 downto 0));
  end component;
  signal salucontrol : std_logic_vector(2 downto 0);
  signal sa, sb, sresult : std_logic_vector(31 downto 0);
  signal szero : std_logic;
begin
  tb_component : alu port map (alucontrol => salucontrol, a => sa, b => sb, zero => szero, result => sresult);
  process
  begin
    sa <= "10011101100100101101110110000001";
    sb <= "01100010110011101100000110111100";

    salucontrol <= "000";
    wait for 5 ns;
    assert szero = '0';
--    report "sresult vector value: " & to_string(sresult);
    assert sresult = "00000000100000101100000110000000";

    salucontrol <= "001";
    wait for 5 ns;
    assert szero = '0';
--    report "sresult vector value: " & to_string(sresult);
    assert sresult = "11111111110111101101110110111101";

    salucontrol <= "010";
    wait for 5 ns;
    assert szero = '0';
--    report "sresult vector value: " & to_string(sresult);
    assert sresult = "00000000011000011001111100111101";

    salucontrol <= "011";
    wait for 5 ns;
    assert szero = '0';
--    report "sresult vector value: " & to_string(sresult);
    assert sresult = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

    salucontrol <= "100";
    wait for 5 ns;
    assert szero = '0';
--    report "sresult vector value: " & to_string(sresult);
    assert sresult = "10011101000100000001110000000001";

    salucontrol <= "101";
    wait for 5 ns;
    assert szero = '0';
--    report "sresult vector value: " & to_string(sresult);
    assert sresult = "10011101101100111111111111000011";

    salucontrol <= "110";
    wait for 5 ns;
    assert szero = '0';
--    report "sresult vector value: " & to_string(sresult);
    assert sresult = "00111010110001000001101111000101";

    salucontrol <= "111";
    wait for 5 ns;
    assert szero = '1';
--    report "sresult vector value: " & to_string(sresult);
    assert sresult = "00000000000000000000000000000000";

    sa <= "00000000000000000000000000000000";
    sb <= "11111111111111111111111111111111";
    wait for 5 ns;
    assert szero = '0';
--    report "sresult vector value: " & to_string(sresult);
    assert sresult = "00000000000000000000000000000001";
  end process;
end architecture;
