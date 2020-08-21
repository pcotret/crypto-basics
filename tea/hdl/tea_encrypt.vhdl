-- File:        tea_encrypt.vhdl
-- Author:      Pascal Cotret <pascal.cotret@ensta-bretagne.fr>
-- Description: TEA encryption core

-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.all;

-- Entity
entity tea_encrypt is
port(clk_in         : in  std_logic;                     -- Clock
     full_key_in0   : in  std_logic_vector(31 downto 0); -- Key word #0
     full_key_in1   : in  std_logic_vector(31 downto 0); -- Key word #1
     full_key_in2   : in  std_logic_vector(31 downto 0); -- Key word #2
     full_key_in3   : in  std_logic_vector(31 downto 0); -- Key word #3
     data_word_in0  : in  std_logic_vector(31 downto 0); -- Plaintext word #0
     data_word_in1  : in  std_logic_vector(31 downto 0); -- Plaintext word #1
     data_word_out0 : out std_logic_vector(31 downto 0); -- Ciphertext word #0
     data_word_out1 : out std_logic_vector(31 downto 0)  -- Ciphertext word #1
    );
end entity tea_encrypt;

-- Architecture
architecture bhv of tea_encrypt is
-- Arrays of 32-bit words to connect data between encryption rounds 
type array_conn is array(0 to 30) of std_logic_vector(31 downto 0);
signal sum_interconnect   : array_conn;
signal data0_interconnect : array_conn;
signal data1_interconnect : array_conn;
-- Signals declaration
signal data_word_temp0    : std_logic_vector(31 downto 0);
signal data_word_temp1    : std_logic_vector(31 downto 0);
signal sum_temp           : std_logic_vector(31 downto 0);
-- Components declaration
-- Top-level of a TEA encryption round
component tea_top is
    port(clk_in         : in  std_logic;
         full_key_in0   : in  std_logic_vector(31 downto 0);
         full_key_in1   : in  std_logic_vector(31 downto 0);
         full_key_in2   : in  std_logic_vector(31 downto 0);
         full_key_in3   : in  std_logic_vector(31 downto 0);
         sum_in         : in  std_logic_vector(31 downto 0);
         data_word_in0  : in  std_logic_vector(31 downto 0);
         data_word_in1  : in  std_logic_vector(31 downto 0);
         data_word_out0 : out std_logic_vector(31 downto 0);
         data_word_out1 : out std_logic_vector(31 downto 0);
         sum_out        : out std_logic_vector(31 downto 0)
   );
end component;
begin
-- Components mapping
    -- First round
    uut_0:tea_top
    port map(clk_in         => clk_in,
             full_key_in0   => full_key_in0,
             full_key_in1   => full_key_in1,
             full_key_in2   => full_key_in2,
             full_key_in3   => full_key_in3,
             sum_in         => (others => '0'),
             data_word_in0  => data_word_in0,
             data_word_in1  => data_word_in1,
             data_word_out0 => data0_interconnect(0),
             data_word_out1 => data1_interconnect(0),
             sum_out        => sum_interconnect(0)   
            );
    -- 30 intermediate rounds
    INTER_ROUND: 
    for I in 0 to 29 generate
    TEAX : tea_top
    port map(clk_in         => clk_in,
             full_key_in0   => full_key_in0,
             full_key_in1   => full_key_in1,
             full_key_in2   => full_key_in2,
             full_key_in3   => full_key_in3,
             sum_in         => sum_interconnect(I),
             data_word_in0  => data0_interconnect(I),
             data_word_in1  => data1_interconnect(I),
             data_word_out0 => data0_interconnect(I+1),
             data_word_out1 => data1_interconnect(I+1),
             sum_out        => sum_interconnect(I+1));
    end generate INTER_ROUND;
    -- Last round
    uut_1:tea_top
    port map(clk_in         => clk_in,
             full_key_in0   => full_key_in0,
             full_key_in1   => full_key_in1,
             full_key_in2   => full_key_in2,
             full_key_in3   => full_key_in3,
             sum_in         => sum_interconnect(30),
             data_word_in0  => data0_interconnect(30),
             data_word_in1  => data1_interconnect(30),
             data_word_out0 => data_word_out0,
             data_word_out1 => data_word_out1,
             sum_out        => open
            );
end architecture bhv;