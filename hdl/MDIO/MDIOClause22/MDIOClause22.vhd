-- synthesis library modmac

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MDIOClause22 is
  port (
    mdio_clk : in std_logic;

    reset_n : in std_logic;

    execute      : in std_logic;
    busy         : out std_logic := '0';
    write_enable : in std_logic;

    phy_addr : in std_logic_vector(4 downto 0);
    reg_addr : in std_logic_vector(4 downto 0);
    data_in  : in std_logic_vector(15 downto 0);
    data_out : out std_logic_vector(15 downto 0) := x"0000";

    mdc             : out std_logic := '0';
    mdio_out        : out std_logic := '0';
    mdio_in         : in std_logic;
    mdio_out_enable : out std_logic := '0'
  );
end MDIOClause22;

architecture rtl of MDIOClause22 is
  signal s_write_enable : boolean;
  signal s_phy_addr     : std_logic_vector(4 downto 0);
  signal s_reg_addr     : std_logic_vector(4 downto 0);
  signal s_data         : std_logic_vector(15 downto 0);

  signal s_prev_execute : std_logic                     := '0';
  signal s_start        : std_logic                     := '0';
  signal s_busy         : std_logic                     := '0';
  signal s_mdio_out     : std_logic                     := '0';
  signal s_mdio_oe      : std_logic                     := '0';
  signal s_data_out     : std_logic_vector(15 downto 0) := x"0000";
  type t_State is (Idle, Preamble, Start1, Start2, Op1, Op2, PhyAddr, RegAddr, TA1, TA2, Data, Present);
begin

  mdc             <= mdio_clk and s_busy;
  busy            <= s_busy;
  data_out        <= s_data_out;
  mdio_out        <= s_mdio_out;
  mdio_out_enable <= s_mdio_oe;

  process (mdio_clk)
  begin
    if rising_edge(mdio_clk) then
      s_prev_execute <= execute;
      s_start        <= execute and not s_prev_execute;
    end if;
  end process;

  process (mdio_clk)
    variable state   : t_State;
    variable counter : unsigned(7 downto 0);
  begin
    if falling_edge(mdio_clk) then
      case state is
        when Idle =>
          s_mdio_out <= '0';
          s_mdio_oe  <= '0';
          s_busy     <= '0';

          if s_start = '1' then
            s_write_enable <= write_enable = '1';
            s_phy_addr     <= phy_addr;
            s_reg_addr     <= reg_addr;
            s_data         <= data_in;

            s_busy <= '1';

            counter := (others => '0');
            state   := Preamble;
            report "Idle -> Preamble";
          end if;

        when Preamble =>
          s_mdio_out <= '1';
          s_mdio_oe  <= '1';
          if counter >= 31 then
            report "Preamble -> Start";
            state := Start1;
          end if;
          counter := counter + 1;

        when Start1 =>
          s_mdio_out <= '0';
          state := Start2;

        when Start2 =>
          s_mdio_out <= '1';
          state := Op1;

        when Op1 =>
          if s_write_enable then
            s_mdio_out <= '0';
          else
            s_mdio_out <= '1';
          end if;
          state := Op2;

        when Op2 =>
          if s_write_enable then
            s_mdio_out <= '1';
          else
            s_mdio_out <= '0';
          end if;
          state   := PhyAddr;
          counter := (others => '0');

        when PhyAddr =>
          if counter >= 4 then
            s_mdio_out <= s_phy_addr(0);
            counter := (others => '0');
            state   := RegAddr;
          else
            s_mdio_out <= s_phy_addr(to_integer(4 - counter));
            counter := counter + 1;
          end if;

        when RegAddr =>
          if counter >= 4 then
            s_mdio_out <= s_reg_addr(0);
            counter := (others => '0');
            state   := TA1;
          else
            s_mdio_out <= s_reg_addr(to_integer(4 - counter));
            counter := counter + 1;
          end if;

        when TA1 =>
          if s_write_enable then
            s_mdio_out <= '1';
          else
            s_mdio_oe <= '0';
          end if;
          state := TA2;

        when TA2 =>
          s_mdio_out <= '0';
          state := Data;

        when Data =>
          if s_write_enable then
            s_mdio_out <= s_data(to_integer(15 - counter));
          else
            s_data(to_integer(15 - counter)) <= mdio_in;
          end if;

          if counter >= 15 then
            state := Present;
          end if;
          counter := counter + 1;

        when Present =>
          if not s_write_enable then
            -- At the end of RX, present the data
            s_data_out <= s_data;
          end if;

          state := Idle;

      end case;
    end if;
  end process;

end architecture;
