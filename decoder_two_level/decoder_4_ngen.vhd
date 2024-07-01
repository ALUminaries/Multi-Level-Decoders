library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity decoder_4 is
generic(
  g_n:      integer := 4;  -- Input (multiplier) length is n
  g_log2n:  integer := 2;  -- Base 2 Logarithm of input length n; i.e., output length
  g_q:      integer := 2;  -- q is the least power of 2 greater than sqrt(n); i.e., 2^(ceil(log_2(sqrt(n)))
  g_log2q:  integer := 1;  -- Base 2 Logarithm of q
  g_k:      integer := 2;  -- k is defined as n/q, if n is a perfect square, then k = sqrt(n) = q
  g_log2k:  integer := 1  -- Base 2 Logarithm of k
);
port(
  input: in std_logic_vector(g_log2n - 1 downto 0); -- value to decode, i.e., shift amount for multiplication)
  output: out std_logic_vector(g_n - 1 downto 0) -- decoded result (C_i)
);
end decoder_4;

architecture behavioral of decoder_4 is

signal col: std_logic_vector(g_k - 1 downto 0); -- column/coarse decoder, handles log2k most significant bits of input
signal row: std_logic_vector(g_q - 1 downto 0); -- row/fine decoder, handles log2q least significant bits of input
signal result: std_logic_vector(g_n - 1 downto 0); -- result of decoding, i.e., 2^{input}

begin
-- Decoding corresponds to binary representation of given portions of shift

col(1) <= input(1);
col(0)  <= not input(1);

row(1) <= input(0);
row(0)  <= not input(0);


-- generates each bit of the decoder result
-- see two-level decoder block diagram
coarse: for i in g_k - 1 downto 0 generate -- generate columns
  fine: for j in g_q - 1 downto 0 generate -- generate rows
    result((g_q * i) + j) <= col(i) and row(j);
  end generate fine;
end generate coarse;

output <= result;
end;