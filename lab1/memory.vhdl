library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity memory is

  port (AluOutM, WriteDataM : in std_logic_vector(31 downto 0);
        MemWrite, Branch, ZeroM, clk, dump : in std_logic;
        PcSrcM : out std_logic;
        ReadDataM : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of memory is
begin

  --PCSrcM <= ALGO FALTA;

  memMIPS : dmem port map (a => AluOutM, wd => WriteDataM,
                           clk => clk, we => MemWrite, rd => ReadDataM, dump => dump);

end architecture;
