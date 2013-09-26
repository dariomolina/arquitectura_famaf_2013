library ieee;
library work;
use ieee.std_logic_1164.all;
use work.components.all;

entity datapath is
  port( MemToReg   : in std_logic;
        MemWrite   : in std_logic;
        Branch     : in std_logic;
        AluSrc     : in std_logic;
        RegDst     : in std_logic;
        RegWrite   : in std_logic;
        Jump       : in std_logic;
        AluControl : in std_logic_vector(2 downto 0);
        dump       : in std_logic;
        reset      : in std_logic;
        clk        : in std_logic;
        pc, instr  : out std_logic_vector(31 downto 0)
       );
end entity;

architecture behaviour of datapath is

  signal PCSrc, Zero                                    : std_logic;
  signal PCNext, PCJump, WriteReg, WriteData, s_Instr   : std_logic_vector(31 downto 0);
  signal ReadData, SrcA, SrcB, sPC, PCnew, SLout         : std_logic_vector(31 downto 0);
  signal Signlmm, Result, ALUResult, PCPlus4, PCBranch  : std_logic_vector(31 downto 0);    

begin

  PCJump <= PCPlus4(31 downto 28) & s_Instr(25 downto 0) & "00";
  PCSrc <= Branch and Zero;

  mp1    : mux2 port map (s => PCSrc, d0 => PCPlus4, d1 => PCBranch, y => PCNext);
  mp2    : mux2 port map (s => Jump, d0 => PCNext, d1 => PCJump, y => sPC);
  ff     : flopr port map (reset => reset, clk => clk, d => sPC, q => PCnew);
  adder1 : adder port map (a => PCnew, b => "100", y => PCPlus4);
  rom    : imem port map (a => PCnew(5 downto 0), d => s_Instr);
  reg    : regfile port map (ra1 => s_Instr(25 downto 21), ra2 => s_Instr(20 downto 16), wa3 => WriteReg(4 downto 0), wd3 => Result, we3 => RegWrite, clk => clk, rd1 => SrcA, rd2 => WriteData);
  signxt : signext port map (a => s_Instr(15 downto 0), y => Signlmm);
  mp3    : mux2 port map (s => RegDst, d0 => s_Instr(20 downto 16), d1 => s_Instr(15 downto 11), y => WriteReg);
  mp4    : mux2 port map (s => AluSrc, d0 => WriteData, d1 => Signlmm, y => SrcB);
  sl_2   : sl2 port map (a => Signlmm, y => SLout);
  aluu   : alu port map (alucontrol => AluControl, a => SrcA, b => SrcB, zero => Zero, result => ALUResult);
  adder2 : adder port map (a => SLout, b => PCPlus4, y => PCBranch);
  ram    : dmem port map (a => ALUResult, wd => WriteData, clk => clk, we => MemWrite, rd => ReadData);
  mp5    : mux2 port map (s => MemToReg, d0 => ALUResult, d1 => ReadData, y => Result);

  --pc <= PCnew;
  --instr <= s_Instr;
end architecture;
