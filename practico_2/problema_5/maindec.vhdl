library ieee;
use ieee.std_logic_1164.all;

entity maindec is
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
end entity;

architecture ar_maindec of maindec is
    begin
        process (Op)
        begin
            if (Op = "000000") then
                RegWrite <= '1';
                RegDst   <= '1';
                AluSrc   <= '0';
                Branch   <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                Jump     <= '0';
                AluOp    <= "10";
            elsif (Op = "100011") then
                RegWrite <= '1';
                RegDst   <= '0';
                AluSrc   <= '1';
                Branch   <= '0';
                MemWrite <= '0';
                MemToReg <= '1';
                Jump     <= '0';
                AluOp    <= "00";
            elsif (Op = "101011") then
                RegWrite <= '0';
                RegDst   <= '0';
                AluSrc   <= '1';
                Branch   <= '0';
                MemWrite <= '1';
                MemToReg <= '0';
                Jump     <= '0';
                AluOp    <= "00";
            elsif (Op = "000100") then
                RegWrite <= '0';
                RegDst   <= '0';
                AluSrc   <= '0';
                Branch   <= '1';
                MemWrite <= '0';
                MemToReg <= '0';
                Jump     <= '0';
                AluOp    <= "10";
            elsif (Op = "001000") then
                RegWrite <= '1';
                RegDst   <= '0';
                AluSrc   <= '1';
                Branch   <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                Jump     <= '0';
                AluOp    <= "00";
            elsif (Op = "000010") then
                RegWrite <= '0';
                RegDst   <= '0';
                AluSrc   <= '0';
                Branch   <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                Jump     <= '1';
                AluOp    <= "00";
            else
                RegWrite <= '0';
                RegDst   <= '0';
                AluSrc   <= '0';
                Branch   <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                Jump     <= '0';
                AluOp    <= "00";
            end if;
        end process;
end architecture;
