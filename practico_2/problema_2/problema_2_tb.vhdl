library ieee;
use ieee.std_logic_1164.all;

entity problema_2_tb is
end entity;

architecture ar_maindec_tb of problema_2_tb is
    component maindec
    port (
          Op         : in  std_logic_vector(5 downto 0);
          MemToReg   : out std_logic;
          MemWrite   : out std_logic;
          Branch     : out std_logic;
          AluSrc     : out std_logic;
          RegDst     : out std_logic;
          RegWrite   : out std_logic;
          Jump       : out std_logic;
          Aluop      : out std_logic_vector(1 downto 0));
      end component;

    signal Op : std_logic_vector(5 downto 0);
    signal MemToReg, MemWrite, Branch, AluSrc, RegDst, RegWrite, Jump : std_logic;
    signal AluOp : std_logic_vector(1 downto 0);

    begin
        mapeo : maindec port map (Op => Op, MemToReg => MemToReg, MemWrite => MemWrite,
                                    Branch => Branch, AluSrc => AluSrc, RegDst => RegDst,
                                    RegWrite => RegWrite, Jump => Jump, Aluop => Aluop);
        process
            begin
                wait for 5 ns;
                Op <= "000000";
                wait for 5 ns;
                assert RegWrite = '1';
                assert RegDst   = '1';
                assert AluSrc   = '0';
                assert Branch   = '0';
                assert MemWrite = '0';
                assert MemToReg = '0';
                assert Jump     = '0';
                assert AluOp    = "10";

                wait for 5 ns;
                Op <= "100011";
                wait for 5 ns;
                assert RegWrite = '1';
                assert RegDst   = '0';
                assert AluSrc   = '1';
                assert Branch   = '0';
                assert MemWrite = '0';
                assert MemToReg = '1';
                assert Jump     = '0';
                assert AluOp    = "00";

                wait for 5 ns;
                Op <= "101011";
                wait for 5 ns;
                assert RegWrite = '0';
                assert RegDst   = '0';
                assert AluSrc   = '1';
                assert Branch   = '0';
                assert MemWrite = '1';
                assert MemToReg = '0';
                assert Jump     = '0';
                assert AluOp    = "00";

                wait for 5 ns;
                Op <= "000100";
                wait for 5 ns;
                assert RegWrite = '0';
                assert RegDst   = '0';
                assert AluSrc   = '0';
                assert Branch   = '1';
                assert MemWrite = '0';
                assert MemToReg = '0';
                assert Jump     = '0';
                assert AluOp    = "10";

                wait for 5 ns;
                Op <= "001000";
                wait for 5 ns;
                assert RegWrite = '1';
                assert RegDst   = '0';
                assert AluSrc   = '1';
                assert Branch   = '0';
                assert MemWrite = '0';
                assert MemToReg = '0';
                assert Jump     = '0';
                assert AluOp    = "00";

                wait for 5 ns;
                Op <= "000010";
                wait for 5 ns;
                assert RegWrite = '0';
                assert RegDst   = '0';
                assert AluSrc   = '0';
                assert Branch   = '0';
                assert MemWrite = '0';
                assert MemToReg = '0';
                assert Jump     = '1';
                assert AluOp    = "00";

                wait for 5 ns;
                Op <= "111111";
                wait for 5 ns;
                assert RegWrite = '0';
                assert RegDst   = '0';
                assert AluSrc   = '0';
                assert Branch   = '0';
                assert MemWrite = '0';
                assert MemToReg = '0';
                assert Jump     = '0';
                assert AluOp    = "00";

        end process;
end architecture;
