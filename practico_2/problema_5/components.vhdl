library ieee;
use ieee.std_logic_1164.all;

package components is

  component datapath is
  port(MemToReg, MemWrite, Branch, AluSrc, reset : in std_logic;
       RegDst, RegWrite, Jump, dump, clk : in std_logic;
       AluControl : in std_logic_vector(2 downto 0);
       pc, instr : out std_logic_vector(31 downto 0));
  end component;

  component controller is
  port(MemToReg, MemWrite, Branch : out std_logic;
       AluSrc, RegDst, RegWrite, Jump : out std_logic;
       Op : in std_logic_vector(5 downto 0);
       Funct : in std_logic_vector(5 downto 0);
       AluControl : out std_logic_vector(2 downto 0));
  end component;

  component aludec is
  port (funct : in std_logic_vector(5 downto 0);
        aluop : in std_logic_vector(1 downto 0);
        alucontrol : out std_logic_vector(2 downto 0));
  end component;

  component maindec is
    port (MemToReg, MemWrite, Branch : out std_logic;
          AluSrc, RegDst, RegWrite, Jump : out std_logic;
          Op : in  std_logic_vector(5 downto 0);
          AluOp : out std_logic_vector(1 downto 0));
  end component;

  component adder is
    generic (width : positive := 32);
    port (a, b : in std_logic_vector((width - 1) downto 0);
          y : out std_logic_vector(width downto 0));
  end component;

  component full_adder is
    port (a, b, c_in : in std_logic;
          s, c_out : out std_logic);
  end component;

  component alu is
    port (alucontrol : in std_logic_vector(2 downto 0);
          a, b : in std_logic_vector(31 downto 0);
          zero : out std_logic;
          result : out std_logic_vector(31 downto 0));
  end component;

  component dmem is
    port(a: in std_logic_vector(31 downto 0);
         wd: in std_logic_vector(31 downto 0);
         rd: out std_logic_vector(31 downto 0);
         clk, we, dump : in std_logic);
  end component;

  component flopr is
    generic (width : positive := 32);
    port (reset, clk : in std_logic;
          d : in std_logic_vector((width - 1) downto 0);
          q : out std_logic_vector((width - 1) downto 0));
  end component;

  component flip_flop is
    port (d, reset, clk : in std_logic;
          q : out std_logic);
  end component;

  component imem is
    port(a: in std_logic_vector(5 downto 0);
         rd: out std_logic_vector(31 downto 0));
  end component;

  component mux2 is
    generic (width : positive := 32);
    port (s : in std_logic;
          d0, d1 : in std_logic_vector((width - 1) downto 0);
          y : out std_logic_vector((width - 1) downto 0));
  end component;

  component regfile is
    port(ra1, ra2, wa3: in std_logic_vector(4 downto 0);
         wd3: in std_logic_vector(31 downto 0);
         we3, clk: in std_logic;
         rd1, rd2: out std_logic_vector(31 downto 0));
  end component;

  component signext is
    generic (width : positive := 32);
    port (a : in std_logic_vector (((width / 2) - 1) downto 0);
          y : out std_logic_vector ((width - 1) downto 0));
  end component;

  component sl2 is
    generic (width : positive := 32);
    port (a : in std_logic_vector ((width - 1) downto 0);
          y : out std_logic_vector ((width - 1) downto 0));
  end component;

end package;
