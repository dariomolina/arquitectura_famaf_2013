library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity execute is

  port (ZeroE : out std_logic;
        RegDst, AluSrc : in std_logic;
        RtE, RdE : in std_logic_vector(4 downto 0);
        AluControl : in std_logic_vector(2 downto 0);
        WriteRegE : out std_logic_vector(4 downto 0);
        RD1E, RD2E, PCPlus4E, SignlmmE : in std_logic_vector(31 downto 0);
        AluOutE, WriteDataE, PCBranchE : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of execute is

  signal AddResult : std_logic_vector(32 downto 0);
  signal AdderAux, SrcBE : std_logic_vector(31 downto 0);

begin

  WriteDataE <= RD2E;
  PCBranchE  <= AddResult(31 downto 0);

  RegMux  : mux2  generic map (width => 5) port map (s => RegDst, d0 => RtE,
                                                     d1 => RdE, y => WriteRegE);

  AluMux  : mux2  port map (s => AluSrc, d0 => RD2E,
                            d1 => SignlmmE, y => SrcBE);

  Shift2  : sl2   port map (a => SignlmmE, y => AdderAux);

  MipsAlu : alu   port map (alucontrol => AluControl, a => RD1E, b => SrcBE,
                            zero => ZeroE, result => AluOutE);

  PcAdder : adder port map (a => AdderAux, b => PCPlus4E, y => AddResult);

end architecture;
