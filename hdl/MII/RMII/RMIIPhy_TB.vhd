
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modmac;
use modmac.RMIIPhy;

entity RMIIPhy_tb is
end;

architecture bench of RMIIPhy_tb is
  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  -- Ports
  signal rmii_ref_clk : std_logic                    := '0';
  signal rmii_crs_dv  : std_logic                    := '0';
  signal rmii_rxd     : std_logic_vector(1 downto 0) := (others => '0');
  signal rmii_rx_er   : std_logic                    := '0';
  signal rmii_tx_en   : std_logic;
  signal rmii_txd     : std_logic_vector(1 downto 0);
  signal xii_i_c      : std_logic                    := '0';
  signal xii_i_d      : std_logic_vector(7 downto 0) := (others => '0');
  signal xii_i_e      : std_logic                    := '0';
  signal xii_i_r      : std_logic;
  signal xii_o_c      : std_logic;
  signal xii_o_d      : std_logic_vector(7 downto 0);
  signal xii_o_e      : std_logic;
  signal xii_o_r      : std_logic := '0';
  signal rx_frames    : std_logic_vector(31 downto 0);
begin

  RMIIPhy_inst : entity RMIIPhy
    port map
    (
      rmii_ref_clk => rmii_ref_clk,
      rmii_crs_dv  => rmii_crs_dv,
      rmii_rxd     => rmii_rxd,
      rmii_rx_er   => rmii_rx_er,
      rmii_tx_en   => rmii_tx_en,
      rmii_txd     => rmii_txd,
      xii_i_c      => xii_i_c,
      xii_i_d      => xii_i_d,
      xii_i_e      => xii_i_e,
      xii_i_r      => xii_i_r,
      xii_o_c      => xii_o_c,
      xii_o_d      => xii_o_d,
      xii_o_e      => xii_o_e,
      xii_o_r      => xii_o_r,
      rx_frames    => rx_frames
    );

  rmii_ref_clk <= not rmii_ref_clk after clk_period/2;

  process begin
    -- Idle for some time
    rmii_rxd <= "00";
    for byte in 0 to 5 loop
      wait until falling_edge(rmii_ref_clk);
    end loop;

    -- Data Valid goes high, but no preamble yet...
    rmii_crs_dv <= '1';
    for byte in 0 to 5 loop
      wait until falling_edge(rmii_ref_clk);
    end loop;

    -- Preamble
    rmii_rxd <= "01";
    -- 1 
    for byte in 0 to 5 loop
      wait until falling_edge(rmii_ref_clk);
      wait until falling_edge(rmii_ref_clk);
      wait until falling_edge(rmii_ref_clk);
      wait until falling_edge(rmii_ref_clk);
    end loop;

    -- Start Frame Delimiter
    rmii_rxd <= "01";
    wait until falling_edge(rmii_ref_clk);
    wait until falling_edge(rmii_ref_clk);
    wait until falling_edge(rmii_ref_clk);
    rmii_rxd <= "11";
    wait until falling_edge(rmii_ref_clk);

    rmii_rxd <= "10";
    -- Some Data
    for byte in 0 to 1 loop
      wait until falling_edge(rmii_ref_clk);
      wait until falling_edge(rmii_ref_clk);
      wait until falling_edge(rmii_ref_clk);
      wait until falling_edge(rmii_ref_clk);
    end loop;

    rmii_crs_dv <= '0';
    wait for 1 us;
  end process;

end;