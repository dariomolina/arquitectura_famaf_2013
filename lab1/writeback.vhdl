library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity writeback is

  port (MemToReg : in std_logic;
        AluOutW, ReadDataW : in std_logic_vector(31 downto 0)
        ResultW : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of writeback is

  signal Result : std_logic_vector(31 downto 0);

begin

  ResultW <= Result;

  muxToReg : mux2 port map (s => MemToReg, d0 => AluOutW,
                            d1 => ReadDataW, y => Result);

end architecture;
