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
  signal PCPlus4, PCNext, PC0, PC1, Instruction : std_logic_vector(31 downto 0);

begin

  InstrF   <= Instruction;
  PCF      <= PC1;
  PCPlus4  <= TmpAdder(31 downto 0);
  PcPlus4F <= PCPlus4;

  muxPC : mux2 port map (s => PCSrcM, d0 => PCPlus4,
                          d1 => PCBranchM, y => PCNext);

  muxJump : mux2 port map (s => Jump, d0 => PCNext,
                            d1 => PCJump, y =>PC0);

  flopPC : flopr port map (reset => reset, clk => clk,
                            d => PC0, q => PC1);

  instruction_memory : imem port map (a => PC1(7 downto 2), d => Instruction);

  addPC : adder port map (a => PC1, b => (2 => '1', others => '0'), y => TmpAdder);

end architexture;
