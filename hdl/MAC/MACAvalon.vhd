
library ieee;
use ieee.std_logic_1164.all;

library modmac;
use modmac.FrameDetector;

entity MACAvalon is
  port (
    avalon_clk : in std_logic;
    reset_n    : in std_logic;

    --
    -- Management Avalon Agent
    --
    mgt_avalon_read       : in std_logic;
    mgt_avalon_write      : in std_logic;
    mgt_avalon_address    : in std_logic_vector(1 downto 0);
    mgt_avalon_read_data  : out std_logic_vector(31 downto 0);
    mgt_avalon_write_data : out std_logic_vector(31 downto 0);

    --
    -- Data Avalon Host
    --
    data_avalon_address   : out std_logic_vector(15 downto 0);
    data_avalon_write     : out std_logic;
    data_avalon_writedata : out std_logic_vector(7 downto 0);

    --
    -- XII IN Interface
    --
    xii_i_c : in std_logic;
    xii_i_d : in std_logic_vector(7 downto 0);
    xii_i_e : in std_logic;
    xii_i_r : out std_logic
  );
end MACAvalon;

architecture rtl of MACAvalon is
  signal s_in_frame : std_logic;
begin

  frame_detector : entity FrameDetector
    port map
    (
      xii_i_c  => xii_i_c,
      xii_i_d  => xii_i_d,
      xii_i_e  => xii_i_e,
      in_frame => s_in_frame
    );
  xii_i_r <= '1';

end architecture;