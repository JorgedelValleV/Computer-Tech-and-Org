----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2019 23:44:45
-- Design Name: 
-- Module Name: controller - Behavioral
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

entity controller is
  Port ( 
        clk, reset, init,fin: in std_logic; 
        contadores_igual: in std_logic;
        finSec5seg: in std_logic; 
        control: out std_logic_vector (6 downto 0) 
        );
end controller;

architecture Behavioral of controller is
    type T_STATE is (S0, S1, S2, S3,S4);
    signal STATE, NEXT_STATE: T_STATE;
    
    signal control_aux: std_logic_vector(6 downto 0);
    alias mux_sec : std_logic_vector is control_aux(1 downto 0);
    alias enable_d1 : std_logic is control_aux(2);
    alias enable_d2 : std_logic is control_aux(3);
    alias enable_5seg : std_logic is control_aux(4);
    alias reset_d1 : std_logic is control_aux(5);
    alias reset_d2 : std_logic is control_aux(6);

begin
    control <= control_aux;
    SYNC_STATE: process (clk, reset)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                STATE <= S0;
            else 
                STATE <= NEXT_STATE;
            end if;
        end if;
    end process SYNC_STATE;

    COMB: process (STATE, init, fin, contadores_igual,finSec5seg)
    begin
       enable_d1<='0';
       enable_d2<='0'; 
       enable_5seg<='0';
       reset_d1<='0';
       reset_d2<='0';
       mux_sec<="00"; 
       case STATE is
       
            when S0 =>
                mux_sec<="01";
                reset_d1<='1';
                reset_d2<='1';
                if(init='1') then 
                    NEXT_STATE <=S1;
                else
                    NEXT_STATE <=S0;
                end if;
                
            when S1 =>
            
                enable_d1<='1';
                enable_d2<='1'; 
                mux_sec<="00"; 
                
                if(fin='1') then 
                    NEXT_STATE <= S2;
                else NEXT_STATE <=S1;
                end if;
                
            when S2 =>
                if (contadores_igual ='1') then
                    NEXT_STATE <= S3;
                else
                    NEXT_STATE <= S4;
                end if; 
                
            when S3 =>
            
                enable_5seg<='1';
                mux_sec<="10";
                 
                if (finSec5seg ='1') then
                    NEXT_STATE <= S0;
                else
                    NEXT_STATE <= S3;
                end if; 
            when S4 =>
            
                enable_5seg<='1';
                mux_sec<="11";
                
               if (finSec5seg ='1') then
                    NEXT_STATE <= S0;
                else
                    NEXT_STATE <= S4;
                end if; 
                
         end case;
      end process COMB;
end Behavioral;
