
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CONTADOR is
    Port ( 
          clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          enable: in STD_LOGIC;
          salida : out STD_LOGIC_VECTOR (3 downto 0));
          
end CONTADOR;

architecture Behavioral of CONTADOR is

    signal yout: STD_LOGIC_VECTOR (3 downto 0):=(OTHERS=>'0');
    
begin

    process(clk,rst)
        begin
        
           IF (rst='1') THEN
               yout<= (OTHERS=>'0');
               
           ELSIF(rising_edge(clk)) THEN
           
                if(enable='1')then
                    yout<=yout+1;
                end if;
                if(yout="1001") then 
                    yout<= (OTHERS=>'0');
                    
                end if;
           END IF;
           
    end process;
    
    salida<=yout;
    
end Behavioral;
