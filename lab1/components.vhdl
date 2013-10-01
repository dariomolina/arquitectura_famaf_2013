library ieee;
use ieee.std_logic_1164.all;

package components is

  component controller is

    port(Op : in std_logic_vector(5 downto 0);
         Funct : in std_logic_vector(5 downto 0);
         MemToReg, MemWrite, Branch : out std_logic;
         AluSrc, RegDst, RegWrite, Jump : out std_logic;
         AluControl : out std_logic_vector(2 downto 0));

  end component;

  component maindec is

    port (Op : in std_logic_vector(5 downto 0);
          RegDst, RegWrite, Jump : out std_logic;
          AluOp : out std_logic_vector(1 downto 0);
          MemToReg, MemWrite, Branch, AluSrc : out std_logic);

  end component;

  component aludec is

    port (funct : in std_logic_vector(5 downto 0);
          aluop : in std_logic_vector(1 downto 0);
          alucontrol : out std_logic_vector(2 downto 0));

  end component;

  component datapath is

    port(AluControl : in std_logic_vector(2 downto 0);
         pc, instr : out std_logic_vector(31 downto 0);
         RegDst, RegWrite, Jump, dump, clk : in std_logic;
         MemToReg, MemWrite, Branch, AluSrc, reset : in std_logic);

  end component;

  component fetch is

    port (Jump, PcSrcM, clk, reset : in std_logic;
          PcBranchM : in std_logic_vector(31 downto 0);
          InstrF, PCF, PcPlus4F : out std_logic_vector(31 downto 0));

  end component;

  component if_de is

    port(reset, clk : in std_logic;
         InstrF, PCPlus4F : in std_logic_vector(31 downto 0);
         InstrD, PCPlus4D : out std_logic_vector(31 downto 0));

  end component;

  component decode is

    port (clk, RegWrite : in std_logic;
          A3 : in std_logic_vector(4 downto 0);
          RtD, RdD : out std_logic_vector(4 downto 0);
          InstrD, Wd3 : in std_logic_vector(31 downto 0);
          SignlmmD, RD1D, RD2D : out std_logic_vector(31 downto 0));

  end component;

  component de_ex is

    port(reset, clk : in std_logic;
         PCPlus4D, RD1D, RD2D, SignlmmD, RtD, RdD : in std_logic_vector(31 downto 0);
         PCPlus4E, RD1E, RD2E, SignlmmE, RtE, RdE : out std_logic_vector(31 downto 0));

  end component;

  component execute is

    port (ZeroE : out std_logic;
          RegDst, AluSrc : in std_logic;
          RtE, RdE : in std_logic_vector(4 downto 0);
          AluControl : in std_logic_vector(2 downto 0);
          WriteRegE : out std_logic_vector(4 downto 0);
          RD1E, RD2E, PCPlus4E, SignlmmE : in std_logic_vector(31 downto 0);
          AluOutE, WriteDataE, PCBranchE : out std_logic_vector(31 downto 0));

  end component;

  component ex_me is

    port(ZeroM : out std_logic;
         ZeroE, reset, clk : in std_logic;
         WriteRegE : in std_logic_vector(4 downto 0);
         WriteRegM : out std_logic_vector(4 downto 0);
         AluOutE, WriteDataE, PCBranchE : in std_logic_vector(31 downto 0);
         AluOutM, WriteDataM, PCBranchM : out std_logic_vector(31 downto 0));

  end component;

  component memory is

    port (PcSrcM : out std_logic;
          ReadDataM : out std_logic_vector(31 downto 0);
          MemWrite, Branch, ZeroM, clk, dump : in std_logic;
          AluOutM, WriteDataM : in std_logic_vector(31 downto 0));

  end component;

  component me_wb is

    port(reset, clk : in std_logic;
         WriteRegM : in std_logic_vector(4 downto 0);
         WriteRegW : out std_logic_vector(4 downto 0);
         AluOutM, ReadDataM : in std_logic_vector(31 downto 0);
         AluOutW, ReadDataW : out std_logic_vector(31 downto 0));

  end component;

  component writeback is

    port (MemToReg : in std_logic;
          ResultW : out std_logic_vector(31 downto 0);
          AluOutW, ReadDataW : in std_logic_vector(31 downto 0));

  end component;

  component adder is

    generic (width : positive := 32);
    port (y : out std_logic_vector(width downto 0);
          a, b : in std_logic_vector((width - 1) downto 0));

  end component;

  component full_adder is

    port (s, c_out : out std_logic;
          a, b, c_in : in std_logic);

  end component;

  component alu is

    port (zero : out std_logic;
          a, b : in std_logic_vector(31 downto 0);
          result : out std_logic_vector(31 downto 0);
          alucontrol : in std_logic_vector(2 downto 0));

  end component;

  component dmem is

    port(clk, we, dump : in std_logic;
         a: in std_logic_vector(31 downto 0);
         wd: in std_logic_vector(31 downto 0);
         rd: out std_logic_vector(31 downto 0));


  end component;

  component flopr is

    generic (width : positive := 32);
    port (reset, clk : in std_logic;
          d : in std_logic_vector((width - 1) downto 0);
          q : out std_logic_vector((width - 1) downto 0));

  end component;

  component flip_flop is

    port (q : out std_logic;
          d, reset, clk : in std_logic);

  end component;

  component imem is

    port(a: in std_logic_vector(5 downto 0);
         rd: out std_logic_vector(31 downto 0));

  end component;

  component mux2 is

    generic (width : positive := 32);
    port (s : in std_logic;
          y : out std_logic_vector((width - 1) downto 0);
          d0, d1 : in std_logic_vector((width - 1) downto 0));

  end component;

  component regfile is

    port(we3, clk: in std_logic;
         wd3: in std_logic_vector(31 downto 0);
         rd1, rd2: out std_logic_vector(31 downto 0);
         ra1, ra2, wa3: in std_logic_vector(4 downto 0));

  end component;

  component signext is

    generic (width : positive := 32);
    port (y : out std_logic_vector ((width - 1) downto 0);
          a : in std_logic_vector (((width / 2) - 1) downto 0));

  end component;

  component sl2 is

    generic (width : positive := 32);
    port (a : in std_logic_vector ((width - 1) downto 0);
          y : out std_logic_vector ((width - 1) downto 0));

  end component;

end package;
