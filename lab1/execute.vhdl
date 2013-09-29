library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity execute is

  port (RtE, RdE : in  std_logic_vector(4 downto 0);
        RD1E, RD2E, PCPlus4E, SignlmmE : in std_logic_vector(31 downto 0);
        RegDst, AluSrc : in std_logic;
        AluControl : in std_logic_vector(2 downto 0);
        WriteRegE : out std_logic_vector(4 downto 0);
        ZeroE : out std_logic;
        AluOutE, WriteDataE, PCBranchE : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of execute is

  signal Sl2Adder, SrcB : std_logic_vector(31 downto 0);

begin

  WriteDataE <= RD2E;

  muxReg : mux2 generic map (width => 5) port map (s => RegDst, d0 => RtE,
                                                   d1 => RdE, y => WriteRegE);

  muxALU : mux2 port map (s => AluSrc, d0 => RD2E,
                          d1 => SignlmmE, y => SrcB);

  sl2PCBranch : sl2 port map (a => SignlmmE, y => Sl2Adder);

  ALUMIPS : alu port map (alucontrol => AluControl, a => RD1E, b => SrcB,
                          zero => ZeroE, result => AluOutE);

  addPcBranch : adder port map (a => Sl2Adder, b => PCPlus4E, y => PCBranchE);

end architecture;
