----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2019 01:26:47
-- Design Name: 
-- Module Name: ASM - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ASM is
  Port (
  rst,clk,inicio,fin:in std_logic;
  led:out std_logic_vector(15 downto 0);
  r :out std_logic_vector(6 downto 0);
  an: out std_logic_vector(3 downto 0)
  );
end ASM;

architecture Behavioral of ASM is
    component controller
        port (
            clk, reset, init,fin: in std_logic; 
            contadores_igual: in std_logic;
            finSec5seg: in std_logic; 
            control: out std_logic_vector (6 downto 0)
            );
    end component controller;
    
    component data_path
        port (
        clk, reset: in std_logic; 
        control: in std_logic_vector (6 downto 0);
        contadores_igual: out std_logic; 
        finSec5seg: out std_logic;
        r: out std_logic_vector (7 downto 0);
        led: out std_logic_vector (15 downto 0)
        );
    end component data_path;
    
    component displays
    port ( 
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;       
        digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_2 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_3 : in  STD_LOGIC_VECTOR (3 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
     );
    end component displays;
    
    component debouncer
    port( rst: IN std_logic;
    clk: IN std_logic;
    x: IN std_logic;
    xDeb: OUT std_logic;
    xDebFallingEdge: OUT std_logic;
    xDebRisingEdge: OUT std_logic);
    end component;
    
    signal contadores_igual: std_logic;
    signal finSec5seg: std_logic;
    signal control: std_logic_vector (6 downto 0);
    signal sol: std_logic_vector(7 downto 0);
    signal rb : std_logic;
    signal rc : std_logic;
begin

    debouncer_debIni: debouncer port map(rst,clk,inicio,open,open,rb);
    debouncer_debFin: debouncer port map(rst,clk,fin,open,open,rc);
    controller_c : controller port map(clk,rst,rb,rc,contadores_igual,finSec5seg,control);
    data_patht_path: data_path port map(clk,rst,control,contadores_igual,finSec5seg,sol,led);
    display_d: displays port map ( rst, clk,sol(3 downto 0),sol(7 downto 4),"0000","0000",r, an);

end Behavioral;
