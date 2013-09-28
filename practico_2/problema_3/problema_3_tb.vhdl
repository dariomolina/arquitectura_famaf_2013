library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity problema_3_tb is
  generic (width : positive := 32);
end entity;

architecture test_bench of problema_3_tb is
  function to_string (sv: std_logic_vector) return string is
    use std.textio.all;
    variable bv : bit_vector (sv'range) := to_bitvector (sv);
    variable lp : line;
  begin
    write (lp, bv);
    return lp.all;
  end;
  component controller
    port (Op, Funct            : in std_logic_vector(5 downto 0);
          MemToReg, MemWrite   : out std_logic;
          Branch, AluSrc, Jump : out std_logic;
          RegDst, RegWrite     : out std_logic;
          AluControl           : out std_logic_vector (2 downto 0));
  end component;

  signal sOp, sFunct : std_logic_vector(5 downto 0);
  signal sAluControl : std_logic_vector(2 downto 0);

begin
  tb_component : controller port map (Op => sOp, Funct => sFunct, AluControl => sAluControl);
  process
  begin
    sOp <= "000000";
    sFunct <= "100010";
    wait for 5 ns;
    assert sAluControl = "110";

    sOp <= "101011";
    sFunct <= "100100";
    wait for 5 ns;
    assert sAluControl = "010";

    sOp <= "000100";
    sFunct <= "101010";
    wait for 5 ns;
    assert sAluControl = "110";
  end process;
end architecture;
