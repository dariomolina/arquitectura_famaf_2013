library ieee;
library work;
use work.components.all;
use ieee.std_logic_1164.all;

entity if_de is

  port(reset, clk : in std_logic;
       InstrF, PCPlus4F : in std_logic_vector(31 downto 0);
       InstrD, PCPlus4D : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of if_de is
begin

  Instr_FF  : flopr port map (reset => reset, clk => clk, d => InstrF, q => InstrD);
  PCPlus_FF : flopr port map (reset => reset, clk => clk, d => PCPlus4F, q => PCPlus4D);

end architecture;
