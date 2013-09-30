library ieee;
library work;
use work.components.all;
use ieee.std_logic_1164.all;

entity ex_me is

  port(reset, clk : in std_logic;
       ZeroE : in std_logic;
       ZeroM : out std_logic;
       WriteRegE : in std_logic_vector(4 downto 0);
       WriteRegM : out std_logic_vector(4 downto 0);
       AluOutE, WriteDataE : in std_logic_vector(31 downto 0);
       AluOutM, WriteDataM : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of ex_me is

  Zero_FF  : flopr port map (reset => reset, clk => clk, d => ZeroE, q => ZeroM);
  WriteReg_FF : flopr port map (reset => reset, clk => clk, d => WriteRegE, q => WriteRegM);
  AluOut_FF  : flopr port map (reset => reset, clk => clk, d => AluOutE, q => AluOutM);
  WriteData_FF : flopr port map (reset => reset, clk => clk, d => WriteDataE, q => WriteDataM);

end architecture;
