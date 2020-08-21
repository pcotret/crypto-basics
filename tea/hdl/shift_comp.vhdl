-- File:        shift_comp.vhdl
-- Author:      Pascal Cotret <pascal.cotret@ensta-bretagne.fr>
-- Description: Component for left/right shifting of data (shift length is configurable)
--              In the TEA algorithm, it is used to perform 4 operations :
--              ((z<<4) + k[0]) and ((z>>5) + k[1])
--              ((y<<4) + k[2]) and ((y>>5) + k[3])

-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Entity
entity shift_comp is
generic(LENGTH:natural:=4);                            -- Shift length
port(clk_in       : in  std_logic;                     -- Clock
     key_in       : in  std_logic_vector(31 downto 0); -- Key input (added to the shifted data)
     direction_in : in  std_logic;                     -- Shift direction: 1 for right, 0 for left
     data_in      : in  std_logic_vector(31 downto 0); -- Data input (to be shifted)
     data_out     : out std_logic_vector(31 downto 0)  -- Data output
    );
end entity shift_comp;

-- Architecture
architecture bhv of shift_comp is
signal shift_data_s : std_logic_vector(31 downto 0) := (others => '0');
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if direction_in='1' then
                shift_data_s <= std_logic_vector(shift_right(unsigned(data_in),LENGTH));
            else
                shift_data_s <= std_logic_vector(shift_left(unsigned(data_in),LENGTH));
            end if;
        end if;
    end process;
    data_out <= std_logic_vector(unsigned(key_in) + unsigned(shift_data_s));
end architecture bhv;