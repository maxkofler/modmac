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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modmac;

entity RGMIIPhy is
  port (
    -- The clock to use for mac_out_clk
    mii_clk : in std_logic;
    -- The clock to use for rgmii_txc
    rgmii_clk_clk : in std_logic;
    -- The clock for rgmii_txd and rgmii_tx_ctl
    rgmii_data_clk : in std_logic;

    -- The interface towards the real MAC, implemented as hybrid MII
    mii_in_clk     : in std_logic;
    mii_in_enable  : in std_logic;
    mii_in_data    : in std_logic_vector(7 downto 0);
    mii_out_clk    : out std_logic;
    mii_out_enable : out std_logic;
    mii_out_data   : out std_logic_vector(7 downto 0);

    -- The RGMII interface
    rgmii_txc   : out std_logic;
    rgmii_txd   : out std_logic_vector(3 downto 0);
    rgmii_txctl : out std_logic;
    rgmii_rxc   : in std_logic;
    rgmii_rxd   : in std_logic_vector(3 downto 0);
    rgmii_rxctl : in std_logic;

    -- Statistic counters
    rx_bytes     : out std_logic_vector(31 downto 0);
    tx_bytes     : out std_logic_vector(31 downto 0);
    rx_overflows : out std_logic_vector(31 downto 0);
    tx_overflows : out std_logic_vector(31 downto 0)
  );
end RGMIIPhy;

architecture rtl of RGMIIPhy is

begin

  ddio_out : entity modmac.DDIO_IN
    port map
    (
      clk      => rgmii_rxc,
      in_rxd   => rgmii_rxd,
      in_rxctl => rgmii_rxctl
    );

end architecture;
