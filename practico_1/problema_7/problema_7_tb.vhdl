library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity problema_7_tb is
  generic (width : positive := 32);
end entity;

architecture test_bench of problema_7_tb is
  type memory_rom is array (0 to 63) of std_logic_vector(31 downto 0);

  component imem
    port( a: in std_logic_vector(5 downto 0);
          d: out std_logic_vector(31 downto 0)
         );
  end component;
  signal sa : std_logic_vector(5 downto 0);
  signal sd : std_logic_vector(31 downto 0);
  signal rom : memory_rom;
begin
  tb_component : imem port map (a => sa, d => sd);
  process
  begin
    for i in 0 to 63 loop
      report "Empieza el test!";
      sa <= std_logic_vector(to_unsigned(i, 6));
      rom(i) <= std_logic_vector(to_unsigned(i, 32));
      sd <= std_logic_vector(to_unsigned(i, 32));
      wait for 5 ns;
      assert rom(to_integer(unsigned(sa))) = std_logic_vector(to_unsigned(i, 32));
      report "### Paso el test ###";
    end loop;
  end process;
end architecture;
