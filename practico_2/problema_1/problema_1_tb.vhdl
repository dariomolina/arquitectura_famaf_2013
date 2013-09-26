library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity problema_1_tb is
  generic (width : positive := 32);
end entity;

architecture test_bench of problema_1_tb is
  component regfile
    port( ra1, ra2, wa3: in std_logic_vector(4 downto 0);
          wd3: in std_logic_vector(31 downto 0);
          we3, clk: in std_logic;
          rd1, rd2: out std_logic_vector(31 downto 0)
         );
  end component;
  
  signal sra1, sra2, swa : std_logic_vector(4 downto 0);
  signal swe, sclk  : std_logic;
  signal swd, srd1, srd2  : std_logic_vector(31 downto 0);
  signal memory : reg_memory;
begin
  tb_component : regfile port map (ra1 => sra1, ra2 => sra2, wa3 => swa, wd3 => swd, we3 => swe, clk => sclk, rd1 => srd1, rd2 => srd2);
  process
    begin
      sclk <= '1';
      wait for 1 ns;
      sclk <= '0';
      wait for 1 ns;
  end process;
  process
    begin
      for i in 0 to 31 loop
        report "Empieza el test!";
        memory(i) <= std_logic_vector(to_unsigned(i, 32));
        sra1 <= std_logic_vector(to_unsigned(i, 5));
        sra2 <= std_logic_vector(to_unsigned(i, 5));
        swe <= '0';
        swd <= std_logic_vector(to_unsigned(i, 32));
        swa <= std_logic_vector(to_unsigned(i, 5));
        wait for 5 ns;
        --if (sclk'event and swe = '1') then
        --  assert memory(to_integer(unsigned(swa))) = std_logic_vector(to_unsigned(i, 32));
        --end if;
        srd1 <= std_logic_vector(to_unsigned(i, 32));
        srd2 <= std_logic_vector(to_unsigned(i, 32));
        assert srd1 = memory(i);
        assert srd1 = memory(i);
        report "### Paso el test ###";
      end loop;
  end process;
end architecture;
