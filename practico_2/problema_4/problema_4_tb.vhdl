library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity problema_4_tb is
end entity;

architecture test_bench of problema_4_tb is

  function to_string (sv: std_logic_vector) return string is
    use std.textio.all;
    variable bv : bit_vector (sv'range) := to_bitvector (sv);
    variable lp : line;
  begin
    write (lp, bv);
    return lp.all;
  end;

  component datapath

    port(MemToReg, MemWrite, Branch, AluSrc, reset : in std_logic;
         RegDst, RegWrite, Jump, dump, clk : in std_logic;
         AluControl : in std_logic_vector(2 downto 0);
         pc, instr : out std_logic_vector(31 downto 0));

  end component;

  signal sMemToReg, sMemWrite, sBranch, sAluSrc, sreset : std_logic;
  signal sRegDst, sRegWrite, sJump, sdump, sclk : std_logic;
  signal sAluControl : std_logic_vector(2 downto 0);
  signal spc, sinstr : std_logic_vector(31 downto 0);

begin
  tb_component : datapath port map (MemToReg => sMemToReg, MemWrite => sMemWrite,
                                    Branch => sBranch, AluSrc => sAluSrc, reset => sreset,
                                    RegDst => sRegDst, RegWrite => sRegWrite, Jump => sJump,
                                    dump => sdump, clk => sclk, AluControl => sAluControl,
                                    pc => spc, instr => sinstr);

  process
  begin
    wait for 5 ns;
  end process;
end architecture;
