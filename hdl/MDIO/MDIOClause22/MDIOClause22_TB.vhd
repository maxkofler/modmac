library ieee;
use ieee.std_logic_1164.all;

entity MDIOClause22TBX is
  port (
    clk : out std_logic
  );
end MDIOClause22TBX;

architecture sim of MDIOClause22TBX is
  signal s_clk : std_logic := '0';

  signal s_mdio_clk     : std_logic := '0';
  signal s_reset_n      : std_logic;
  signal s_execute      : std_logic := '0';
  signal s_write_enable : std_logic := '0';
  signal s_phy_addr     : std_logic_vector(4 downto 0);
  signal s_reg_addr     : std_logic_vector(4 downto 0);
  signal s_data_in      : std_logic_vector(15 downto 0);
  signal s_data_out     : std_logic_vector(15 downto 0);
  signal s_busy         : std_logic;

  signal s_mdc             : std_logic;
  signal s_mdio_out        : std_logic;
  signal s_mdio_in         : std_logic := '0';
  signal s_mdio_out_enable : std_logic;

begin
  MDIOClause22Core_inst : entity work.MDIOClause22Core
    port map
    (
      mdio_clk        => s_mdio_clk,
      reset_n         => s_reset_n,
      execute         => s_execute,
      busy            => s_busy,
      write_enable    => s_write_enable,
      phy_addr        => s_phy_addr,
      reg_addr        => s_reg_addr,
      data_in         => s_data_in,
      data_out        => s_data_out,
      mdc             => s_mdc,
      mdio_in         => s_mdio_in,
      mdio_out        => s_mdio_out,
      mdio_out_enable => s_mdio_out_enable
    );

  process
  begin
    s_execute <= '0';
    wait for 10 ns;
    s_execute      <= '1';
    s_phy_addr     <= b"10010";
    s_reg_addr     <= b"10010";
    s_write_enable <= '0';
    s_data_in      <= b"1000000000000001";

    wait until falling_edge(s_mdio_out_enable);

    s_mdio_in <= '1';
    wait until falling_edge(s_mdio_clk);

    wait;
  end process;

  process
  begin
    s_mdio_clk <= not(s_mdio_clk);
    wait for 10 ns;
  end process;

end architecture;
