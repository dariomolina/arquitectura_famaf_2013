library ieee;
use ieee.std_logic_1164.all;

entity maindec is
  port (Op       : in  std_logic_vector(5 downto 0);
        MemToReg : out std_logic;
        MemWrite : out std_logic;
        Branch   : out std_logic;
        AluSrc   : out std_logic;
        RegDst   : out std_logic;
        RegWrite : out std_logic;
        Jump     : out std_logic;
        AluOp    : out std_logic_vector(1 downto 0));
end entity;

architecture behavior of maindec is
begin
  process (Op)
    variable tmp : std_logic_vector(8 downto 0);
  begin
    case Op is
      when "000000" => tmp := "110000010";
      when "100011" => tmp := "101001000";
      when "101011" => tmp := "001010000";
      when "000100" => tmp := "000100001";
      when "001000" => tmp := "101000000";
      when "000010" => tmp := "000000100";
      when others   => tmp := "---------";
    end case;
    RegWrite <= tmp(8);
    RegDst   <= tmp(7);
    AluSrc   <= tmp(6);
    Branch   <= tmp(5);
    MemWrite <= tmp(4);
    MemToReg <= tmp(3);
    Jump     <= tmp(2);
    AluOp    <= tmp(1 downto 0);
  end process;
end architecture;
