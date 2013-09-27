library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity problema_8_tb is
end entity;

architecture test_bench of problema_8_tb is
  function to_string (sv: std_logic_vector) return string is
    use std.textio.all;
    variable bv : bit_vector (sv'range) := to_bitvector (sv);
    variable lp : line;
  begin
    write (lp, bv);
    return lp.all;
  end;
  component dmem
  port(a, wd: in std_logic_vector(31 downto 0);
       rd: out std_logic_vector(31 downto 0);
       clk, we: in std_logic);
  end component;
  signal sa, swd, srd : std_logic_vector(31 downto 0);
  signal sclk, swe : std_logic;
begin
  tb_component : dmem port map (a => sa, wd => swd, rd => srd, clk => sclk, we => swe);
  process
  begin
    sclk <= '1';
    wait for 1 ns;
    sclk <= '0';
    wait for 1 ns;
  end process;
  process
  begin
    wait for 1 ns;
  end process;
end architecture;
