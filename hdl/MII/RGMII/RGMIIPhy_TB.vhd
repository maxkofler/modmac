
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modmac;

entity RGMIIPhy_tb is
end;

architecture bench of RGMIIPhy_tb is
  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  -- Ports
  signal mii_clk        : std_logic;
  signal rgmii_clk_clk  : std_logic;
  signal rgmii_data_clk : std_logic;
  signal mii_in_clk     : std_logic;
  signal mii_in_enable  : std_logic;
  signal mii_in_data    : std_logic_vector(7 downto 0);
  signal mii_out_clk    : std_logic;
  signal mii_out_enable : std_logic;
  signal mii_out_data   : std_logic_vector(7 downto 0);
  signal rgmii_txc      : std_logic;
  signal rgmii_txd      : std_logic_vector(3 downto 0);
  signal rgmii_txctl    : std_logic;
  signal rgmii_rxc      : std_logic                    := '0';
  signal rgmii_rxd      : std_logic_vector(3 downto 0) := (others => '0');
  signal rgmii_rxctl    : std_logic                    := '0';
  signal rx_bytes       : std_logic_vector(31 downto 0);
  signal tx_bytes       : std_logic_vector(31 downto 0);
  signal rx_overflows   : std_logic_vector(31 downto 0);
  signal tx_overflows   : std_logic_vector(31 downto 0);
begin

  RGMIIPhy_inst : entity modmac.RGMIIPhy
    port map
    (
      mii_clk        => mii_clk,
      rgmii_clk_clk  => rgmii_clk_clk,
      rgmii_data_clk => rgmii_data_clk,
      mii_in_clk     => mii_in_clk,
      mii_in_enable  => mii_in_enable,
      mii_in_data    => mii_in_data,
      mii_out_clk    => mii_out_clk,
      mii_out_enable => mii_out_enable,
      mii_out_data   => mii_out_data,
      rgmii_txc      => rgmii_txc,
      rgmii_txd      => rgmii_txd,
      rgmii_txctl    => rgmii_txctl,
      rgmii_rxc      => rgmii_rxc,
      rgmii_rxd      => rgmii_rxd,
      rgmii_rxctl    => rgmii_rxctl,
      rx_bytes       => rx_bytes,
      tx_bytes       => tx_bytes,
      rx_overflows   => rx_overflows,
      tx_overflows   => tx_overflows
    );

  p_rgmii_rxc : process begin
    wait for 8 ns;
    rgmii_rxc <= not(rgmii_rxc);
  end process;

  p_rx_ctl : process begin
    wait until falling_edge(rgmii_rxc);
    wait for 4 ns;
    rgmii_rxctl <= not(rgmii_rxctl);

    wait until falling_edge(rgmii_rxc);
    wait until falling_edge(rgmii_rxc);
    wait until falling_edge(rgmii_rxc);
    wait until falling_edge(rgmii_rxc);
    wait until falling_edge(rgmii_rxc);
    wait until falling_edge(rgmii_rxc);
    wait until falling_edge(rgmii_rxc);
    wait until falling_edge(rgmii_rxc);
    wait until falling_edge(rgmii_rxc);
  end process;

  p_counter : process begin
    wait until falling_edge(rgmii_rxc);
    wait for 4 ns;
    rgmii_rxd <= std_logic_vector(unsigned(rgmii_rxd) + 1);
  end process;

end;