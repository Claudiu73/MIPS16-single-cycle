----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2023 19:00:33
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
Port 
(
signal digits: in std_logic_vector(15 downto 0);
signal clk: in std_logic;
signal an:out std_logic_vector(7 downto 0);
signal cat:out std_logic_vector(6 downto 0)
 );
end SSD;

architecture Behavioral of SSD is
signal counter: std_logic_vector(15 downto 0):=(others=>'0');
signal digit: std_logic_vector(3 downto 0); 
signal sel: std_logic_vector(1 downto 0);
begin

process(clk)
begin
if clk='1' and clk'event then
    counter<=counter+1;
end if;
end process;

sel<=counter(15 downto 14);

process(digits, sel)
begin

case sel is

when "00"=>digit<=digits(3 downto 0);
when "01"=>digit<=digits(7 downto 4);
when "10"=>digit<=digits(11 downto 8);
when "11"=>digit<=digits(15 downto 12);
when others=>digit<=(others => 'X');
end case;
end process;

process(sel)
begin 
case sel is
when"00"=> an<="11111110"; 
when"01"=> an<="11111101"; 
when"10"=> an<="11111011"; 
when"11"=> an<="11110111"; 
when others=>an<=(others=>'X'); 
end case;
end process;

process(digit)
begin
case digit is

when "0000"=>cat<=not("0111111"); -- 0
when "0001"=>cat<=not("0000110"); -- 1
when "0010"=>cat<=not("1011011"); -- 2
when "0011"=>cat<=not("1001111"); -- 3
when "0100"=>cat<=not("1100110"); -- 4
when "0101"=>cat<=not("1101101"); -- 5
when "0110"=>cat<=not("1111101"); -- 6
when "0111"=>cat<=not("0000111"); -- 7
when "1000"=>cat<=not("1111111"); -- 8
when "1001"=>cat<=not("1101111"); -- 9
when "1010"=>cat<=not("1110111"); --10 A
when "1011"=>cat<=not("1111100"); --11 B
when "1100"=>cat<=not("0111001"); --12 C
when "1101"=>cat<=not("1011110"); --13 d
when "1110"=>cat<=not("1111001"); --14 E
when others=>cat<=not("1110001"); --15 F

end case;
end process;


end Behavioral;