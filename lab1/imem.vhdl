library ieee;
use std.textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity imem is

  port(a:  in  std_logic_vector(5 downto 0);
       rd: out std_logic_vector(31 downto 0));

end;

architecture behave of imem is

  constant MAX_BOUND: integer := 64;
  constant MIPS_SOFT_FILE: string := "mips_pipeline.dat";

  function valid_address(arg: std_logic_vector) return std_logic is
    variable result: std_logic;
  begin
    result := '0';
    for i in arg'range loop
      result := result or arg(i) or (not arg(i));
    end loop;
    return result;
  end;

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

begin

  process is

    file mem_file: TEXT;
    variable L: line;
    variable ch: character;
    variable index: integer;
    variable result: unsigned(31 downto 0);
    type ramtype is array (MAX_BOUND - 1 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    variable mem: ramtype;

  begin

    for i in 0 to MAX_BOUND - 1 loop
      mem(i) := std_logic_vector(to_unsigned(0, 32));
    end loop;

    index := 0;
    FILE_OPEN(mem_file, MIPS_SOFT_FILE, READ_MODE);
    -- report "--- Instruction Memory ---";

    while not endfile(mem_file) loop
      readline(mem_file, L);
      result := to_unsigned(0, 32);
      for i in 1 to 8 loop
        read(L, ch);
        if '0' <= ch and ch <= '9' then
          result := shift_left(result, 4) + to_unsigned(character'pos(ch) - character'pos('0'), 32);
        elsif 'a' <= ch and ch <= 'f' then
          result := shift_left(result, 4) + to_unsigned(character'pos(ch) - character'pos('a') + 10, 32);
        else
          report "Format error on line " & integer'image(index)
            severity error;
        end if;
      end loop;
      mem(index) := std_logic_vector(result);
      -- report to_hex_string(mem(index));
      -- report to_string(mem(index));
      index := index + 1;
    end loop;

    -- report "--- Instruction Memory ---";

    loop
      if (valid_address(a) = '1') then
        rd <= mem(to_integer(unsigned(a)));
      end if;
      wait on a;
    end loop;

  end process;

end;
