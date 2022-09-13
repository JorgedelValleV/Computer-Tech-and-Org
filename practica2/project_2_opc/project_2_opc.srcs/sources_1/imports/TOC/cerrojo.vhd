----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.10.2019 09:21:41
-- Design Name: 
-- Module Name: cerrojo - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cerrojo is
    Port ( clave : in STD_LOGIC_VECTOR (7 downto 0);
           num : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           boton : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (15 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an: out STD_LOGIC_VECTOR (3 downto 0));
end cerrojo;

architecture Behavioral of cerrojo is

type tipo_estado is (inicial, bloqueado, final);
    component conv_7seg
        port( x : in  STD_LOGIC_VECTOR (3 downto 0); display : out  STD_LOGIC_VECTOR (6 downto 0));
    end component;
    component debouncer
        port(rst: in std_logic;clk: in std_logic; x: in std_logic; xDeb: out std_logic; xDebFallingEdge: out std_logic; xDebRisingEdge: out std_logic);
    end component;
    component REGISTRO
        port (E : in STD_LOGIC_VECTOR (3 downto 0);load : in STD_LOGIC;clk : in STD_LOGIC;rst : in STD_LOGIC; S : out STD_LOGIC_VECTOR (3 downto 0)
    );
    end component;
    component Divisor
        port(rst , clk_entrada : in STD_LOGIC; clk_salida : out STD_LOGIC);
    end component;

	signal estadoActual, estadoSiguiente : tipo_estado;
	
	signal password, passwordSig : std_logic_vector(7 downto 0);
	signal contador, contadorSiguiente : std_logic_vector(3 downto 0);
    
    signal rd : std_logic;
    signal dout : std_logic;
    signal load : std_logic;
    signal rout: std_logic_vector(3 downto 0);
begin
	an <= "1110";
	mod_c:conv_7seg port map(contador , seg);
    mod_s:debouncer port map(rst,clk, boton,open, open, rd);
    mod_r:REGISTRO port map(num ,load, clk , rst, rout);
    mod_d:Divisor port map(rst,clk,dout);
    
	SYNC: process(clk, rst)
	begin
		if (rst = '1') then
			estadoActual <= inicial;
			contador <= (others => '0');
		elsif rising_edge(clk) then
			estadoActual <= estadoSiguiente;
			password <= passwordSig;
			contador <= contadorSiguiente;
		end if;
	end process SYNC;
	
	COMB: process(estadoActual, rd,clave,password,num,contador, dout)
	begin
	
		estadoSiguiente 				<= estadoActual;
		passwordSig                  <= password;
		contadorSiguiente 			<= contador;
		led  					        <= (others => '0');
		

		case estadoActual is
		
			when inicial =>
			    led  					        <= (others => '1');
			    
			    if(rd='1' and num/="0000") then 
		            passwordSig <= clave;
				    estadoSiguiente <= bloqueado;
				    contadorSiguiente <= num;	
				end if;
				
			when bloqueado =>
			     led  					        <= (others => '0');
				if (rd='1' and (password = clave)) then
					estadoSiguiente <= inicial;
					contadorSiguiente <= (others => '0');
                elsif (rd='1' and password /= clave) then
				    contadorSiguiente <= contador - 1;	
				end if;	
				if (contador="0000") then
				    estadoSiguiente <= final;
			    end if;
			when final =>
			     if (dout='1') then
			         led  					        <= (others => '1');
			     else 
			         led  					        <= (others => '0');
			     end if;
			    		
		end case;
	end process COMB;


end Behavioral;
