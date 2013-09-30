library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips_tb is
end entity;

architecture test_bench of mips_tb is

  function to_string (sv: std_logic_vector) return string is
    use std.textio.all;
    variable bv : bit_vector (sv'range) := to_bitvector (sv);
    variable lp : line;
  begin
    write (lp, bv);
    return lp.all;
  end;

  component mips

    port (reset, clk, dump : in std_logic;
          pc, instr : out std_logic_vector(31 downto 0));

  end component;

  signal sreset, sclk, sdump : std_logic;
  signal spc, sinstr : std_logic_vector(31 downto 0);

begin

  tb_component : mips port map (reset => sreset, clk => sclk, dump => sdump,
                                pc => spc, instr => sinstr);

  process
  begin
    sclk <= '1';
    wait for 1 ns;
    sclk <= '0';
    wait for 1 ns;
  end process;

  process
  begin
    sreset <= '1';
    wait for 3 ns;
    -- PC = 0x00000000
    assert spc = "00000000000000000000000000000000";
    -- Instruction = 0x20080000
    assert sinstr = "00100000000010000000000000000000";
    sreset <= '0';
    wait for 2 ns;
    -- PC = 0x00000004
    assert spc = "00000000000000000000000000000100";
    -- Instruction = 0x20090001
    assert sinstr = "00100000000010010000000000000001";
    wait for 2 ns;
    -- PC = 0x00000008
    assert spc = "00000000000000000000000000001000";
    -- Instruction = 0x200a0002
    assert sinstr = "00100000000010100000000000000010";
    wait for 2 ns;
    -- PC = 0x0000000C
    assert spc = "00000000000000000000000000001100";
    -- Instruction = 0x200b0003
    assert sinstr = "00100000000010110000000000000011";
    wait for 2 ns;
    -- PC = 0x00000010
    assert spc = "00000000000000000000000000010000";
    -- Instruction = 0x200c0004
    assert sinstr = "00100000000011000000000000000100";
    wait for 2 ns;
    -- PC = 0x00000014
    assert spc = "00000000000000000000000000010100";
    -- Instruction = 0x200d0005
    assert sinstr = "00100000000011010000000000000101";
    wait for 2 ns;
    -- PC = 0x00000018
    assert spc = "00000000000000000000000000011000";
    -- Instruction = 0x200e0006
    assert sinstr = "00100000000011100000000000000110";
    wait for 2 ns;
    -- PC = 0x0000001C
    assert spc = "00000000000000000000000000011100";
    -- Instruction = 0x200f0007
    assert sinstr = "00100000000011110000000000000111";
    wait for 2 ns;
    -- PC = 0x00000020
    assert spc = "00000000000000000000000000100000";
    -- Instruction = 0xac080000
    assert sinstr = "10101100000010000000000000000000";
    wait for 2 ns;
    -- PC = 0x00000024
    assert spc = "00000000000000000000000000100100";
    -- Instruction = 0xac090004
    assert sinstr = "10101100000010010000000000000100";
    wait for 2 ns;
    -- PC = 0x00000028
    assert spc = "00000000000000000000000000101000";
    -- Instruction = 0xac0a0008
    assert sinstr = "10101100000010100000000000001000";
    wait for 2 ns;
    -- PC = 0x0000002C
    assert spc = "00000000000000000000000000101100";
    -- Instruction = 0xac0b000c
    assert sinstr = "10101100000010110000000000001100";
    wait for 2 ns;
    -- PC = 0x00000030
    assert spc = "00000000000000000000000000110000";
    -- Instruction = 0xac0c0010
    assert sinstr = "10101100000011000000000000010000";
    wait for 2 ns;
    -- PC = 0x00000034
    assert spc = "00000000000000000000000000110100";
    -- Instruction = 0xac0d0014
    assert sinstr = "10101100000011010000000000010100";
    wait for 2 ns;
    -- PC = 0x00000038
    assert spc = "00000000000000000000000000111000";
    -- Instruction = 0xac0e0018
    assert sinstr = "10101100000011100000000000011000";
    wait for 2 ns;
    -- PC = 0x0000003C
    assert spc = "00000000000000000000000000111100";
    -- Instruction = 0xac0f001c
    assert sinstr = "10101100000011110000000000011100";
    sdump <= '1';
    wait for 5 ns;
    sreset <= '1';
    wait for 3 ns;
    -- PC = 0x00000000
    assert spc = "00000000000000000000000000000000";
    -- Instruction = 0x20080000
    assert sinstr = "00100000000010000000000000000000";
  end process;

end architecture;
