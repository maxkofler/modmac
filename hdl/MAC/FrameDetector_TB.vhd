
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modmac;
use modmac.FrameDetector;

entity FrameDetector_tb is
end;

architecture bench of FrameDetector_tb is
  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  -- Ports
  signal xii_i_c  : std_logic                    := '0';
  signal xii_i_d  : std_logic_vector(7 downto 0) := (others => '0');
  signal xii_i_e  : std_logic                    := '0';
  signal in_frame : std_logic;
begin

  FrameDetector_inst : entity FrameDetector
    port map
    (
      xii_i_c  => xii_i_c,
      xii_i_d  => xii_i_d,
      xii_i_e  => xii_i_e,
      in_frame => in_frame
    );

  xii_i_c <= not xii_i_c after clk_period/2;

  process begin
    -- IPG
    xii_i_e <= '0';
    for byte in 0 to 11 loop
      wait until falling_edge(xii_i_c);
    end loop;

    -- Assert that in_frame is low after the IPG
    assert in_frame = '0'
    report "in_frame is high after IPG"
      severity ERROR;

    -- Preamble
    xii_i_e <= '1';
    xii_i_d <= x"55";
    for byte in 0 to 6 loop
      wait until falling_edge(xii_i_c);
      -- Assert that in_frame is low during the preamble
      assert in_frame = '0'
      report "in_frame is high in preamble"
        severity ERROR;
    end loop;

    -- SFD
    xii_i_d <= x"D5";
    wait until falling_edge(xii_i_c);

    -- Assert that in_frame is high after the SFD
    assert in_frame = '1'
    report "in_frame is low after SFD"
      severity ERROR;

    -- Some Data
    xii_i_d <= x"AA";
    for byte in 0 to 6 loop
      wait until falling_edge(xii_i_c);

      -- Assert that in_frame is high during data
      assert in_frame = '1'
      report "in_frame is low during data"
        severity ERROR;

    end loop;

  end process;

end;