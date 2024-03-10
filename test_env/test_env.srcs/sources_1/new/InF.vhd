----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2023 00:23:26
-- Design Name: 
-- Module Name: InF - Behavioral
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

entity InF is
    Port (clk: in STD_LOGIC;
          rst : in STD_LOGIC;
          en : in STD_LOGIC;
          BranchAddress : in STD_LOGIC_VECTOR(15 downto 0);
          JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);
          Jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR(15 downto 0);
          PCinc : out STD_LOGIC_VECTOR(15 downto 0));
end InF;

architecture Behavioral of InF is

-- Memorie ROM
type tROM is array (0 to 255) of STD_LOGIC_VECTOR (15 downto 0);
signal ROM : tROM := (

-- PROGRAM DE TEST

--    B"001_000_101_0000101"      -- X"2285" -- li $0, 5
--    B"010_001_011_0000101"      -- X"4585" -- ble $1 $3, max
--    B"011_000_011_0010000"      -- X"6190" -- bne $0, $3, add_to_sum_1
--    B"100_100_101_0000100"      -- X"9284" -- beq $4, $5, pitagorean_true
--    B"000_000_000_011_1_000"    -- X"0038" -- move $3, $0
--    B"000_100_101_100_0_001"    -- X"1299" -- add $4, $4, $5
--    B"000_000_000_101_1_010"    -- X"005a" -- mul $5, $0, $0
--    B"111_0000000000100"        -- X"e004" -- j exit
--    B"111_0000000000000"        -- X"e000" -- jr $ra

--      Program pentru determinarea unui grup
--   ca este pitagoreic. Folosim instructiuni 
--   de salt de tip J.

--main:
    B"001_111_101_0000000",      -- X"3E80" -- addi $0, $7, 5
    B"001_111_100_0000001",      -- X"3E81" -- addi $1, $7, 4
    B"001_111_011_0000010",      -- X"3E82" -- addi $2, $7, 3
    B"000_011_111_011_1_000",    -- X"0FB8" -- add $3, $7, $0
    B"000_000_000_0000000",      -- X"0000" -- NoOp
    B"000_000_000_0000000",      -- X"0000" -- NoOp
    B"010_001_011_0000101",      -- X"4585" -- beq $1, $3, 1
    B"000_000_000_0000000",      -- X"0000" -- NoOp
    B"000_000_000_0000000",      -- X"0000" -- NoOp
    B"000_000_000_0000000",      -- X"0000" -- NoOp
    B"000_001_111_011_1_000",    -- X"07B8" -- add $3, $1, $7 
--check_max:
    B"010_010_011_0000101",      -- X"4985" -- beq $2, $3, 2
    B"000_000_000_0000000",      -- X"0000" -- NoOp
    B"000_000_000_0000000",      -- X"0000" -- NoOp
    B"000_000_000_0000000",      -- X"0000" -- NoOp    
    B"001_000_111_0000000",      -- X"2380" -- addi $0, $7, 0  
    B"111_0000000000011",        -- X"E003" -- j 3
    B"000_000_000_0000000",      -- X"0000" -- NoOp
--check_pitagorean:
    B"001_111_101_0000100",      -- X"3E84" -- addi $4, $7, 5
    B"001_111_101_0000101",      -- X"3E85" -- addi $5, $7, 5
    B"001_111_101_0000110",      -- X"3E86" -- addi $6, $7, 5
    B"010_011_100_0000000",      -- X"4E00" -- beq $0, $3, 4
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"111_0000000000101",        -- X"E005" -- j 5
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
--add_to_sum_1:
    B"000_000_000_101_1_010",    -- X"005A" -- mul $5, $0, $0
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_100_101_100_0_001",    -- X"12C1" -- add $4, $4, $5
--next_1:
    B"010_011_001_0000110",      -- X"4C86" -- beq $1, $3, 6
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"111_0000000000111",        -- X"E007" -- j 7
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
--add_to_sum_2:
    B"000_001_001_101_1_010",    -- X"04DA" -- mul $5, $1, $1
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_100_101_100_0_001",    -- X"12C1" -- add $4, $4, $5
--next_2:
    B"010_011_010_0001000",      -- X"4D08" -- beq $2, $3, 8
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"111_0000000001001",        -- X"E009" -- j 9
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
--check_pitagorean_done:
    B"000_011_011_101_1_010",    -- X"0DDA" -- mul $5, $3, $3
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"010_101_100_0001001",      -- X"5609" -- beq $4, $5, 9
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"000_000_000_0000000",      -- X"0000" -- NoOp  
    B"001_111_000_0000000",      -- X"3C00" -- addi $0, $7, 0 

--pitagorean_true:
    B"011_000_111_0000001",      -- X"6381" -- sw $0, 1($7) 
--exit:
    B"111_0000000000000",        -- X"E000" -- j 0
    B"111_0000000000000",        -- X"E000" -- j 0

    others => X"0000");

signal PC : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal PCAux, NextAddr, AuxSgn, AuxSgn1: STD_LOGIC_VECTOR(15 downto 0);

begin

    -- Program Counter
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                PC <= (others => '0');
            elsif en = '1' then
                PC <= NextAddr;
            end if;
        end if;
    end process;

    -- Instruction OUT
    Instruction <= ROM(conv_integer(PC(7 downto 0)));

    -- PC incremented
    PCAux <= PC + 1;
    PCinc <= PCAux;

    -- MUX Branch
    process(PCSrc, PCAux, BranchAddress)
    begin
        case PCSrc is 
            when '1' => AuxSgn <= BranchAddress;
            when others => AuxSgn <= PCAux;
        end case;
    end process;	

     -- MUX Jump
    process(Jump, AuxSgn, JumpAddress)
    begin
        case Jump is
            when '1' => NextAddr <= JumpAddress;
            when others => NextAddr <= AuxSgn;
        end case;
    end process;

end Behavioral;