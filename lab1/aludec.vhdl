library ieee;
use ieee.std_logic_1164.all;

entity aludec is

  port (funct : in std_logic_vector(5 downto 0);
        aluop : in std_logic_vector(1 downto 0);
        alucontrol : out std_logic_vector(2 downto 0));

end entity;

architecture behaviour of aludec is
begin

  process (funct, aluop)
  begin

    if aluop = "00" then
      alucontrol <= "010";
    elsif aluop = "01" then
      alucontrol <= "110";
    else
      case funct is
        when "100000" => alucontrol <= "010";
        when "100010" => alucontrol <= "110";
        when "100100" => alucontrol <= "000";
        when "100101" => alucontrol <= "001";
        when "101010" => alucontrol <= "111";
        when others => alucontrol <= "XXX";
      end case;
    end if;

  end process;

end architecture;
