----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2019 00:03:17
-- Design Name: 
-- Module Name: data_path - Behavioral
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

entity data_path is
  Port (
        clk, reset: in std_logic; 
        control: in std_logic_vector (6 downto 0);
        contadores_igual: out std_logic; 
        finSec5seg: out std_logic;
        r: out std_logic_vector (7 downto 0);
        led:out std_logic_vector (15 downto 0)
        );
end data_path;
   
architecture Behavioral of data_path is

    component CONTADOR
       port ( 
          clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          enable: in STD_LOGIC;
          salida : out STD_LOGIC_VECTOR (3 downto 0)
          );
    end component CONTADOR;
    
    component Divisor
        port(
            rst: in STD_LOGIC;
            clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
            Cuenta_medio_segundo: out STD_LOGIC; 
            Cuenta_display1: out STD_LOGIC;
            Cuenta_display2: out STD_LOGIC
            );
    end component Divisor;
    
    component generador_Secuencia
        port(
          rst : in STD_LOGIC;
          clk : in STD_LOGIC;
          eleccion : in STD_LOGIC_VECTOR(1 downto 0);
          leds : out STD_LOGIC_VECTOR (15 downto 0)
          );
    end component generador_Secuencia;
    
    signal control_aux: std_logic_vector(6 downto 0);
    alias mux_sec : std_logic_vector is control_aux(1 downto 0);
    alias enable_d1 : std_logic is control_aux(2);
    alias enable_d2 : std_logic is control_aux(3);
    alias enable_5seg : std_logic is control_aux(4);
    alias reset_d1 : std_logic is control_aux(5);
    alias reset_d2 : std_logic is control_aux(6);
    
    signal cuenta1 :std_logic_vector (3 downto 0);
    signal cuenta2 :std_logic_vector (3 downto 0);
    signal cuenta5seg :std_logic_vector (3 downto 0);
    
    signal clk_d1:std_logic;
    signal clk_d2:std_logic;
    signal clk_5seg:std_logic;
    
    
begin

    control_aux <= control;
    
    d_div: Divisor port map(reset,clk,clk_5seg,clk_d1,clk_d2);
    contador_d1: CONTADOR port map(clk_d1,reset_d1,enable_d1,cuenta1); -- cambiar el clk por la salida del divisor.
    contador_d2: CONTADOR port map(clk_d2,reset_d2,enable_d2,cuenta2);
    contador_5seg: CONTADOR port map(clk_5seg,reset,enable_5seg,cuenta5seg);
    gen_Sec: generador_Secuencia port map(reset,clk_5seg,mux_sec,led);
    
    contadores_igual<='1' when cuenta1=cuenta2 else '0';
    finSec5seg<='1' when cuenta5seg = "1001" else '0';
    r <= cuenta2 & cuenta1;
    
end Behavioral;
