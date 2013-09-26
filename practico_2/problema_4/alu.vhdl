library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port (alucontrol : in std_logic_vector(2 downto 0);
        a, b : in std_logic_vector(31 downto 0);
        zero : out std_logic;
        result : out std_logic_vector(31 downto 0));
end entity;

architecture behaviour of alu is
  function or_reduce(arg: std_logic_vector) return std_logic is
    variable result: std_logic;
  begin
    result := '0';
    for i in arg'range loop
      result := result or arg(i);
    end loop;
    return result;
  end;
begin
  process (alucontrol, a, b)
    variable res : std_logic_vector(31 downto 0);
  begin
    case alucontrol is
      when "000" => res := a and b;
      when "001" => res := a or b;
      when "010" => res := std_logic_vector(unsigned(a) + unsigned(b));
      when "100" => res := a and (not b);
      when "101" => res := a or (not b);
      when "110" => res := std_logic_vector(unsigned(a) - unsigned(b));
      when "111" => res := (others => '0');
                    if (unsigned(a) < unsigned(b)) then
                      res(0) := '1';
                    end if;
      when others => res := (others => 'X');
    end case;
    if (or_reduce(res) = '0') then
      zero <= '1';
    else
      zero <= '0';
    end if;
    result <= res;
  end process;
end architecture;
