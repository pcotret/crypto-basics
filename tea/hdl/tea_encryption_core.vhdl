-- File:        tea_encryption_core.vhdl
-- Author:      Pascal Cotret <pascal.cotret@ensta-bretagne.fr>
-- Description: Top-level of the encryption-then-decryption TEA algorithm

-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.all;

-- Entity
entity tea_encryption_core is
port(clk_in         : in  std_logic;                     -- Clock
     full_key_in0   : in  std_logic_vector(31 downto 0); -- Key word #0
     full_key_in1   : in  std_logic_vector(31 downto 0); -- Key word #1
     full_key_in2   : in  std_logic_vector(31 downto 0); -- Key word #2
     full_key_in3   : in  std_logic_vector(31 downto 0); -- Key word #3
     data_word_in0  : in  std_logic_vector(31 downto 0); -- Plaintext word #0
     data_word_in1  : in  std_logic_vector(31 downto 0); -- Plaintext word #1
     data_word_out0 : out std_logic_vector(31 downto 0); -- Encrypted-then-decrypted word #0
     data_word_out1 : out std_logic_vector(31 downto 0)  -- Encrypted-then-decrypted word #1
    );
end entity tea_encryption_core;

-- Architecture
architecture bhv of tea_encryption_core is
signal data_word_temp0 : std_logic_vector(31 downto 0); -- Encrypted word #0
signal data_word_temp1 : std_logic_vector(31 downto 0); -- Encrypted word #1
-- Components declaration
-- Decryption core
component tea_decrypt is
    port(clk_in         : in  std_logic;
         full_key_in0   : in  std_logic_vector(31 downto 0);
         full_key_in1   : in  std_logic_vector(31 downto 0);
         full_key_in2   : in  std_logic_vector(31 downto 0);
         full_key_in3   : in  std_logic_vector(31 downto 0);
         data_word_in0  : in  std_logic_vector(31 downto 0);
         data_word_in1  : in  std_logic_vector(31 downto 0);
         data_word_out0 : out std_logic_vector(31 downto 0);
         data_word_out1 : out std_logic_vector(31 downto 0)
        );
end component;
-- Encryption core
component tea_encrypt is
port(clk_in         : in  std_logic;
     full_key_in0   : in  std_logic_vector(31 downto 0);
     full_key_in1   : in  std_logic_vector(31 downto 0);
     full_key_in2   : in  std_logic_vector(31 downto 0);
     full_key_in3   : in  std_logic_vector(31 downto 0);
     data_word_in0  : in  std_logic_vector(31 downto 0);
     data_word_in1  : in  std_logic_vector(31 downto 0);
     data_word_out0 : out std_logic_vector(31 downto 0);
     data_word_out1 : out std_logic_vector(31 downto 0)
    );
end component;
begin
-- Components mapping
uut_encrypt:tea_encrypt
            port map(clk_in         => clk_in,      
                     full_key_in0   => full_key_in0,
                     full_key_in1   => full_key_in1,
                     full_key_in2   => full_key_in2,
                     full_key_in3   => full_key_in3,
                     data_word_in0  => data_word_in0,
                     data_word_in1  => data_word_in1,
                     data_word_out0 => data_word_temp0,
                     data_word_out1 => data_word_temp1
                    );
uut_decrypt:tea_decrypt
port map(clk_in         => clk_in,      
         full_key_in0   => full_key_in0,
         full_key_in1   => full_key_in1,
         full_key_in2   => full_key_in2,
         full_key_in3   => full_key_in3,
         data_word_in0  => data_word_temp0,
         data_word_in1  => data_word_temp1,
         data_word_out0 => data_word_out0,
         data_word_out1 => data_word_out1
        );
end architecture bhv;