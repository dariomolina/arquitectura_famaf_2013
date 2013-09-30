library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity regfile is

  port(we3, clk: in std_logic;
       wd3: in std_logic_vector(31 downto 0);
       rd1, rd2: out std_logic_vector(31 downto 0);
       ra1, ra2, wa3: in std_logic_vector(4 downto 0));

end regfile;

architecture behavior of regfile is

  function to_string (sv: std_logic_vector) return string is
    use std.textio.all;
    variable bv : bit_vector (sv'range) := to_bitvector (sv);
    variable lp : line;
  begin
    write (lp, bv);
    return lp.all;
  end;

  function valid_address(arg: std_logic_vector) return std_logic is
    variable result: std_logic;
  begin
    result := '0';
    for i in arg'range loop
      result := result or arg(i) or (not arg(i));
    end loop;
    return result;
  end;

  type reg_memory is array (0 to 31) of std_logic_vector(31 downto 0);
  signal memory : reg_memory;

begin

  process (clk, ra1, ra2)
  begin

    if (valid_address(wd3) = '1') then
      if (clk'event and clk = '1' and we3 = '1') then
        if (wa3 /= "00000000000000000000000000000000") then
          memory(to_integer(unsigned(wa3))) <= wd3;
        end if;
      end if;
    end if;

    if (valid_address(ra1) = '1') then
      if (to_integer(unsigned(ra1)) = 0) then
        rd1 <= (others => '0');
      else
        rd1 <= memory(to_integer(unsigned(ra1)));
      end if;
    end if;

    if (valid_address(ra2) = '1') then
      if (to_integer(unsigned(ra2)) = 0) then
        rd2 <= (others => '0');
      else
        rd2 <= memory(to_integer(unsigned(ra2)));
      end if;
    end if;

  end process;

end architecture;
