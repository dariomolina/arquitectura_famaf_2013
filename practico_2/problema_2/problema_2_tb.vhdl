library ieee;
use ieee.std_logic_1164.all;

entity problema_2_tb is
end entity;

architecture ar_maindec_tb of problema_2_tb is
  component maindec
    port (Op       : in  std_logic_vector(5 downto 0);
          MemToReg : out std_logic;
          MemWrite : out std_logic;
          Branch   : out std_logic;
          AluSrc   : out std_logic;
          RegDst   : out std_logic;
          RegWrite : out std_logic;
          Jump     : out std_logic;
          Aluop    : out std_logic_vector(1 downto 0));
  end component;

  signal sOp : std_logic_vector(5 downto 0);
  signal sMemToReg, sMemWrite, sBranch, sAluSrc, sRegDst, sRegWrite, sJump : std_logic;
  signal sAluOp : std_logic_vector(1 downto 0);

begin
  tb_componente : maindec port map (Op => sOp, MemToReg => sMemToReg, MemWrite => sMemWrite,
                                    Branch => sBranch, AluSrc => sAluSrc, RegDst => sRegDst,
                                    RegWrite => sRegWrite, Jump => sJump, Aluop => sAluop);
  process
  begin
    sOp <= "000000";
    wait for 5 ns;
    assert sRegWrite = '1';
    assert sRegDst   = '1';
    assert sAluSrc   = '0';
    assert sBranch   = '0';
    assert sMemWrite = '0';
    assert sMemToReg = '0';
    assert sJump     = '0';
    assert sAluOp    = "10";

    sOp <= "100011";
    wait for 5 ns;
    assert sRegWrite = '1';
    assert sRegDst   = '0';
    assert sAluSrc   = '1';
    assert sBranch   = '0';
    assert sMemWrite = '0';
    assert sMemToReg = '1';
    assert sJump     = '0';
    assert sAluOp    = "00";

    sOp <= "101011";
    wait for 5 ns;
    assert sRegWrite = '0';
    assert sRegDst   = '0';
    assert sAluSrc   = '1';
    assert sBranch   = '0';
    assert sMemWrite = '1';
    assert sMemToReg = '0';
    assert sJump     = '0';
    assert sAluOp    = "00";

    sOp <= "000100";
    wait for 5 ns;
    assert sRegWrite = '0';
    assert sRegDst   = '0';
    assert sAluSrc   = '0';
    assert sBranch   = '1';
    assert sMemWrite = '0';
    assert sMemToReg = '0';
    assert sJump     = '0';
    assert sAluOp    = "01";

    sOp <= "001000";
    wait for 5 ns;
    assert sRegWrite = '1';
    assert sRegDst   = '0';
    assert sAluSrc   = '1';
    assert sBranch   = '0';
    assert sMemWrite = '0';
    assert sMemToReg = '0';
    assert sJump     = '0';
    assert sAluOp    = "00";

    sOp <= "000010";
    wait for 5 ns;
    assert sRegWrite = '0';
    assert sRegDst   = '0';
    assert sAluSrc   = '0';
    assert sBranch   = '0';
    assert sMemWrite = '0';
    assert sMemToReg = '0';
    assert sJump     = '1';
    assert sAluOp    = "00";

    sOp <= "111111";
    wait for 5 ns;
    assert sRegWrite = '-';
    assert sRegDst   = '-';
    assert sAluSrc   = '-';
    assert sBranch   = '-';
    assert sMemWrite = '-';
    assert sMemToReg = '-';
    assert sJump     = '-';
    assert sAluOp    = "--";
  end process;
end architecture;
