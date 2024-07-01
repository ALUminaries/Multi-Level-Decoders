-------------------------------------------------------------------------------------
-- sld_en_v1.vhd
-------------------------------------------------------------------------------------
-- Authors:     Maxwell Phillips
-- Copyright:   Ohio Northern University, 2024.
-- License:     GPL v3
-- Description: Generic single-level (standard) decoder with enable signal.
-- Precision:   Any power of 2 >= 4.
-------------------------------------------------------------------------------------
--
-- Returns 2 to the power of the input.
-- * This decoder has an enable signal which must be high for it to output correctly.
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
-- [enable]: Single-bit input; when high, outputs normally; when low, outputs zero.
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

entity sl_decoder_en is
  generic (
    G_n    : natural := 64;                             --! total output width
    G_lg_n : natural := natural(round(log2(real(G_n)))) --! total input width
  );
  port (
    enable : in    std_logic;
    input  : in    std_logic_vector(G_lg_n - 1 downto 0);
    output : out   std_logic_vector(G_n - 1 downto 0)
  );
end sl_decoder_en;

architecture behavioral of sl_decoder_en is

begin

  -- [enable] must be in the sensitivity list or can't-happen states will happen,
  -- and behavior will appear like an impure function despite not being one.
  -- this is fixed since changes in [enable] will reset [output].
  decoder: process (input, enable) begin
    output <= (others => '0');
    
    if (enable = '1') then
      output(natural(to_integer(unsigned(input)))) <= '1';
    end if;
  end process;

end architecture behavioral;
