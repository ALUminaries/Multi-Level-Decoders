library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity decoder_8192 is
generic(
  g_n:      integer := 8192;  -- Input (multiplier) length is n
  g_log2n:  integer := 13;  -- Base 2 Logarithm of input length n; i.e., output length
  g_q:      integer := 128;  -- q is the least power of 2 greater than sqrt(n); i.e., 2^(ceil(log_2(sqrt(n)))
  g_log2q:  integer := 7;  -- Base 2 Logarithm of q
  g_k:      integer := 64;  -- k is defined as n/q, if n is a perfect square, then k = sqrt(n) = q
  g_log2k:  integer := 6  -- Base 2 Logarithm of k
);
port(
  input: in std_logic_vector(g_log2n - 1 downto 0); -- value to decode, i.e., shift amount for multiplication)
  output: out std_logic_vector(g_n - 1 downto 0) -- decoded result (C_i)
);
end decoder_8192;

architecture behavioral of decoder_8192 is

signal col: std_logic_vector(g_k - 1 downto 0); -- column/coarse decoder, handles log2k most significant bits of input
signal row: std_logic_vector(g_q - 1 downto 0); -- row/fine decoder, handles log2q least significant bits of input
signal result: std_logic_vector(g_n - 1 downto 0); -- result of decoding, i.e., 2^{input}

begin
-- Decoding corresponds to binary representation of given portions of shift

col(63) <= input(12) and input(11) and input(10) and input(9) and input(8) and input(7);
col(62) <= input(12) and input(11) and input(10) and input(9) and input(8) and not input(7);
col(61) <= input(12) and input(11) and input(10) and input(9) and not input(8) and input(7);
col(60) <= input(12) and input(11) and input(10) and input(9) and not input(8) and not input(7);
col(59) <= input(12) and input(11) and input(10) and not input(9) and input(8) and input(7);
col(58) <= input(12) and input(11) and input(10) and not input(9) and input(8) and not input(7);
col(57) <= input(12) and input(11) and input(10) and not input(9) and not input(8) and input(7);
col(56) <= input(12) and input(11) and input(10) and not input(9) and not input(8) and not input(7);
col(55) <= input(12) and input(11) and not input(10) and input(9) and input(8) and input(7);
col(54) <= input(12) and input(11) and not input(10) and input(9) and input(8) and not input(7);
col(53) <= input(12) and input(11) and not input(10) and input(9) and not input(8) and input(7);
col(52) <= input(12) and input(11) and not input(10) and input(9) and not input(8) and not input(7);
col(51) <= input(12) and input(11) and not input(10) and not input(9) and input(8) and input(7);
col(50) <= input(12) and input(11) and not input(10) and not input(9) and input(8) and not input(7);
col(49) <= input(12) and input(11) and not input(10) and not input(9) and not input(8) and input(7);
col(48) <= input(12) and input(11) and not input(10) and not input(9) and not input(8) and not input(7);
col(47) <= input(12) and not input(11) and input(10) and input(9) and input(8) and input(7);
col(46) <= input(12) and not input(11) and input(10) and input(9) and input(8) and not input(7);
col(45) <= input(12) and not input(11) and input(10) and input(9) and not input(8) and input(7);
col(44) <= input(12) and not input(11) and input(10) and input(9) and not input(8) and not input(7);
col(43) <= input(12) and not input(11) and input(10) and not input(9) and input(8) and input(7);
col(42) <= input(12) and not input(11) and input(10) and not input(9) and input(8) and not input(7);
col(41) <= input(12) and not input(11) and input(10) and not input(9) and not input(8) and input(7);
col(40) <= input(12) and not input(11) and input(10) and not input(9) and not input(8) and not input(7);
col(39) <= input(12) and not input(11) and not input(10) and input(9) and input(8) and input(7);
col(38) <= input(12) and not input(11) and not input(10) and input(9) and input(8) and not input(7);
col(37) <= input(12) and not input(11) and not input(10) and input(9) and not input(8) and input(7);
col(36) <= input(12) and not input(11) and not input(10) and input(9) and not input(8) and not input(7);
col(35) <= input(12) and not input(11) and not input(10) and not input(9) and input(8) and input(7);
col(34) <= input(12) and not input(11) and not input(10) and not input(9) and input(8) and not input(7);
col(33) <= input(12) and not input(11) and not input(10) and not input(9) and not input(8) and input(7);
col(32) <= input(12) and not input(11) and not input(10) and not input(9) and not input(8) and not input(7);
col(31) <= not input(12) and input(11) and input(10) and input(9) and input(8) and input(7);
col(30) <= not input(12) and input(11) and input(10) and input(9) and input(8) and not input(7);
col(29) <= not input(12) and input(11) and input(10) and input(9) and not input(8) and input(7);
col(28) <= not input(12) and input(11) and input(10) and input(9) and not input(8) and not input(7);
col(27) <= not input(12) and input(11) and input(10) and not input(9) and input(8) and input(7);
col(26) <= not input(12) and input(11) and input(10) and not input(9) and input(8) and not input(7);
col(25) <= not input(12) and input(11) and input(10) and not input(9) and not input(8) and input(7);
col(24) <= not input(12) and input(11) and input(10) and not input(9) and not input(8) and not input(7);
col(23) <= not input(12) and input(11) and not input(10) and input(9) and input(8) and input(7);
col(22) <= not input(12) and input(11) and not input(10) and input(9) and input(8) and not input(7);
col(21) <= not input(12) and input(11) and not input(10) and input(9) and not input(8) and input(7);
col(20) <= not input(12) and input(11) and not input(10) and input(9) and not input(8) and not input(7);
col(19) <= not input(12) and input(11) and not input(10) and not input(9) and input(8) and input(7);
col(18) <= not input(12) and input(11) and not input(10) and not input(9) and input(8) and not input(7);
col(17) <= not input(12) and input(11) and not input(10) and not input(9) and not input(8) and input(7);
col(16) <= not input(12) and input(11) and not input(10) and not input(9) and not input(8) and not input(7);
col(15) <= not input(12) and not input(11) and input(10) and input(9) and input(8) and input(7);
col(14) <= not input(12) and not input(11) and input(10) and input(9) and input(8) and not input(7);
col(13) <= not input(12) and not input(11) and input(10) and input(9) and not input(8) and input(7);
col(12) <= not input(12) and not input(11) and input(10) and input(9) and not input(8) and not input(7);
col(11) <= not input(12) and not input(11) and input(10) and not input(9) and input(8) and input(7);
col(10) <= not input(12) and not input(11) and input(10) and not input(9) and input(8) and not input(7);
col(9)  <= not input(12) and not input(11) and input(10) and not input(9) and not input(8) and input(7);
col(8)  <= not input(12) and not input(11) and input(10) and not input(9) and not input(8) and not input(7);
col(7)  <= not input(12) and not input(11) and not input(10) and input(9) and input(8) and input(7);
col(6)  <= not input(12) and not input(11) and not input(10) and input(9) and input(8) and not input(7);
col(5)  <= not input(12) and not input(11) and not input(10) and input(9) and not input(8) and input(7);
col(4)  <= not input(12) and not input(11) and not input(10) and input(9) and not input(8) and not input(7);
col(3)  <= not input(12) and not input(11) and not input(10) and not input(9) and input(8) and input(7);
col(2)  <= not input(12) and not input(11) and not input(10) and not input(9) and input(8) and not input(7);
col(1)  <= not input(12) and not input(11) and not input(10) and not input(9) and not input(8) and input(7);
col(0)  <= not input(12) and not input(11) and not input(10) and not input(9) and not input(8) and not input(7);

row(127) <= input(6) and input(5) and input(4) and input(3) and input(2) and input(1) and input(0);
row(126) <= input(6) and input(5) and input(4) and input(3) and input(2) and input(1) and not input(0);
row(125) <= input(6) and input(5) and input(4) and input(3) and input(2) and not input(1) and input(0);
row(124) <= input(6) and input(5) and input(4) and input(3) and input(2) and not input(1) and not input(0);
row(123) <= input(6) and input(5) and input(4) and input(3) and not input(2) and input(1) and input(0);
row(122) <= input(6) and input(5) and input(4) and input(3) and not input(2) and input(1) and not input(0);
row(121) <= input(6) and input(5) and input(4) and input(3) and not input(2) and not input(1) and input(0);
row(120) <= input(6) and input(5) and input(4) and input(3) and not input(2) and not input(1) and not input(0);
row(119) <= input(6) and input(5) and input(4) and not input(3) and input(2) and input(1) and input(0);
row(118) <= input(6) and input(5) and input(4) and not input(3) and input(2) and input(1) and not input(0);
row(117) <= input(6) and input(5) and input(4) and not input(3) and input(2) and not input(1) and input(0);
row(116) <= input(6) and input(5) and input(4) and not input(3) and input(2) and not input(1) and not input(0);
row(115) <= input(6) and input(5) and input(4) and not input(3) and not input(2) and input(1) and input(0);
row(114) <= input(6) and input(5) and input(4) and not input(3) and not input(2) and input(1) and not input(0);
row(113) <= input(6) and input(5) and input(4) and not input(3) and not input(2) and not input(1) and input(0);
row(112) <= input(6) and input(5) and input(4) and not input(3) and not input(2) and not input(1) and not input(0);
row(111) <= input(6) and input(5) and not input(4) and input(3) and input(2) and input(1) and input(0);
row(110) <= input(6) and input(5) and not input(4) and input(3) and input(2) and input(1) and not input(0);
row(109) <= input(6) and input(5) and not input(4) and input(3) and input(2) and not input(1) and input(0);
row(108) <= input(6) and input(5) and not input(4) and input(3) and input(2) and not input(1) and not input(0);
row(107) <= input(6) and input(5) and not input(4) and input(3) and not input(2) and input(1) and input(0);
row(106) <= input(6) and input(5) and not input(4) and input(3) and not input(2) and input(1) and not input(0);
row(105) <= input(6) and input(5) and not input(4) and input(3) and not input(2) and not input(1) and input(0);
row(104) <= input(6) and input(5) and not input(4) and input(3) and not input(2) and not input(1) and not input(0);
row(103) <= input(6) and input(5) and not input(4) and not input(3) and input(2) and input(1) and input(0);
row(102) <= input(6) and input(5) and not input(4) and not input(3) and input(2) and input(1) and not input(0);
row(101) <= input(6) and input(5) and not input(4) and not input(3) and input(2) and not input(1) and input(0);
row(100) <= input(6) and input(5) and not input(4) and not input(3) and input(2) and not input(1) and not input(0);
row(99)  <= input(6) and input(5) and not input(4) and not input(3) and not input(2) and input(1) and input(0);
row(98)  <= input(6) and input(5) and not input(4) and not input(3) and not input(2) and input(1) and not input(0);
row(97)  <= input(6) and input(5) and not input(4) and not input(3) and not input(2) and not input(1) and input(0);
row(96)  <= input(6) and input(5) and not input(4) and not input(3) and not input(2) and not input(1) and not input(0);
row(95)  <= input(6) and not input(5) and input(4) and input(3) and input(2) and input(1) and input(0);
row(94)  <= input(6) and not input(5) and input(4) and input(3) and input(2) and input(1) and not input(0);
row(93)  <= input(6) and not input(5) and input(4) and input(3) and input(2) and not input(1) and input(0);
row(92)  <= input(6) and not input(5) and input(4) and input(3) and input(2) and not input(1) and not input(0);
row(91)  <= input(6) and not input(5) and input(4) and input(3) and not input(2) and input(1) and input(0);
row(90)  <= input(6) and not input(5) and input(4) and input(3) and not input(2) and input(1) and not input(0);
row(89)  <= input(6) and not input(5) and input(4) and input(3) and not input(2) and not input(1) and input(0);
row(88)  <= input(6) and not input(5) and input(4) and input(3) and not input(2) and not input(1) and not input(0);
row(87)  <= input(6) and not input(5) and input(4) and not input(3) and input(2) and input(1) and input(0);
row(86)  <= input(6) and not input(5) and input(4) and not input(3) and input(2) and input(1) and not input(0);
row(85)  <= input(6) and not input(5) and input(4) and not input(3) and input(2) and not input(1) and input(0);
row(84)  <= input(6) and not input(5) and input(4) and not input(3) and input(2) and not input(1) and not input(0);
row(83)  <= input(6) and not input(5) and input(4) and not input(3) and not input(2) and input(1) and input(0);
row(82)  <= input(6) and not input(5) and input(4) and not input(3) and not input(2) and input(1) and not input(0);
row(81)  <= input(6) and not input(5) and input(4) and not input(3) and not input(2) and not input(1) and input(0);
row(80)  <= input(6) and not input(5) and input(4) and not input(3) and not input(2) and not input(1) and not input(0);
row(79)  <= input(6) and not input(5) and not input(4) and input(3) and input(2) and input(1) and input(0);
row(78)  <= input(6) and not input(5) and not input(4) and input(3) and input(2) and input(1) and not input(0);
row(77)  <= input(6) and not input(5) and not input(4) and input(3) and input(2) and not input(1) and input(0);
row(76)  <= input(6) and not input(5) and not input(4) and input(3) and input(2) and not input(1) and not input(0);
row(75)  <= input(6) and not input(5) and not input(4) and input(3) and not input(2) and input(1) and input(0);
row(74)  <= input(6) and not input(5) and not input(4) and input(3) and not input(2) and input(1) and not input(0);
row(73)  <= input(6) and not input(5) and not input(4) and input(3) and not input(2) and not input(1) and input(0);
row(72)  <= input(6) and not input(5) and not input(4) and input(3) and not input(2) and not input(1) and not input(0);
row(71)  <= input(6) and not input(5) and not input(4) and not input(3) and input(2) and input(1) and input(0);
row(70)  <= input(6) and not input(5) and not input(4) and not input(3) and input(2) and input(1) and not input(0);
row(69)  <= input(6) and not input(5) and not input(4) and not input(3) and input(2) and not input(1) and input(0);
row(68)  <= input(6) and not input(5) and not input(4) and not input(3) and input(2) and not input(1) and not input(0);
row(67)  <= input(6) and not input(5) and not input(4) and not input(3) and not input(2) and input(1) and input(0);
row(66)  <= input(6) and not input(5) and not input(4) and not input(3) and not input(2) and input(1) and not input(0);
row(65)  <= input(6) and not input(5) and not input(4) and not input(3) and not input(2) and not input(1) and input(0);
row(64)  <= input(6) and not input(5) and not input(4) and not input(3) and not input(2) and not input(1) and not input(0);
row(63)  <= not input(6) and input(5) and input(4) and input(3) and input(2) and input(1) and input(0);
row(62)  <= not input(6) and input(5) and input(4) and input(3) and input(2) and input(1) and not input(0);
row(61)  <= not input(6) and input(5) and input(4) and input(3) and input(2) and not input(1) and input(0);
row(60)  <= not input(6) and input(5) and input(4) and input(3) and input(2) and not input(1) and not input(0);
row(59)  <= not input(6) and input(5) and input(4) and input(3) and not input(2) and input(1) and input(0);
row(58)  <= not input(6) and input(5) and input(4) and input(3) and not input(2) and input(1) and not input(0);
row(57)  <= not input(6) and input(5) and input(4) and input(3) and not input(2) and not input(1) and input(0);
row(56)  <= not input(6) and input(5) and input(4) and input(3) and not input(2) and not input(1) and not input(0);
row(55)  <= not input(6) and input(5) and input(4) and not input(3) and input(2) and input(1) and input(0);
row(54)  <= not input(6) and input(5) and input(4) and not input(3) and input(2) and input(1) and not input(0);
row(53)  <= not input(6) and input(5) and input(4) and not input(3) and input(2) and not input(1) and input(0);
row(52)  <= not input(6) and input(5) and input(4) and not input(3) and input(2) and not input(1) and not input(0);
row(51)  <= not input(6) and input(5) and input(4) and not input(3) and not input(2) and input(1) and input(0);
row(50)  <= not input(6) and input(5) and input(4) and not input(3) and not input(2) and input(1) and not input(0);
row(49)  <= not input(6) and input(5) and input(4) and not input(3) and not input(2) and not input(1) and input(0);
row(48)  <= not input(6) and input(5) and input(4) and not input(3) and not input(2) and not input(1) and not input(0);
row(47)  <= not input(6) and input(5) and not input(4) and input(3) and input(2) and input(1) and input(0);
row(46)  <= not input(6) and input(5) and not input(4) and input(3) and input(2) and input(1) and not input(0);
row(45)  <= not input(6) and input(5) and not input(4) and input(3) and input(2) and not input(1) and input(0);
row(44)  <= not input(6) and input(5) and not input(4) and input(3) and input(2) and not input(1) and not input(0);
row(43)  <= not input(6) and input(5) and not input(4) and input(3) and not input(2) and input(1) and input(0);
row(42)  <= not input(6) and input(5) and not input(4) and input(3) and not input(2) and input(1) and not input(0);
row(41)  <= not input(6) and input(5) and not input(4) and input(3) and not input(2) and not input(1) and input(0);
row(40)  <= not input(6) and input(5) and not input(4) and input(3) and not input(2) and not input(1) and not input(0);
row(39)  <= not input(6) and input(5) and not input(4) and not input(3) and input(2) and input(1) and input(0);
row(38)  <= not input(6) and input(5) and not input(4) and not input(3) and input(2) and input(1) and not input(0);
row(37)  <= not input(6) and input(5) and not input(4) and not input(3) and input(2) and not input(1) and input(0);
row(36)  <= not input(6) and input(5) and not input(4) and not input(3) and input(2) and not input(1) and not input(0);
row(35)  <= not input(6) and input(5) and not input(4) and not input(3) and not input(2) and input(1) and input(0);
row(34)  <= not input(6) and input(5) and not input(4) and not input(3) and not input(2) and input(1) and not input(0);
row(33)  <= not input(6) and input(5) and not input(4) and not input(3) and not input(2) and not input(1) and input(0);
row(32)  <= not input(6) and input(5) and not input(4) and not input(3) and not input(2) and not input(1) and not input(0);
row(31)  <= not input(6) and not input(5) and input(4) and input(3) and input(2) and input(1) and input(0);
row(30)  <= not input(6) and not input(5) and input(4) and input(3) and input(2) and input(1) and not input(0);
row(29)  <= not input(6) and not input(5) and input(4) and input(3) and input(2) and not input(1) and input(0);
row(28)  <= not input(6) and not input(5) and input(4) and input(3) and input(2) and not input(1) and not input(0);
row(27)  <= not input(6) and not input(5) and input(4) and input(3) and not input(2) and input(1) and input(0);
row(26)  <= not input(6) and not input(5) and input(4) and input(3) and not input(2) and input(1) and not input(0);
row(25)  <= not input(6) and not input(5) and input(4) and input(3) and not input(2) and not input(1) and input(0);
row(24)  <= not input(6) and not input(5) and input(4) and input(3) and not input(2) and not input(1) and not input(0);
row(23)  <= not input(6) and not input(5) and input(4) and not input(3) and input(2) and input(1) and input(0);
row(22)  <= not input(6) and not input(5) and input(4) and not input(3) and input(2) and input(1) and not input(0);
row(21)  <= not input(6) and not input(5) and input(4) and not input(3) and input(2) and not input(1) and input(0);
row(20)  <= not input(6) and not input(5) and input(4) and not input(3) and input(2) and not input(1) and not input(0);
row(19)  <= not input(6) and not input(5) and input(4) and not input(3) and not input(2) and input(1) and input(0);
row(18)  <= not input(6) and not input(5) and input(4) and not input(3) and not input(2) and input(1) and not input(0);
row(17)  <= not input(6) and not input(5) and input(4) and not input(3) and not input(2) and not input(1) and input(0);
row(16)  <= not input(6) and not input(5) and input(4) and not input(3) and not input(2) and not input(1) and not input(0);
row(15)  <= not input(6) and not input(5) and not input(4) and input(3) and input(2) and input(1) and input(0);
row(14)  <= not input(6) and not input(5) and not input(4) and input(3) and input(2) and input(1) and not input(0);
row(13)  <= not input(6) and not input(5) and not input(4) and input(3) and input(2) and not input(1) and input(0);
row(12)  <= not input(6) and not input(5) and not input(4) and input(3) and input(2) and not input(1) and not input(0);
row(11)  <= not input(6) and not input(5) and not input(4) and input(3) and not input(2) and input(1) and input(0);
row(10)  <= not input(6) and not input(5) and not input(4) and input(3) and not input(2) and input(1) and not input(0);
row(9)   <= not input(6) and not input(5) and not input(4) and input(3) and not input(2) and not input(1) and input(0);
row(8)   <= not input(6) and not input(5) and not input(4) and input(3) and not input(2) and not input(1) and not input(0);
row(7)   <= not input(6) and not input(5) and not input(4) and not input(3) and input(2) and input(1) and input(0);
row(6)   <= not input(6) and not input(5) and not input(4) and not input(3) and input(2) and input(1) and not input(0);
row(5)   <= not input(6) and not input(5) and not input(4) and not input(3) and input(2) and not input(1) and input(0);
row(4)   <= not input(6) and not input(5) and not input(4) and not input(3) and input(2) and not input(1) and not input(0);
row(3)   <= not input(6) and not input(5) and not input(4) and not input(3) and not input(2) and input(1) and input(0);
row(2)   <= not input(6) and not input(5) and not input(4) and not input(3) and not input(2) and input(1) and not input(0);
row(1)   <= not input(6) and not input(5) and not input(4) and not input(3) and not input(2) and not input(1) and input(0);
row(0)  <= not input(6) and not input(5) and not input(4) and not input(3) and not input(2) and not input(1) and not input(0);


-- generates each bit of the decoder result
-- see two-level decoder block diagram
coarse: for i in g_k - 1 downto 0 generate -- generate columns
  fine: for j in g_q - 1 downto 0 generate -- generate rows
    result((g_q * i) + j) <= col(i) and row(j);
  end generate fine;
end generate coarse;

output <= result;
end;