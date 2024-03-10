----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2023 11:00:19
-- Design Name: 
-- Module Name: RegisterFile - Behavioral
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

entity RegisterFile is
Port (
signal clk: in std_logic;
signal RegWr: in std_logic;
signal RA1: in std_logic_vector(3 downto 0);
signal RA2: in std_logic_vector(3 downto 0);
signal WA: in std_logic_vector(3 downto 0);
signal WD: in std_logic_vector(15 downto 0);
signal RD1: out std_logic_vector(15 downto 0);
signal RD2 : out std_logic_vector(15 downto 0)
 );
end RegisterFile;

architecture Behavioral of RegisterFile is

type reg_array is array(0 to 15) of std_logic_vector(15 downto 0);
signal reg_file: reg_array := (
x"0001",
x"0201",
x"0001",
x"2402",
x"1003",
x"1234",
x"0321",
x"0041",
x"9907",
others => x"0000"
);

begin

RD1 <= reg_file(conv_integer(RA1));
RD2 <= reg_file(conv_integer(RA2));

process(clk)
begin
if rising_edge(clk) then
    if RegWr='1' then
        reg_file(conv_integer(WA))<=WD;
    end if;
end if;
end process;

end Behavioral;
