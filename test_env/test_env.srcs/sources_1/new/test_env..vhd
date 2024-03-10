library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;

component SSD is
    Port ( clk: in STD_LOGIC;
           digits: in STD_LOGIC_VECTOR(15 downto 0);
           an: out STD_LOGIC_VECTOR(7 downto 0);
           cat: out STD_LOGIC_VECTOR(6 downto 0));
end component;

component InF
    Port ( clk: in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR(15 downto 0);
           JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(15 downto 0);
           PCinc : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component Decode
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
end component;

component MainControl
    Port ( Instr : in STD_LOGIC_VECTOR(2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component ExecutionUnit is
    Port ( PCinc : in STD_LOGIC_VECTOR(15 downto 0);
           RD1 : in STD_LOGIC_VECTOR(15 downto 0);
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR(15 downto 0);
           func, rt, rd: in STD_LOGIC_VECTOR(2 downto 0);
           sa, RegDst : in STD_LOGIC;
           ALUSrc : in STD_LOGIC;
           rWA: out STD_LOGIC_VECTOR(2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR(15 downto 0);
           ALURes : out STD_LOGIC_VECTOR(15 downto 0);
           Zero : out STD_LOGIC);
end component;

component MEM
    port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR(15 downto 0);
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR(15 downto 0));
end component;

signal Instruction, PCinc, RD1, RD2, WD, Ext_imm : STD_LOGIC_VECTOR(15 downto 0); 
signal JumpAddress, BranchAddress, ALURes, ALURes1, MemData : STD_LOGIC_VECTOR(15 downto 0);
signal func : STD_LOGIC_VECTOR(2 downto 0);
signal sa, zero : STD_LOGIC;
signal digits : STD_LOGIC_VECTOR(15 downto 0);
signal en, rst, PCSrc : STD_LOGIC; 
-- main controls 
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite : STD_LOGIC;
signal ALUOp :  STD_LOGIC_VECTOR(2 downto 0);

--PipeLine's Registers --> signals

--IF-ID component

signal PCincIfId, InstrIfId: std_logic_vector(15 downto 0);

--ID-EX component

signal PCincIdEx, RD1IdEx, RD2IdEx, Ext_ImmIdEx: std_logic_vector(15 downto 0);
signal funcIdEx, rtIdEx, rdIdEx, ALUOpIdEx, rWA, WA: std_logic_vector(2 downto 0);
signal saIdEx, MemtoRegIdEx, RegWriteIdEx, MemWriteIdEx, BranchIdEx, ALUSrcIdEx, RegDstIdEx: std_logic;

--EX-MEM component

signal BranchAddressExMem, ALUResExMem, RD2ExMem: std_logic_vector(15 downto 0);
signal rdExMem: std_logic_vector(2 downto 0);
signal zeroExMem, MemtoRegExMem, RegWriteExMem, MemWriteExMem, BranchExMem: std_logic;

--MEM-WB component

signal MemDataMemWb, ALUResMemWb: std_logic_vector(15 downto 0);
signal rdMemWb: std_logic_vector(2 downto 0);
signal MemtoRegMemWb, RegWriteMemWb: std_logic;

begin

    -- buttons: reset, enable
    monopulse1: MPG port map(en, btn(0), clk);
    monopulse2: MPG port map(rst, btn(1), clk);
    
    -- main units
    inst_IF: InF port map(clk, rst, en, BranchAddress, JumpAddress, Jump, PCSrc, Instruction, PCinc);
    inst_ID: Decode port map(clk, en, Instruction(12 downto 0), WD, WA, RegWriteMemWb, RegDst, ExtOp, RD1, RD2, Ext_imm, func, sa);
    inst_MC: MainControl port map(Instruction(15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
    inst_EX: ExecutionUnit port map(PCincIdEx, RD1IdEx, RD2IdEx, Ext_ImmIdEx, funcIdEx, rtIdEx, rdIdEx, saIdEx, RegDstIdEx, ALUSrcIdEx, rWA, ALUOp, BranchAddress, ALURes, zero);
    inst_MEM: MEM port map(clk, en, ALUResExMem, RD2ExMem, MemWriteExMem, MemData, ALURes1);

    -- PipeLine's description:
    
    process(clk)
    begin
    
    if rising_edge(clk) then
        if en = '1' then
            --for IF-ID
            PCincIfId <= PCinc;
            InstrIfId <= Instruction;
            --for ID-EX
            PCincIdEx <= PCincIfId;
            RD1IdEx <= RD1;
            RD2IdEx <= RD2;
            Ext_ImmIdEx <= Ext_Imm;
            saIdEx <= sa;
            funcIdEx <= func;
            rtIdEx <= Instruction(9 downto 7);
            rdIdEx <= Instruction(6 downto 4);
            MemtoRegIdEx <= MemtoReg;
            RegWriteIdEx <= RegWrite;
            MemWriteIdEx <= MemWrite;
            BranchIdEx <= Branch;
            ALUSrcIdEx <= ALUSrc;
            ALUOpIdEx <= ALUOp;
            RegDstIdEx <= RegDst;
            --for EX-MEM
            BranchAddressExMem <= BranchAddress;
            ZeroExMem <= zero;
            ALUResExMem <= RD2IdEx;
            RD2ExMem <= RD2IdEx;
            rdExMem <= Instruction(6 downto 4);
            MemtoRegExMem <= MemtoRegIdEx;
            RegWriteExMem <= RegWriteIdEx;
            MemWriteExMem <= MemWriteIdEx;
            BranchExMem <= BranchIdEx;
            --for MEM-WB
            MemDataMemWb <= MemData;
            ALUResMemWb <= ALURes;
            rdMemWb <= rdExMem;
            MemtoRegMemWb <= MemtoRegExMem;
            RegWriteMemWb <= RegWriteExMem;
        end if;
    end if;
    end process;

    -- WriteBack unit
    with MemtoReg select
        WD <= MemDataMemWb when '1',
              ALUResMemWb when '0',
              (others => '0') when others;

    -- branch control
    PCSrc <= ZeroExMem and BranchExMem;

    -- jump address
    JumpAddress <= PCinc(15 downto 13) & InstrIfId(12 downto 0);

   -- SSD display MUX
    with sw(7 downto 5) select
        digits <=  Instruction when "000", 
                   PCinc when "001",
                   RD1IdEx when "010",
                   RD2IdEx when "011",
                   Ext_ImmIdEx when "100",
                   ALURes when "101",
                   MemData when "110",
                   WD when "111",
                   (others => '0') when others; 

    display : SSD port map (clk, digits, an, cat);
    
    -- main controls on the leds
    led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;
    
end Behavioral;