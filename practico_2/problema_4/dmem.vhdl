library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all;

entity dmem is -- data memory
  port(clk, we:  in STD_LOGIC;
       a, wd:    in STD_LOGIC_VECTOR(31 downto 0);
       rd:       out STD_LOGIC_VECTOR(31 downto 0);
       dump: in STD_LOGIC);
end;

architecture behave of dmem is
  constant MEMORY_DUMP_FILE: string := "output.dump";
  constant MAX_BOUND: Integer := 64;

  type ramtype is array (MAX_BOUND-1 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
  signal mem: ramtype;

  function to_string (sv: std_logic_vector) return string is
    use std.textio.all;
    variable bv : bit_vector (sv'range) := to_bitvector (sv);
    variable lp : line;
  begin
    write (lp, bv);
    return lp.all;
  end;

  function to_hex_string (s: std_logic_vector) return string is
    constant s_norm: std_logic_vector(4 to s'length + 3) := s;
    variable result : string (1 to s'length/4);
    subtype slv4 is std_logic_vector(1 to 4);
  begin
    assert (s'length mod 4) = 0;
    for i in result'range loop
      case slv4'(s_norm(i * 4 to i * 4 + 3)) is
        when "0000" => result(i) := '0';
        when "0001" => result(i) := '1';
        when "0010" => result(i) := '2';
        when "0011" => result(i) := '3';
        when "0100" => result(i) := '4';
        when "0101" => result(i) := '5';
        when "0110" => result(i) := '6';
        when "0111" => result(i) := '7';
        when "1000" => result(i) := '8';
        when "1001" => result(i) := '9';
        when "1010" => result(i) := 'a';
        when "1011" => result(i) := 'b';
        when "1100" => result(i) := 'c';
        when "1101" => result(i) := 'd';
        when "1110" => result(i) := 'e';
        when "1111" => result(i) := 'f';
        when others => result(i) := 'x';
      end case;
    end loop;
    return result;
  end;

  procedure memDump is
    file dumpfile : text open write_mode is MEMORY_DUMP_FILE;
    variable dumpline : line;
    variable i: natural := 0;
  begin
    write(dumpline, string'("Memoria RAM de Mips:"));
    writeline(dumpfile,dumpline);
    write(dumpline, string'("Address Data"));
    writeline(dumpfile,dumpline);
    while i <= MAX_BOUND-1 loop
      write(dumpline, i);
      write(dumpline, string'(" "));
      write(dumpline, to_hex_string(mem(i)));
      writeline(dumpfile,dumpline);
      i:=i+1;
    end loop;
  end procedure memDump;

  function valid_address(arg: std_logic_vector) return std_logic is
    variable result: std_logic;
  begin
    result := '0';
    for i in arg'range loop
      result := result or arg(i) or (not arg(i));
    end loop;
    return result;
  end;

begin

  process (clk, a, mem)
  begin
    if (valid_address(a) = '1') then
      if clk'event and clk = '1' and we = '1' then
        mem(to_integer(unsigned(a(7 downto 2)))) <= wd;
      end if;
      rd <= mem(to_integer(unsigned(a(7 downto 2)))); -- word aligned
    end if;
  end process;

  process (dump)
  begin
    if dump = '1' then
      memDump;
    end if;
  end process;

end;
