-- File:        tea_top_decrypt.vhdl
-- Author:      Pascal Cotret <pascal.cotret@ensta-bretagne.fr>
-- Description: TEA decryption round

-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.all;

-- Entity
entity tea_top_decrypt is
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
end entity tea_top_decrypt;

-- Architecture
architecture bhv of tea_top_decrypt is
signal data_word_temp : std_logic_vector(31 downto 0);
signal sum_out_temp0  : std_logic_vector(31 downto 0);
signal sum_out_temp1  : std_logic_vector(31 downto 0);
component tea_base_decrypt is
generic(SHIFT_L : natural := 4;
        SHIFT_R : natural := 5
       );   
port(clk_in         : in  std_logic;
     full_key_in2   : in  std_logic_vector(31 downto 0);
     full_key_in3   : in  std_logic_vector(31 downto 0);
     sum_in         : in  std_logic_vector(31 downto 0);
     data_add_in    : in  std_logic_vector(31 downto 0);
     data_sum_in    : in  std_logic_vector(31 downto 0);
     data_word_in0  : in  std_logic_vector(31 downto 0);
     data_word_in1  : in  std_logic_vector(31 downto 0);
     data_word_out0 : out std_logic_vector(31 downto 0);
     sum_out        : out std_logic_vector(31 downto 0)
    );
end component tea_base_decrypt;
begin
    -- Encrypt first word
    uut_0:tea_base_decrypt
    generic map(SHIFT_L => 4,
                SHIFT_R => 5)
    port map(clk_in         => clk_in,
             full_key_in2   => full_key_in2,
             full_key_in3   => full_key_in3,
             sum_in         => sum_in,
             data_add_in    => data_word_in1,
             data_sum_in    => data_word_in0,
             data_word_in0  => data_word_in1,
             data_word_in1  => data_word_in0,
             data_word_out0 => data_word_temp,
             sum_out        => sum_out_temp0
            );
    -- Encrypt second word
    uut_1:tea_base_decrypt
    generic map(SHIFT_L => 4,
                SHIFT_R => 5)
    port map(clk_in         => clk_in,
             full_key_in2   => full_key_in0,
             full_key_in3   => full_key_in1,
             sum_in         => sum_in,
             data_add_in    => data_word_in0,
             data_sum_in    => data_word_temp,
             data_word_in0  => data_word_in1,
             data_word_in1  => data_word_temp,
             data_word_out0 => data_word_out1,
             sum_out        => sum_out_temp1
            );
    data_word_out0 <= data_word_temp;
    sum_out        <= sum_out_temp0 and sum_out_temp1;
end architecture bhv;