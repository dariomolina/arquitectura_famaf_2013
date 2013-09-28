library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all;

entity dmem is -- data memory
  port(clk, we:  in STD_LOGIC;
       a, wd:    in STD_LOGIC_VECTOR(31 downto 0);
       rd:       out STD_LOGIC_VECTOR(31 downto 0);
       dump: in STD_LOGIC
       );
end;

architecture behave of dmem is
  constant MEMORY_DUMP_FILE: string := "output.dump";
  constant MAX_BOUND: Integer := 64;

  type ramtype is array (MAX_BOUND-1 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
  signal mem: ramtype;

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
      write(dumpline, to_integer(unsigned(mem(i))));
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
  process(clk, a, mem)
  begin
    if (valid_address(a) = '1') then
      if clk'event and clk = '1' and we = '1' then
        mem(to_integer(unsigned(a(7 downto 2)))) <= wd;
      end if;
      rd <= mem(to_integer(unsigned(a(7 downto 2)))); -- word aligned
    end if;
  end process;

  process(dump)
  begin
    if dump = '1' then
      memDump;
    end if;
  end process;
end;
