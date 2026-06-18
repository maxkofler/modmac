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

entity MAC is
  port (
    --
    -- XII IN Interface
    --
    xii_i_c : in std_logic;
    xii_i_d : in std_logic_vector(7 downto 0);
    xii_i_e : in std_logic;
    xii_i_r : out std_logic;

    --
    --
    --
    rx_clk     : out std_logic;
    rx_address : out std_logic_vector(31 downto 0);
    rx_data    : out std_logic_vector(7 downto 0);
    rx_enable  : out std_logic
  );
end MAC;

architecture rtl of MAC is
  type t_RXState is (Idle, Preamble, Data);
  signal rx_state : t_RXState := Idle;
  signal s_rx_mac : std_logic_vector(47 downto 0);
begin

  p_rx : process (xii_i_c)
    variable last_state      : t_RXState             := Idle;
    variable rx_idle_counter : UNSIGNED(3 downto 0)  := (others => '0');
    variable counter         : UNSIGNED(15 downto 0) := (others => '0');
  begin
    if rising_edge(xii_i_c) then
      if xii_i_e = '1' then
        rx_idle_counter := (others => '0');
      else
        rx_idle_counter := rx_idle_counter + 1;
      end if;

      if rx_idle_counter >= 12 then
        rx_state <= Idle;
      end if;

      case rx_state is
        when Idle =>
          if xii_i_e = '1' then
            if xii_i_d = x"55" then
              rx_state <= Preamble;
            end if;
          end if;

        when Preamble =>
          if xii_i_e = '1' then
            case xii_i_d is
              when x"55" =>
                rx_state <= Preamble;
              when x"D5" =>
                rx_state <= Data;
              when others =>
                rx_state <= Idle;
            end case;
          end if;

        when others =>
          null;
      end case;
    end if;
  end process;

  -- For now, we're always ready
  xii_i_r <= '1';

end architecture;
