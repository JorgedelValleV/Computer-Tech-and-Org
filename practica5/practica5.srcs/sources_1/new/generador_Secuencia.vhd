library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity generador_Secuencia is
    Port ( 
          rst : in STD_LOGIC;
          clk : in STD_LOGIC;
          eleccion : in STD_LOGIC_VECTOR(1 downto 0);
          leds : out STD_LOGIC_VECTOR (15 downto 0)
          );
          
end generador_Secuencia;

architecture Behavioral of generador_Secuencia is
    

    signal sec_0 : STD_LOGIC_VECTOR (15 downto 0):= "0000000000000000";
    signal sec_1 : STD_LOGIC_VECTOR (15 downto 0):= "0000000000000000";
    signal sec_2 : STD_LOGIC_VECTOR (15 downto 0):= "1010101010101010";
    signal sec_3 : STD_LOGIC_VECTOR (31 downto 0) := "11111111111111110000000000000000";
    

begin

    leds<=  sec_0 when (eleccion = "00") else
                sec_1 when (eleccion = "10") else
                sec_2 when (eleccion = "11") else
                sec_3(15 downto 0);

    process(clk,rst)
    begin
        IF (rst='1') THEN
      		sec_0 <= "0000000000000000";-- jugando
            sec_1 <= "0000000000000000";-- ganar
            sec_2 <= "1010101010101010";-- perder
            sec_3 <= "11111111111111110000000000000000"; -- esperar
    	ELSIF(rising_edge(clk)) THEN
      		sec_1<= not sec_1;
      		
		    sec_2<= not sec_2;
		    
		    sec_3(30 downto  0)<= sec_3(31 downto  1);
		    sec_3(31)<= sec_3(0);
    	END IF;
    end process;
end Behavioral;

