----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/09/2024 05:14:35 PM
-- Design Name: 
-- Module Name: IFDEC - Behavioral
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

entity IFDEC is
    Port ( reset : in STD_LOGIC;
           Instr_Phase : in STD_LOGIC_VECTOR (2 downto 0);
           Instruction : in STD_LOGIC_VECTOR (17 downto 0);
           Sx_Addr : out STD_LOGIC_VECTOR (3 downto 0);
           Sy_Addr : out STD_LOGIC_VECTOR (3 downto 0);
           DMemAddr_dir : out STD_LOGIC_VECTOR (5 downto 0);
           ENInterrupt : out STD_LOGIC;
           PortID_dir : out STD_LOGIC_VECTOR (7 downto 0);
           Branch_Addr : out STD_LOGIC_VECTOR (11 downto 0);
           AL_Instr_Ext : out STD_LOGIC_VECTOR (3 downto 0);
           KK_const : out STD_LOGIC_VECTOR (7 downto 0);
           Instr_code : out STD_LOGIC_VECTOR (5 downto 0));
end IFDEC;

architecture Behavioral of IFDEC is

begin

process(reset, Instr_Phase, Instruction)
    begin
    if reset = '1' then
        Sx_Addr <= (others => '0');
        Sy_Addr <= (others => '0');
        DMemAddr_dir <= (others => '0');
        ENInterrupt <= '0';
        PortID_dir <= (others => '0');
        Branch_Addr <= (others => '0');
        AL_Instr_Ext <= (others => '0');
        KK_Const <= (others => '0');
        Instr_code <= (others => '0');
        
    else
        if Instr_Phase = "000" then
             case Instruction(17 downto 12) is
             --Adatmozgató utasítások
                when "000001" => --Load
                        Sx_Addr <= Instruction(11 downto 8);
                        KK_const <= Instruction(7 downto 0);
                when "000000" | "001000" | "001010" | "101100" | "101110" => -- Load vagy Input vagy Fetch vagy Output vagy Store (sX, sY)
                        Sx_Addr <= Instruction(11 downto 8);
                        Sy_Addr <= Instruction(7 downto 4);
                when "001001" | "101101" => --Input vagy Output
                        Sx_Addr <= Instruction(11 downto 8);
                        PortID_dir <= Instruction(7 downto 0);
                when "001011" | "101111" => --Fetch vagy Store
                        Sx_Addr <= Instruction(11 downto 8);
                        DMemAddr_dir <= Instruction(5 downto 0); 
              
              --Aritmetikai és Logikai utasítások
                when "000011" | "000101" | "000111" | "001101" | "011101" | "010001" | "010011" | "011001" | "011011" => -- And vagy Or vagy Xor vagy Mult8 vagy Comp vagy Add vagy AddCy vagy Sub vagy SubCy
                        Sx_Addr <= Instruction(11 downto 8);
                        KK_const <= Instruction(7 downto 0);
                when "000010" | "000100" | "000110" | "001100" | "011100" | "010000" | "010010" | "011000" | "011010" => -- And vagy Or vagy Xor vagy Mult8 vagy Comp vagy Add vagy AddCy vagy Sub vagy SubCy
                        Sx_Addr <= Instruction(11 downto 8);
                        Sy_Addr <= Instruction(7 downto 4);
               
               when "010100" =>
                        Sx_Addr <= Instruction(11 downto 8);
                        AL_Instr_ext <= Instruction(3 downto 0);
               
               --Elágazásképző utasítások
               when "100010" | "110010" | "110110" | "111010" | "111110" | "100000" | "110000" | "111000" | "111100"=>
                        Branch_Addr <= Instruction(11 downto 0);
                        
                when others =>
                        Sx_Addr <= (others => '0');
                        Sy_Addr <= (others => '0');
                        DMemAddr_dir <= (others => '0');
                        ENInterrupt <= '0';
                        PortID_dir <= (others => '0');
                        Branch_Addr <= (others => '0');
                        AL_Instr_Ext <= (others => '0');
                        KK_Const <= (others => '0');
                        Instr_code <= (others => '0');
              end case;
            end if;
         end if;
end process;

end Behavioral;
