----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2024 04:37:10 PM
-- Design Name: 
-- Module Name: ALU_0 - Behavioral
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_0 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           OP1 : in STD_LOGIC_VECTOR (15 downto 0);
           OP2 : in STD_LOGIC_VECTOR (15 downto 0);
           Instr_code : in STD_LOGIC_VECTOR (5 downto 0);
           Al_Instr_Ext : in STD_LOGIC_VECTOR (3 downto 0);
           KK_Const : in STD_LOGIC_VECTOR (7 downto 0);
           Execute : in STD_LOGIC;
           Carry : out STD_LOGIC;
           Zero : out STD_LOGIC;
           ALU_Result : out STD_LOGIC_VECTOR (15 downto 0));
end ALU_0;

architecture Behavioral of ALU_0 is

begin

process(clk, reset, Execute, Instr_code, Al_Instr_Ext)
variable Result:std_logic_vector(16 downto 0) := (others => '0');
variable ZeroFlag, CarryFlag:std_logic := '0';

begin
    if (reset = '1') then
        Alu_Result <= (others => '0');
        Carry <= '0';
        Zero <= '0';
    else
        if falling_edge(clk) then
            if Execute = '1' then
            case instr_code is
                when "000010"=> -- And sX, sY
                Result(15 downto 0) := OP1 and OP2;
                if Result(15 downto 0) = x"0000" then
                    ZeroFlag := '1';
                else
                    ZeroFLag := '0';
                    end if;
                    
                when "000011" => -- And sX, KK
                    Result := KK_Const and OP1(7 downto 0);
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else
                        ZeroFlag := '0';
                    end if;
                    
                when "000101" => -- Or sX, KK
                    Result := KK_Const or OP1(7 downto 0);
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else 
                        ZeroFlag := '0';
                    end if;
                    
                when "0000100" => -- Or sX, sY
                    Result := OP1 or OP2;
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else
                        ZeroFlag := '0';
                    end if;
                        
                when "000111" => -- Xor sX, KK
                    Result := KK_Const or OP1(7 downto 0);
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else 
                        ZeroFlag := '0';
                    end if;
                
                when "000110" => -- Xor sX, sY
                    Result := OP1 or OP2;
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else
                        ZeroFlag := '0';
                    end if;
                    
                when "001101" => -- Mult8 sX, KK
                    Result := KK_Const * OP1(7 downto 0);
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else ZeroFlag := '0';
                    end if;
                    
                when "001100" => --Mult8 sX, sY
                    Result := OP1 * OP2;
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else ZeroFlag := '0';
                    end if;
                
                when "011101" => -- Comp sX, KK
                    if(OP1(7 downto 0) < KK_Const(7 downto 0)) then
                        CarryFlag := '1';
                    else CarryFlag := '0';
                    end if;
                    if (OP1(7 downto 0) = KK_Const(7 downto 0)) then
                        ZeroFlag := '1';
                    else ZeroFlag := '0';
                    end if;
                    
                when "011100" => -- Comp sX, KK
                    if(OP1(7 downto 0) < OP2(7 downto 0)) then
                        CarryFlag := '1';
                    else CarryFlag := '0';
                    end if;
                    if (OP1(7 downto 0) = OP2(7 downto 0)) then
                        ZeroFlag := '1';
                    else ZeroFlag := '0';
                    end if;
                                        
            end case;
            
            ALU_Result <= Result;
            Carry <= CarryFlag;
            Zero <= ZeroFlag;
           end if;
       end if;
    end if;
end process;

end Behavioral;
