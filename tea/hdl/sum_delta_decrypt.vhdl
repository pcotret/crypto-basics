-- File:        sum_delta_decrypt.vhdl
-- Author:      Pascal Cotret <pascal.cotret@ensta-bretagne.fr>
-- Description: Performing sum-=delta for decryption

-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sum_delta_decrypt is
port(clk_in       : in  std_logic;
     sum_in       : in  std_logic_vector(31 downto 0); -- Initial value of sum (0 for the first round)
     data_in      : in  std_logic_vector(31 downto 0); -- delta constant in the C implementation (0x9E3779B9)
     data_sum_in  : in  std_logic_vector(31 downto 0); -- Text word (z+sum or y+sum)
     data_out     : out std_logic_vector(31 downto 0); -- Result word
     sum_out      : out std_logic_vector(31 downto 0)  -- Result of sum-delta (connecte to sum_in in the next round)
    );
end entity sum_delta_decrypt;
architecture bhv of sum_delta_decrypt is
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            data_out <= std_logic_vector(unsigned(sum_in)+unsigned(data_sum_in));
            sum_out  <= std_logic_vector(unsigned(sum_in)-unsigned(data_in));
        end if;
    end process;
end architecture bhv;