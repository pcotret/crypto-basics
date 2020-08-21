-- File:        tea_base_decrypt.vhdl
-- Author:      Pascal Cotret <pascal.cotret@ensta-bretagne.fr>
-- Description: Basic operation for TEA decryption

-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.all;

-- Entity
entity tea_base_decrypt is
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
end entity tea_base_decrypt;

-- Architecture
architecture bhv of tea_base_decrypt is
-- Signals for word encryption
signal xor_b1_temp1   : std_logic_vector(31 downto 0);
signal xor_b1_temp2   : std_logic_vector(31 downto 0);
signal xor_b1_temp3   : std_logic_vector(31 downto 0);
signal xor_b1_temp4   : std_logic_vector(31 downto 0);
-- Components declaration
component shift_comp is
generic(LENGTH:natural:=4);
port(clk_in       : in std_logic;
     key_in       : in std_logic_vector(31 downto 0);
     direction_in : in std_logic;
     data_in      : in std_logic_vector(31 downto 0);
     data_out     : out std_logic_vector(31 downto 0)
    );
end component shift_comp;   
component sum_delta_decrypt is
port(clk_in      : in  std_logic;
     sum_in      : in  std_logic_vector(31 downto 0);
     data_in     : in  std_logic_vector(31 downto 0);
     data_sum_in : in  std_logic_vector(31 downto 0);
     data_out    : out std_logic_vector(31 downto 0);
     sum_out     : out std_logic_vector(31 downto 0)
    );
end component sum_delta_decrypt; 
begin
    -- Components mapping
    uut_l1:shift_comp
    generic map(LENGTH => SHIFT_L)
    port map(clk_in       => clk_in,
             key_in       => full_key_in2,
             direction_in => '0', -- Shift left
             data_in      => data_word_in1,
             data_out     => xor_b1_temp1
            );
    uut_sum_delta1:sum_delta_decrypt
    port map(clk_in      => clk_in,
             sum_in      => sum_in,
             data_in     => x"9E3779B9",
             data_sum_in => data_sum_in,
             data_out    => xor_b1_temp2,
             sum_out     => sum_out
            );
    uut_r1:shift_comp
    generic map(LENGTH => SHIFT_R)
    port map(clk_in       => clk_in,
             key_in       => full_key_in3,
             direction_in => '1', -- Shift right
             data_in      => data_word_in1,
             data_out     => xor_b1_temp3
            );
    xor_b1_temp4   <= xor_b1_temp1 xor xor_b1_temp2 xor xor_b1_temp3; 
    data_word_out0 <= std_logic_vector(unsigned(data_add_in) - unsigned(xor_b1_temp4));
end architecture bhv;