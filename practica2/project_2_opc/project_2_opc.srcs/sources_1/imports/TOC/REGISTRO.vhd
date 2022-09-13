----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.09.2019 11:24:23
-- Design Name: 
-- Module Name: REGISTRO - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity REGISTRO is
    Port ( 
       E : in STD_LOGIC_VECTOR (3 downto 0);
       load : in STD_LOGIC;
       clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       S : out STD_LOGIC_VECTOR (3 downto 0)
    );
end REGISTRO;

architecture Behavioral of REGISTRO is


begin
    process(clk, rst)
    begin
        if(rst = '1') then
                S <= "0000";
        elsif(rising_edge(clk)) then
            if (load = '1') then
                S <= E;
            end if;
        end if;
    end process;


end Behavioral;
