
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modmac;
use modmac.MACAvalon;

entity MAC_tb is
end;

architecture bench of MAC_tb is
  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  -- Ports
  signal xii_i_c : std_logic                    := '0';
  signal xii_i_d : std_logic_vector(7 downto 0) := (others => '0');
  signal xii_i_e : std_logic                    := '0';
  signal xii_i_r : std_logic;
begin

  MAC_inst : entity MACAvalon
    port map
    (
      avalon_clk       => xii_i_c,
      reset_n          => '1',
      mgt_avalon_read  => '0',
      mgt_avalon_write => '0',
      mgt_avalon_address => (others => '0'),
      xii_i_c          => xii_i_c,
      xii_i_d          => xii_i_d,
      xii_i_e          => xii_i_e,
      xii_i_r          => xii_i_r
    );

  xii_i_c <= not xii_i_c after clk_period/2;

  process begin
    -- IPG
    xii_i_e <= '0';
    for byte in 0 to 11 loop
      wait until falling_edge(xii_i_c);
    end loop;

    -- Preamble
    xii_i_e <= '1';
    xii_i_d <= x"55";
    for byte in 0 to 6 loop
      wait until falling_edge(xii_i_c);
    end loop;

    -- SFD
    xii_i_d <= x"D5";
    wait until falling_edge(xii_i_c);

    -- Some Data
    xii_i_d <= x"AA";
    for byte in 0 to 6 loop
      wait until falling_edge(xii_i_c);
    end loop;

  end process;

end;