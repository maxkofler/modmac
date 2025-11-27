library ieee;
use ieee.std_logic_1164.all;

library modmac;

entity MDIOClause22Avalon is
  port (
    mdio_clk   : in std_logic;
    avalon_clk : in std_logic;

    reset_n : in std_logic;

    avalon_read       : in std_logic;
    avalon_read_data  : out std_logic_vector(31 downto 0);
    avalon_write      : in std_logic;
    avalon_write_data : in std_logic_vector(31 downto 0);

    mdc             : out std_logic;
    mdio_out        : out std_logic;
    mdio_in         : in std_logic;
    mdio_out_enable : out std_logic
  );
end MDIOClause22Avalon;

architecture rtl of MDIOClause22Avalon is
  signal s_mm_write    : std_logic := '0';
  signal s_mm_phy_addr : std_logic_vector(4 downto 0);
  signal s_mm_reg_addr : std_logic_vector(4 downto 0);
  signal s_mm_data_in  : std_logic_vector(15 downto 0);
  signal s_mm_data_out : std_logic_vector(15 downto 0);
  signal s_mm_busy     : std_logic;
  signal s_mm_execute  : std_logic;
begin

  process
  begin
    wait until avalon_clk'event and avalon_clk = '1';

    if avalon_read = '1' then
      avalon_read_data(15 downto 0)  <= s_mm_data_out;
      avalon_read_data(20 downto 16) <= s_mm_reg_addr;
      avalon_read_data(25 downto 21) <= s_mm_phy_addr;
      avalon_read_data(26)           <= s_mm_write;
      avalon_read_data(27)           <= s_mm_execute;
      avalon_read_data(28)           <= s_mm_busy;
    end if;

    if avalon_write = '1' then
      s_mm_data_in  <= avalon_write_data(15 downto 0);
      s_mm_reg_addr <= avalon_write_data(20 downto 16);
      s_mm_phy_addr <= avalon_write_data(25 downto 21);
      s_mm_write    <= avalon_write_data(26);
      s_mm_execute  <= avalon_write_data(27);
    end if;
  end process;

  mdio_inst : entity modmac.MDIOClause22
    port map
    (
      mdio_clk        => mdio_clk,
      reset_n         => reset_n,
      execute         => s_mm_execute,
      busy            => s_mm_busy,
      write_enable    => s_mm_write,
      phy_addr        => s_mm_phy_addr,
      reg_addr        => s_mm_reg_addr,
      data_in         => s_mm_data_in,
      data_out        => s_mm_data_out,
      mdc             => mdc,
      mdio_out        => mdio_out,
      mdio_in         => mdio_in,
      mdio_out_enable => mdio_out_enable
    );

end architecture;
