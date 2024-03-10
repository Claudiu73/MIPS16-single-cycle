----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2023 00:27:10
-- Design Name: 
-- Module Name: Decode - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity Decode is
    Port ( clk: in STD_LOGIC;
           en : in STD_LOGIC;    
           Instr : in STD_LOGIC_VECTOR(12 downto 0);
           WD : in STD_LOGIC_VECTOR(15 downto 0);
           WA : in STD_LOGIC_VECTOR(2 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR(15 downto 0);
           RD2 : out STD_LOGIC_VECTOR(15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR(15 downto 0);
           func : out STD_LOGIC_VECTOR(2 downto 0);
           sa : out STD_LOGIC);
end Decode;

architecture Behavioral of Decode is

-- RegFile
type reg_array is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
signal reg_file : reg_array := (others => (others => '0'));


signal WriteAddress: STD_LOGIC_VECTOR(2 downto 0);
signal RegAddress: STD_LOGIC_VECTOR(2 downto 0);

begin

    -- RegFile write
process(clk, WA)			
begin
    if falling_edge(clk) then
        if en = '1' and RegWrite = '1' then
            reg_file(conv_integer(WA)) <= WD;
        end if;
    end if;
end process;	

-- RegFile read
RD1 <= reg_file(to_integer(unsigned(Instr(12 downto 10)))); -- rs
RD2 <= reg_file(to_integer(unsigned(Instr(9 downto 7)))); -- rt

-- immediate extend
Ext_Imm <= (others => '0');
Ext_Imm(6 downto 0) <= Instr(6 downto 0); 
process(ExtOp)
begin
case ExtOp is
    when '1' =>
        Ext_Imm(15 downto 7) <= (others => Instr(6));
    when others =>
        Ext_Imm(15 downto 7) <= (others => '0');
end case;
end process;

-- other outputs
sa <= Instr(3);
func <= Instr(2 downto 0);


end Behavioral;