----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2023 13:21:22
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
           
end test_env;

architecture Behavioral of test_env is

--variabile pt MPG
signal RES: std_logic_vector(7 downto 0);
signal S: std_logic_vector(2 downto 0);
 
 --variabile pentru counter
signal en: std_logic := '1';
signal cnt: std_logic_vector(15 downto 0);

--variabile pentru SSD
signal digits: std_logic_vector(15 downto 0);

--variabile pentru counter_MPG - ALU
signal counter_MPG: std_logic_vector(7 downto 0);
signal MPG_enable: std_logic;

----iesirile pentru extendere de 0
--signal output1: std_logic_vector(15 downto 0);
--signal output2: std_logic_vector(15 downto 0);
--signal output3: std_logic_vector(15 downto 0);

----semnal de transport suma/scadere
--signal cin: std_logic_vector(15 downto 0);

----variabile pentru sumator
--signal sum: std_logic_vector(15 downto 0);

----variabile pentru scazator
--signal dif: std_logic_vector(15 downto 0);

----variabile shiftere
--signal output3_left: std_logic_vector(15 downto 0);
--signal output3_right: std_logic_vector(15 downto 0);

--variabile pt ROM

begin
--------------------------------------------------ALU
process(clk, MPG_enable)
begin
if rising_edge(clk) then
    if MPG_enable ='1' then
        counter_MPG <= counter_MPG + 1;
    end if;
end if;
end process;

--process(sw(3 downto 0))
--begin
--    output1 <= (others => '0');
--    output1(15 downto 8) <= sw(3 downto 0) & "0000";
--end process;

--process(sw(7 downto 4))
--begin
--    output2 <= (others => '0');
--    output2(15 downto 8) <= sw(7 downto 4) & "0000";
--end process;

--process(sw(7 downto 0))
--begin
--    output3 <= (others => '0');
--    output3(15 downto 8) <= sw(7 downto 0);
--end process;

--process(output1, output2, cin)
--begin
--    sum <= output1 xor output2 xor cin;
--end process;

--process(output1, output2, cin)
--begin
--    dif <= output1 xor (not(output2)) xor cin;
--    dif <= dif + 1;
--end process;

--process(output3)
--begin
--    output3_left <= output3(13 downto 0) & "00";
--    output3_right <= "00" & output3(15 downto 2);
--end process;

--process(counter_MPG)
--begin
--case counter_MPG is
--    when "00"=>digits<=sum;
--    when "01"=>digits<=dif;
--    when "10"=>digits<=output3_left;
--    when others=>digits<=output3_right;
--end case;
--end process;

--process(digits)
--begin
--    if digits = "0000000000000000" then
--        led(7)<='1';
--    else led(7)<='0';
--    end if;
--end process;

----------------------------------------------------


process(S)
begin
 case S is
 when "000" => RES <= "00000001";
 when "001" => RES <= "00000010";
 when "010" => RES <= "00000100";
 when "011" => RES <= "00001000";
 when "100" => RES <= "00010000";
 when "101" => RES <= "00100000";
 when "110" => RES <= "01000000";
 when others => RES <= "10000000";
 end case;
end process;

process(clk, en)
begin
 if rising_edge(clk) then
    if sw(0)='1' then
        if en = '1' then
            cnt <= cnt + 1;
        end if;
    else if en = '1'then
            cnt <= cnt - 1;
        end if;
    end if;
 end if;
end process;

-----------------------------------------   ROM 256x16

type tROM is array (0 to 7) of std_logic_vector(15 downto 0);
signal ROM : tROM := (
x"0001",
x"0005",
x"000A",
x"0F09",
x"FF10",
others => x"0000");




signal do : std_logic_vector(15 downto 0);

process(counter_MPG)
begin


end process;


-----------------------------------------

btnc: entity WORK.MPG port map
(
en=>MPG_enable,
btn=>btn(0),
clk=>clk
);

led<=cnt;

afisor: entity WORK.SSD  port map
(
cnt,
clk,
an,
cat
);

end Behavioral;
