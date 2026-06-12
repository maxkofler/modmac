--
-- Copyright (c) 2025 Max Kofler
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

-- synthesis library modmac

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modmac;

entity RMIIPhy is
  port (
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
    xii_o_r : in std_logic;

    --
    -- Diagnostics
    --
    rx_frames : out std_logic_vector(31 downto 0);
    rx_octets : out std_logic_vector(31 downto 0)
  );
end RMIIPhy;

architecture rtl of RMIIPhy is
  signal s_xii_o_d, s_xii_i_d : std_logic_vector(7 downto 0) := (others => '0');
  signal s_xii_o_e, s_xii_i_e : std_logic;

  signal s_rmii_tx_en : std_logic;
  signal s_rmii_td    : std_logic_vector(1 downto 0);

  signal s_rmii_rxd : std_logic_vector(7 downto 0);

  signal s_rx_frames : UNSIGNED(31 downto 0) := (others => '0');
  signal s_rx_octets : UNSIGNED(31 downto 0) := (others => '0');

  type t_RXState is (Idle, Dibit1, Dibit2, Dibit3, Dibit4);
  signal state : t_RXState := Idle;
begin

  rx : process (rmii_ref_clk)
  begin
    if rising_edge(rmii_ref_clk) then
      case state is

        when Idle =>
          s_xii_o_e <= '0';
          if rmii_crs_dv = '1' and rmii_rxd = "01" then
            s_rmii_rxd(7) <= rmii_rxd(0);
            s_rmii_rxd(6) <= rmii_rxd(1);
            state         <= Dibit2;
            s_rx_frames   <= s_rx_frames + 1;
          end if;

        when Dibit1 =>
          s_xii_o_d <= s_rmii_rxd;
          s_xii_o_e <= '1';

          if rmii_crs_dv = '1' then
            s_rmii_rxd(7) <= rmii_rxd(0);
            s_rmii_rxd(6) <= rmii_rxd(1);
            state         <= Dibit2;
          else
            state <= Idle;
          end if;

        when Dibit2 =>
          s_xii_o_e <= '0';
          if rmii_crs_dv = '1' then
            s_rmii_rxd(5) <= rmii_rxd(0);
            s_rmii_rxd(4) <= rmii_rxd(1);
            state         <= Dibit3;
          else
            state <= Idle;
          end if;

        when Dibit3 =>
          if rmii_crs_dv = '1' then
            s_rmii_rxd(3) <= rmii_rxd(0);
            s_rmii_rxd(2) <= rmii_rxd(1);
            state         <= Dibit4;
          else
            state <= Idle;
          end if;

        when Dibit4 =>
          if rmii_crs_dv = '1' then
            s_rmii_rxd(1) <= rmii_rxd(0);
            s_rmii_rxd(0) <= rmii_rxd(1);
            s_rx_octets   <= s_rx_octets + 1;
            state         <= Dibit1;
          else
            state <= Idle;
          end if;

      end case;

    end if;
  end process;

  xii_o_c <= rmii_ref_clk;
  xii_o_d <= s_xii_o_d;
  xii_o_e <= s_xii_o_e;

  rx_frames <= std_logic_vector(s_rx_frames);
  rx_octets <= std_logic_vector(s_rx_octets);

end architecture;
