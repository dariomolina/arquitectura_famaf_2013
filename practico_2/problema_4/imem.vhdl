library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all;

entity imem is -- instruction memory
  port(a:  in  STD_LOGIC_VECTOR(5 downto 0);
       rd: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of imem is

  constant MAX_BOUND: Integer := 64;
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

begin
  process is
    file mem_file: TEXT;
    variable L: line;
    variable ch: character;
    variable index: integer;
    variable result: integer;
    type ramtype is array (MAX_BOUND-1 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    variable mem: ramtype;
  begin
    -- initialize memory from file
    for i in 0 to MAX_BOUND-1 loop -- set all contents low
      mem(i) := std_logic_vector(to_unsigned(0, 32));
    end loop;
    index := 0;
    FILE_OPEN(mem_file, MIPS_SOFT_FILE, READ_MODE);
    while not endfile(mem_file) loop
      readline(mem_file, L);
      result := 0;
      for i in 1 to 8 loop
        read(L, ch);
        if '0' <= ch and ch <= '9' then
          result := result*16 + character'pos(ch) - character'pos('0');
        elsif 'a' <= ch and ch <= 'f' then
          result := result*16 + character'pos(ch) - character'pos('a'); -- + 10;
        else
          report "Format error on line " & integer'image(index)
          severity error;
        end if;
      end loop;
      mem(index) := std_logic_vector(to_unsigned(result, 32));
      index := index + 1;
    end loop;

    -- read memory
    loop
      if (valid_address(a) = '1') then
        rd <= mem(to_integer(unsigned(a)));
      end if;
      wait on a;
    end loop;
  end process;
end;
