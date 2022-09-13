----------------------------------------------------------------------------------
-- Company: Universidad Complutense de Madrid
-- Engineer: Hortensia Mecha
-- 
-- Design Name: divisor 
-- Module Name:    divisor - divisor_arch 
-- Project Name: 
-- Target Devices: 
-- Description: Creaci?n de un reloj de 1Hz a partir de
--		un clk de 100 MHz
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;

entity Divisor is
    port (
        rst: in STD_LOGIC;
        clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
        Cuenta_medio_segundo: out STD_LOGIC; 
        Cuenta_display1: out STD_LOGIC;
        Cuenta_display2: out STD_LOGIC
    );
end Divisor;

architecture divisor_arch of Divisor is
 SIGNAL cuenta: std_logic_vector(25 downto 0);
 SIGNAL Cuenta_ms_aux: std_logic;
 SIGNAL Cuenta_display1_aux: std_logic;
 SIGNAL Cuenta_display2_aux: std_logic;

 begin
Cuenta_medio_segundo<=Cuenta_ms_aux;
Cuenta_display1<=Cuenta_display1_aux; 
Cuenta_display2<=Cuenta_display2_aux;
  contador:
  PROCESS(rst, clk_entrada)
  BEGIN
    IF (rst='1') THEN
      cuenta<= (OTHERS=>'0');
      Cuenta_ms_aux<='0';
      Cuenta_display1_aux<='0';
      Cuenta_display2_aux<='0';
    ELSIF(rising_edge(clk_entrada)) THEN
      IF (cuenta(3 downto 0) = "1110") THEN 
      	Cuenta_display1_aux<='1';
      ELSE
	   Cuenta_display1_aux<='0';
      END IF;
      IF (cuenta(3 downto 0) = "1001") THEN 
      	Cuenta_display2_aux<='1';
      ELSE
	   Cuenta_display2_aux<='0';
      END IF;
      IF (cuenta="11111111111111111111111111") THEN 
      	Cuenta_ms_aux<='1';
        cuenta<= (OTHERS=>'0');
      ELSE
        cuenta <= cuenta+'1';
	    Cuenta_ms_aux<='0';
      END IF;
    END IF;
  END PROCESS contador;

end divisor_arch;