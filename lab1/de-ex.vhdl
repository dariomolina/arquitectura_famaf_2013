library ieee;
library work;
use work.components.all;
use ieee.std_logic_1164.all;

entity de_ex is

  port(reset, clk : in std_logic;
       PCPlus4D, RD1D, RD2D, SignlmmD, RtD, RdD : in std_logic_vector(31 downto 0);
       PCPlus4E, RD1E, RD2E, SignlmmE, RtE, RdE : out std_logic_vector(31 downto 0));

end entity;

architecture behavior of de_ex is
begin

--  PCPlus_FF  : flopr port map (reset => reset, clk => clk, d => PCPlus4D, q => PCPlus4E);
--  RD1_FF     : flopr port map (reset => reset, clk => clk, d => RD1D, q => RD1E);
--  RD2_FF     : flopr port map (reset => reset, clk => clk, d => RD2D, q => RD2E);
--  Signllm_FF : flopr port map (reset => reset, clk => clk, d => SignllmD, q => SignllmE);
--  Rt_FF      : flopr port map (reset => reset, clk => clk, d => RtD, q => RtE);
--  Rd_FF      : flopr port map (reset => reset, clk => clk, d => RdD, q => RdE);

  PCPlus4E <= PCPlus4D;
end architecture;
