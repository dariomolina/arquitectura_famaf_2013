library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity fetch is

  port (Jump, PcSrcM, clk, reset : in std_logic;
        PcBranchM : in std_logic_vector(31 downto 0);
        InstrF, PCF, PcPlus4F : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of fetch is

  signal TmpAdder : std_logic_vector(32 downto 0);
  signal PCPlus4, PCNext, PC0, PC1, PCJump, Instr : std_logic_vector(31 downto 0);

begin

  PCF      <= PC1;
  InstrF   <= Instr;
  PcPlus4F <= PCPlus4;
  PCPlus4  <= TmpAdder(31 downto 0);
  PCJump   <= PCPlus4(31 downto 28) & Instr(25 downto 0) & "00";

  PCMux   : mux2  port map (s => PCSrcM, d0 => PCPlus4,
                            d1 => PCBranchM, y => PCNext);

  JumpMux : mux2  port map (s => Jump, d0 => PCNext,
                            d1 => PCJump, y => PC0);

  PCFF    : flopr port map (reset => reset, clk => clk,
                            d => PC0, q => PC1);

  IMemory : imem  port map (a => PC1(7 downto 2), rd => Instr);

  PCAdder : adder port map (a => PC1, b => (2 => '1', others => '0'), y => TmpAdder);

end architecture;
