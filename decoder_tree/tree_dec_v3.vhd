-------------------------------------------------------------------------------------
-- tree_dec_v3.vhd
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
-- [G_max_divisions]: 
--   Maximum number of divisions of the decoder.
--   Minimum 2, but at least 4 is recommended.
--
--   The hardware description generally attempts to heuristically optimize the
--   number of divisions to roughly the cubic root of the input size.
-- 
--   The hardware will not divide itself into more than this number, however,
--   this generic can be used to limit the number of divisions to something lower.
-- 
--   The decoder may not necessarily be subdivided into this many sub-decoders,
--   depending on the input size. 
--  
--   The smallest decoder is a 2:4 decoder, so if [G_max_divisions] is high enough, 
--   and the input size is small enough, the number of sub-decoders will be
--   less than [G_max_divisions].
--
-- [G_base_out_size]: 
--   The maximum size of the smallest decoder in the tree.
--   Default and minimum is 4. Depending on the output size [G_n], 8 might be better.
--
--   The maximum of this constraint is [G_n].
--
--   Like [G_max_divisions], this is also not absolute, because the top-level decoder
--   might need to be smaller than this constraint would seem to allow because of
--   the number of divisions. 
--   
--   For instance, with a 6:64 decoder with 4 divisions and a base size of 16, 
--   the top-level decoder would be 2:4, and the sub-decoders would be 4:16 
--   (single-level). With a smaller base size, the 4:16 decoders would be 
--   multi-level, consisting of either 2:4 or 3:8 decoders.
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

entity tree_decoder is
  generic (
    G_n             : natural := 64;                              --! total output width
    G_lg_n          : natural := natural(round(log2(real(G_n)))); --! total input width
    G_max_divisions : natural := 4;                               -- * maximum number of divisions, or fanout
    G_base_out_size : natural := 4                                -- * the output size of the base case decoder
  );
  port (
    enable : in    std_logic;
    input  : in    std_logic_vector(G_lg_n - 1 downto 0);
    output : out   std_logic_vector(G_n - 1 downto 0)
  );
end tree_decoder;

architecture behavioral of tree_decoder is

  -- shorthand function to calculate the size of a signal in bits

  function lg (arg: natural) return natural is begin

    return natural(round(log2(real(arg))));

  end function;

  component sl_decoder_en is
    generic (
      G_n    : natural;
      G_lg_n : natural
    );
    port (
      enable : in    std_logic;
      input  : in    std_logic_vector(G_lg_n - 1 downto 0);
      output : out   std_logic_vector(G_n - 1 downto 0)
    );
  end component;

  component tree_decoder is
    generic (
      G_n             : natural;
      G_lg_n          : natural;
      G_max_divisions : natural;
      G_base_out_size : natural
    );
    port (
      enable : in    std_logic;
      input  : in    std_logic_vector(G_lg_n - 1 downto 0);
      output : out   std_logic_vector(G_n - 1 downto 0)
    );
  end component;

  -- automatically generate a "heuristically optimized" number of divisions
  constant auto_num_divisions : natural := natural(round(2 ** ceil(log2(cbrt(real(G_n))))));
  -- constant auto_num_divisions : natural := natural(round(2 ** ceil(log2(sqrt(real(G_n)))))); -- for switching to sqrt if desired

  -- determine the number of divisions to actually use by constraining
  -- the automatically generated number to [2, G_max_divisions]
  constant num_divisions : natural := maximum(2, minimum(G_max_divisions, auto_num_divisions));

  -- determine the output size of each sub-decoder
  constant sub_dec_out_size : natural := G_n / num_divisions;

  -- constrain the output size of the base-case decoder in the recursion to [4, G_n]
  -- logically, the size of any sub-decoder must be smaller than
  -- the total output size divided by the number of sub-decoders.
  -- however, the [G_base_out_size] constraint can be used to limit recursion more aggressively,
  -- so it may be the case that the base decoder size should be equal to the input size,
  -- which will force a single-level decoder to be generated.
  constant base_dec_size : natural := maximum(4, minimum(G_base_out_size, G_n));

  signal select_en : std_logic_vector(num_divisions - 1 downto 0);

begin

  tree :
  if G_n > base_dec_size and sub_dec_out_size > 1 generate

    top_decoder : tree_decoder
      generic map (
        -- one output for each sub-decoder
        G_n             => num_divisions,
        G_lg_n          => lg(num_divisions),
        G_max_divisions => G_max_divisions,
        G_base_out_size => G_base_out_size
      )
      port map (
        enable => enable,
        input  => input(input'left downto input'left - lg(num_divisions) + 1),
        output => select_en
      );

    gen_sub_decoders :
    for i in 0 to num_divisions - 1 generate

      sub_decoder : tree_decoder
        generic map (
          G_n             => sub_dec_out_size,
          G_lg_n          => lg(sub_dec_out_size),
          G_max_divisions => G_max_divisions,
          G_base_out_size => G_base_out_size
        )
        port map (
          enable => select_en(i),
          input  => input(input'left - lg(num_divisions) downto 0),
          output => output((i * sub_dec_out_size) + (sub_dec_out_size - 1) downto i * sub_dec_out_size)
        );

    end generate gen_sub_decoders;

  else generate -- base case

    base_decoder : sl_decoder_en
    generic map (
      G_lg_n => G_lg_n,
      G_n    => G_n
    )
    port map (
      enable => enable,
      input  => input,
      output => output
    );

  end generate tree;

end architecture behavioral;
