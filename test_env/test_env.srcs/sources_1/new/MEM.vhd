----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2023 00:10:36
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR(15 downto 0);
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR(15 downto 0));
end MEM;

architecture Behavioral of MEM is

type mem_type is array (0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal MEM : mem_type := (
    X"000A",
    X"000B",
    X"000C",
    X"000D",
    X"000E",
    X"000F",
    X"0009",
    X"0008",
    
    others => X"0000");

begin

    -- Data Memory
    process(clk) 			
    begin
        if rising_edge(clk) then
            if en = '1' and MemWrite='1' then
                MEM(conv_integer(ALUResIn(4 downto 0))) <= RD2;			
            end if;
        end if;
    end process;

    -- outputs
    MemData <= MEM(conv_integer(ALUResIn(4 downto 0)));
    ALUResOut <= ALUResIn;

end Behavioral;
