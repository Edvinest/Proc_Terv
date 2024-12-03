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
       if Execute = '1' then
        if falling_edge(clk) then
            case Instr_code is
                when "000010"=> -- And sX, sY
                Result(15 downto 0) := Result(15 downto 8) & (OP1(7 downto 0) and OP2(7 downto 0));
                if Result(15 downto 0) = x"0000" then
                    ZeroFlag := '1';
                else
                    ZeroFLag := '0';
                    end if;
                    
                when "000011" => -- And sX, KK
                    Result(15 downto 0) := Result(15 downto 8) & (KK_Const and OP1(7 downto 0));
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else
                        ZeroFlag := '0';
                    end if;
                    
                when "000101" => -- Or sX, KK
                    Result(15 downto 0) := Result(15 downto 8) & (KK_Const or OP1(7 downto 0));
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else 
                        ZeroFlag := '0';
                    end if;
                    
                when "000100" => -- Or sX, sY
                    Result (15 downto 0) := Result(15 downto 8) & (OP1(7 downto 0) or OP2(7 downto 0));
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else
                        ZeroFlag := '0';
                    end if;
                        
                when "000111" => -- Xor sX, KK
                    Result (15 downto 0):= Result(15 downto 8) & (KK_Const or OP1(7 downto 0));
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else 
                        ZeroFlag := '0';
                    end if;
                
                when "000110" => -- Xor sX, sY
                    Result (15 downto 0) := Result(15 downto 8) & (OP1(7 downto 0) or OP2(7 downto 0));
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else
                        ZeroFlag := '0';
                    end if;
                    
                when "001101" => -- Mult8 sX, KK
                    Result(15 downto 0) := unsigned(KK_Const) * unsigned(OP1(7 downto 0));
                    if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                    else ZeroFlag := '0';
                    end if;
                    
                when "001100" => --Mult8 sX, sY
                    Result(15 downto 0) := unsigned(OP1(7 downto 0)) * unsigned(OP2(7 downto 0));
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
                    
                when "011100" => -- Comp sX, sY
                    if(OP1(7 downto 0) < OP2(7 downto 0)) then
                        CarryFlag := '1';
                    else CarryFlag := '0';
                    end if;
                    if (OP1(7 downto 0) = OP2(7 downto 0)) then
                        ZeroFlag := '1';
                    else ZeroFlag := '0';
                    end if;
                    
                when "010001" => -- Add sX, KK
                    Result(15 downto 0) := ('0' & OP1(7 downto 0)) + ("00000000" & KK_Const);
                    CarryFlag := Result(16);
                   
                   if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                   else ZeroFlag := '0';
                   end if;
                   
                when "010000" => -- Add sX, sY
                    Result(15 downto 0) := ('0' & OP1(7 downto 0)) + ("00000000" & OP2(7 downto 0));
                    CarryFlag := Result(16);
                   
                   if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                   else ZeroFlag := '0';
                   end if;
                   
                when "010011" => -- AddCy sX, KK
                    Result(15 downto 0) := ('0' & OP1(7 downto 0)) + ("00000000" & KK_Const) + CarryFlag;
                    CarryFlag := Result(16);
                   
                   if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                   else ZeroFlag := '0';
                   end if;
                   
                when "010010" => -- AddCy sX, sY
                    Result(15 downto 0) := ('0' & OP1(7 downto 0)) + ("00000000" & OP2(7 downto 0)) + CarryFlag;
                    CarryFlag := Result(16);
                   
                   if Result(15 downto 0) = x"0000" then
                        ZeroFlag := '1';
                   else ZeroFlag := '0';
                   end if;
                   
                   when "011001" => -- SUB sX, KK
                    Result(15 downto 0):= Result(15 downto 8) & (OP1(7 downto 0) - KK_const);
                    if(Result(15 downto 0)=x"0000")then -- eredmeny=0 eseten zeroflag lenullazasa
                        ZeroFlag:='1';
                    else
                        ZeroFlag:='0';
                    end if;
                    if(OP1>(KK_const+CarryFlag)) then --Carry flag allitasa negativ tulcsordulas eseten
                        CarryFlag:='0';
                    else
                        CarryFlag:='1';
                    end if;
                    
                    when "011000" => -- SUB sX, sY
                    Result(15 downto 0) := Result(15 downto 8) & (OP1(7 downto 0)-OP2(7 downto 0)-CarryFlag);
                    if(Result(15 downto 0)=x"0000")then -- eredmeny=0 eseten zeroflag lenullazasa
                        ZeroFlag:='1';
                    else
                        ZeroFlag:='0';
                    end if;
                    if(OP1>(KK_const+CarryFlag)) then --Carry flag allitasa negativ tulcsordulas eseten
                        CarryFlag:='0';
                    else
                        CarryFlag:='1';
                    end if;
                   
                   when "011011" => -- SUBCY sX,KK
                    Result(15 downto 0) := Result(15 downto 8) & (OP1(7 downto 0)-KK_const-CarryFlag);
                    if(Result(15 downto 0)=x"0000")then -- eredmeny=0 eseten zeroflag lenullazasa
                        ZeroFlag:='1';
                    else
                        ZeroFlag:='0';
                    end if;
                    if(OP1>(KK_const+CarryFlag)) then --Carry flag allitasa negativ tulcsordulas eseten
                        CarryFlag:='0';
                    else
                        CarryFlag:='1';
                    end if;
                    
                when "011010" => -- SUBCY sX, sY
                    Result(15 downto 0) := Result(15 downto 8) & (OP1(7 downto 0)-OP2(7 downto 0)-CarryFlag);
                    if(Result(15 downto 0)=x"0000")then -- eredmeny=0 eseten zeroflag lenullazasa
                        ZeroFlag:='1';
                    else
                        ZeroFlag:='0';
                    end if;
                    if(OP1>(OP2+CarryFlag)) then --Carry flag allitasa negativ tulcsordulas eseten
                        CarryFlag:='0';
                    else
                        CarryFlag:='1';
                    end if; 
                
                when "010100" => --(SRR Sx)
                    case KK_const(3 downto 0) is
                        -------------- SRR ----------------------
                        when "1110" => -- SR0
                            CarryFlag := OP1(0); 
                            Result(14 downto 0) :=OP1(15 downto 1);
                            Result(15) :='0';
                            if(Result(15 downto 0)=x"0000")then 
                                ZeroFlag:='1';
                            else
                                ZeroFlag:='0';
                            end if;
                                    
                        when "1111" => -- SR1
                            CarryFlag := OP1(0);
                            Result(14 downto 0) :=OP1(15 downto 1);
                            Result(15) :='1';
                            
                        when "1010" => -- SRx
                            Result(15 downto 0) :=OP1(15 downto 0);
                            if(Result(15 downto 0)=x"0000")then 
                                ZeroFlag:='1';
                            else
                                ZeroFlag:='0';
                            end if;
                            
                         when "1000" => -- SRA
                            CarryFlag := OP1(0);
                            Result(14 downto 0) := OP1(15 downto 1);
                            Result(15) := CarryFlag;
                            if(Result(15 downto 0)=x"0000")then
                                ZeroFlag:='1';
                            else
                                ZeroFlag:='0';
                            end if;
                            
                         when "1100" => -- RR
                            CarryFlag := OP1(0);
                            Result(14 downto 0) := OP1(15 downto 1);
                            Result(15) := OP1(0);
                            if(Result(15 downto 0)=x"0000")then 
                                ZeroFlag:='1';
                            else
                                ZeroFlag:='0';
                            end if;
                            ----------------- SRL-------------------
                         when "0110" => -- SL0
                            CarryFlag := OP1(15);
                            Result(15 downto 1) :=OP1(14 downto 0);
                            Result(0) :='0';
                            if(Result(15 downto 0)=x"0000")then 
                                ZeroFlag:='1';
                            else
                                ZeroFlag:='0';
                            end if;
                                    
                        when "0111" => -- SL1
                            CarryFlag := OP1(15);
                            Result(15 downto 1) :=OP1(14 downto 0);
                            Result(0) :='1';
                            
                        when "0100" => -- SLx
                            CarryFlag := OP1(15);
                            Result(15 downto 1) := OP1(14 downto 0);
                            Result(0) := OP1(0);
                            if(Result(15 downto 0)=x"0000")then
                                ZeroFlag:='1';
                            else
                                ZeroFlag:='0';
                            end if;
                            
                         when "0000" => -- SLA
                            CarryFlag := OP1(15);
                            Result(15 downto 1) := OP1(14 downto 0);
                            Result(0) := CarryFlag;
                            if(Result(15 downto 0)=x"0000")then 
                                ZeroFlag:='1';
                            else
                                ZeroFlag:='0';
                            end if;
                            
                         when "0010" => -- RL
                            CarryFlag := OP1(15);
                            Result(15 downto 1) := OP1(14 downto 0);
                            Result(0) := OP1(15);
                            if(Result(15 downto 0)=x"0000")then 
                                ZeroFlag:='1';
                            else
                                ZeroFlag:='0';
                            end if;
                            
                         when others =>
                                 Result := (others => '0');
                                 ZeroFlag := '0';
                                 CarryFlag := '0';
                    end case;
                    
               when others =>
                        Result := (others => '0');
                        ZeroFlag := '0';
                        CarryFlag := '0';
            end case;
           end if;
       end if;
           ALU_Result <= Result(15 downto 0);
           Carry <= CarryFlag;
           Zero <= ZeroFlag;
    end if;
    
end process;

end Behavioral;
