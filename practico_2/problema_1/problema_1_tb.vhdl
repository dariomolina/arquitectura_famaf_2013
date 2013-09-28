library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity problema_1_tb is
  generic (width : positive := 32);
end entity;

architecture test_bench of problema_1_tb is
  function to_string (sv: std_logic_vector) return string is
    use std.textio.all;
    variable bv : bit_vector (sv'range) := to_bitvector (sv);
    variable lp : line;
  begin
    write (lp, bv);
    return lp.all;
  end;
  component regfile
    port(ra1, ra2, wa3: in std_logic_vector(4 downto 0);
         wd3: in std_logic_vector(31 downto 0);
         we3, clk: in std_logic;
         rd1, rd2: out std_logic_vector(31 downto 0));
  end component;
  signal sra1, sra2, swa3 : std_logic_vector(4 downto 0);
  signal swe3, sclk : std_logic;
  signal swd3, srd1, srd2 : std_logic_vector(31 downto 0);
begin
  tb_component : regfile port map (ra1 => sra1, ra2 => sra2, wa3 => swa3, wd3 => swd3, we3 => swe3, clk => sclk, rd1 => srd1, rd2 => srd2);
  process
  begin
    sclk <= '1';
    wait for 1 ns;
    sclk <= '0';
    wait for 1 ns;
  end process;
  process
  begin
    report "test: it should read 0 from the $zero register: Ok";
    sra1 <= (others => '0');
    sra2 <= (others => '0');
    wait for 5 ns;
--    report "srd1 vector value: " & to_string(srd1);
    assert srd1 = "00000000000000000000000000000000";
--    report "srd2 vector value: " & to_string(srd2);
    assert srd2 = "00000000000000000000000000000000";
    report "test: it should write registers when allowed to: Ok";
    swe3 <= '1';
    swd3 <= "10000101000010100100100000101110";
    swa3 <= "10010";
    wait for 5 ns;
    swd3 <= "00000010000011110100100101000011";
    swa3 <= "11110";
    wait for 5 ns;
    swe3 <= '0';
    wait for 5 ns;
    sra1 <= "11110";
    sra2 <= "10010";
    wait for 5 ns;
--    report "srd1 vector value: " & to_string(srd1);
    assert srd1 = "00000010000011110100100101000011";
--    report "srd2 vector value: " & to_string(srd2);
    assert srd2 = "10000101000010100100100000101110";
    report "test: it shouldn't write registers when not allowed to: Ok";
    swa3 <= "10010";
    swd3 <= "11111111111111111111111111111111";
    wait for 5 ns;
    sra1 <= "10010";
    wait for 5 ns;
--    report "srd1 vector value: " & to_string(srd1);
    assert srd1 = "10000101000010100100100000101110";
    report "test: it shouldn't be able to write on the $zero register: Ok";
    swe3 <= '1';
    swa3 <= "00000";
    swd3 <= "11111111111111111111111111111111";
    wait for 5 ns;
    swe3 <= '0';
    sra1 <= "00000";
    wait for 5 ns;
--    report "srd1 vector value: " & to_string(srd1);
    assert srd1 = "00000000000000000000000000000000";
    report "100%: PASS!!";
    wait for 1 ns;
  end process;
end architecture;
