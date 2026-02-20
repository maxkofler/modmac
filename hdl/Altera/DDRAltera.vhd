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

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modmac;

entity DDIO_IN is
  port (
    clk : in std_logic;

    in_rxd   : in std_logic_vector(3 downto 0);
    in_rxctl : in std_logic;

    out_rxd_high   : out std_logic_vector(3 downto 0);
    out_rxd_low    : out std_logic_vector(3 downto 0);
    out_rxctl_high : out std_logic;
    out_rxctl_low  : out std_logic
  );
end entity;

architecture rtl of DDIO_IN is

begin
  ddio_in : ALTDDIO_IN
  generic map(
    --intended_device_family => "Cyclone V", -- This is commented, should be chosen automatically
    invert_input_clocks => "ON",
    lpm_hint            => "UNUSED",
    lpm_type            => "altddio_in",
    power_up_high       => "OFF",
    width               => 5
  )
  port map
  (
    datain(3 downto 0)    => in_rxd,
    datain(4)             => in_rxctl,
    inclock               => clk,
    dataout_h(3 downto 0) => out_rxd_high,
    dataout_h(4)          => out_rxctl_high,
    dataout_l(3 downto 0) => out_rxd_high,
    dataout_l(4)          => out_rxctl_low
  );
end architecture;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modmac;

entity DDIO_OUT is
  port (
    clk : in std_logic;

    rgmii_in_txd_high   : in std_logic_vector(3 downto 0);
    rgmii_in_txd_low    : in std_logic_vector(3 downto 0);
    rgmii_in_txctl_high : in std_logic;
    rgmii_in_txctl_low  : in std_logic;

    rgmii_out_txd   : out std_logic_vector(3 downto 0);
    rgmii_out_txctl : out std_logic;
    rgmii_out_txc   : out std_logic
  );
end entity;

architecture rtl of DDIO_OUT is

begin

  ddio_out : ALTDDIO_OUT
  generic map(
    --intended_device_family => "Cyclone V", -- This is commented, should be chosen automatically
    extend_oe_disable => "OFF",
    invert_output     => "OFF",
    lpm_hint          => "UNUSED",
    lpm_type          => "altddio_out",
    oe_reg            => "UNREGISTERED",
    power_up_high     => "OFF",
    width             => 6
  )
  port map
  (
    datain_h(3 downto 0) => rgmii_in_txd_high,
    datain_h(4)          => rgmii_in_txctl_high,
    datain_h(5)          => '1', -- TXC high
    datain_l(3 downto 0) => rgmii_in_txd_low,
    datain_l(4)          => rgmii_in_txctl_low,
    datain_l(5)          => '0', -- TXC low
    outclock             => clk,
    dataout(3 downto 0)  => rgmii_out_txd,
    dataout(4)           => rgmii_out_txctl,
    dataout(5)           => rgmii_out_txc
  );

end architecture;
