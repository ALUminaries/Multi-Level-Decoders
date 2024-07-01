-------------------------------------------------------------------------------------
-- sld_alt_v1.vhd
-------------------------------------------------------------------------------------
-- Authors:     Maxwell Phillips
-- Copyright:   Ohio Northern University, 2024.
-- License:     GPL v3
-- Description: Generic single-level (standard) decoder.
-- Precision:   Any power of 2 >= 4.
-------------------------------------------------------------------------------------
--
-- Returns 2 to the power of the input.
--
-- ! This decoder is dimensioned as `lg(n) : n`, not `n : 2^n`.
-- It is intentionally designed to complement a(n) (priority) encoder.
--
-- Requires VHDL-2008.
--
-------------------------------------------------------------------------------------
-- Generics
-------------------------------------------------------------------------------------
--
-- [G_lg_n]: Input length; base 2 logarithm of output length `n`
--
-- [G_n]: Output length `n`.
--
-------------------------------------------------------------------------------------
-- Ports
-------------------------------------------------------------------------------------
--
-- [input]: Parallel input of [G_lg_n] bits.
--
-- [output]: Parallel output of [G_n] bits, exactly 2^[input]; alternatively:
--  a vector of zeroes with a single high bit at index corresponding to [input].
--
-------------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use IEEE.numeric_std_unsigned.all;
  use IEEE.math_real.all;

entity sl_decoder is
  generic (
    G_n    : natural := 64;                             --! total output width
    G_lg_n : natural := natural(round(log2(real(G_n)))) --! total input width
  );
  port (
    input  : in    std_logic_vector(G_lg_n - 1 downto 0);
    output : out   std_logic_vector(G_n - 1 downto 0)
  );
end sl_decoder;

architecture behavioral of sl_decoder is

begin

  decoder: process (input) begin
    output <= (others => '0');

    for i in 0 to G_n - 1 loop
      if (i = to_integer(unsigned(input))) then
        output(i) <= '1';
      else
        output(i) <= '0';
      end if;
    end loop;
  end process;

end architecture behavioral;
