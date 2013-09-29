library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity execute is

  port (RtE, RdE : in  std_logic_vector(4 downto 0);
        RD1E, RD2E, PCPlus4E, SignImmE : in std_logic_vector(31 downto 0);
        RegDst, AluSrc, AluControl : in std_logic;
        WriteRegE : out std_logic_vector(4 downto 0);
        ZeroE : out std_logic;
        AluOutE, WriteDataE, PCBranchE : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of execute is

  signal WriteData, PCBranch, Sl2Adder, SrcB : std_logic_vector(31 downto 0);
  signal WriteReg : std_logic_vector(4 downto 0);

begin

  PCBranchE  <= PCBranch;
  WriteDataE <= WriteData;
  WriteRegE  <= WriteReg(4 downto 0);

  muxReg : mux2 generic map (width => 5) port map (s => RegDst, d0 => RtE,
                                                   d1 => RdE, y => WriteReg);

  muxALU : mux2 port map (s => AluSrc, d0 => RD2E,
                          d1 => Signlmm, y => SrcB);

  sl2PCBranch : sl2 port map (a => SignlmmE, y => Sl2Adder);

  ALUMIPS : alu port map (alucontrol => AluControl, a => RD1E, b => SrcB,
                          zero => ZeroE, result => ALUResult);

  adder2 : adder port map (a => Sl2Adder, b => PCPlus4E, y => PCBranch);

end architecture;
