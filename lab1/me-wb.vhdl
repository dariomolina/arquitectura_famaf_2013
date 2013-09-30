library ieee;
library work;
use work.components.all;
use ieee.std_logic_1164.all;

entity me_wb is

  port(reset, clk : in std_logic;
       WriteRegM : in std_logic_vector(4 downto 0);
       WriteRegW : out std_logic_vector(4 downto 0);
       AluOutM, ReadDataM : in std_logic_vector(31 downto 0);
       AluOutW, ReadDataW : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of me_wb is
  WriteReg_FF : flopr port map (reset => reset, clk => clk, d => WriteRegM, q => WriteRegW);
  AluOut_FF  : flopr port map (reset => reset, clk => clk, d => AluOutM, q => AluOutW);
  ReadData_FF : flopr port map (reset => reset, clk => clk, d => ReadDataM, q => ReadDataW);
end architecture;
