library ieee;
use ieee.std_logic_1164.all;

package components is
  component aludec is
    port (funct : in std_logic_vector(5 downto 0);
          aluop : in std_logic_vector(1 downto 0);
          alucontrol : out std_logic_vector(2 downto 0));
  end component;

  component maindec is
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
end package;
