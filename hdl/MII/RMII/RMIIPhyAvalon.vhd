library ieee;
use ieee.std_logic_1164.all;

library modmac;

entity RMIIPhyAvalon is
  port (
    avalon_clk : in std_logic;
    reset_n    : in std_logic;

    avalon_read      : in std_logic;
    avalon_address   : in std_logic_vector(1 downto 0);
    avalon_read_data : out std_logic_vector(31 downto 0);

    --
    -- RMII Interface
    --
    rmii_ref_clk : in std_logic;
    rmii_crs_dv  : in std_logic;
    rmii_rxd     : in std_logic_vector(1 downto 0);
    rmii_rx_er   : in std_logic;
    rmii_tx_en   : out std_logic;
    rmii_txd     : out std_logic_vector(1 downto 0);

    --
    -- XII IN Interface
    --
    xii_i_c : in std_logic;
    xii_i_d : in std_logic_vector(7 downto 0);
    xii_i_e : in std_logic;
    xii_i_r : out std_logic;

    --
    -- XII OUT Interface
    --
    xii_o_c : out std_logic;
    xii_o_d : out std_logic_vector(7 downto 0);
    xii_o_e : out std_logic;
    xii_o_r : in std_logic
  );
end RMIIPhyAvalon;

architecture rtl of RMIIPhyAvalon is
  signal s_mm_rx_frames : std_logic_vector(31 downto 0);
  signal s_mm_rx_octets : std_logic_vector(31 downto 0);
begin

  process
  begin
    wait until avalon_clk'event and avalon_clk = '1';

    if avalon_read = '1' then
      case avalon_address is
        when "00" =>
          avalon_read_data <= s_mm_rx_octets;
        when "01" =>
          avalon_read_data <= s_mm_rx_frames;
        when others                 =>
          avalon_read_data <= (others => '0');
      end case;
    end if;

  end process;

  mdio_inst : entity modmac.RMIIPhy
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
      rx_frames    => s_mm_rx_frames,
      rx_octets    => s_mm_rx_octets
    );

end architecture;
