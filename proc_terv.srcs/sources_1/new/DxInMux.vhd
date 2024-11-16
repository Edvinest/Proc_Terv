----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/09/2024 05:44:36 PM
-- Design Name: 
-- Module Name: DxInMux - Behavioral
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

entity DxInMux is
    Port ( DataMemOut : in STD_LOGIC_VECTOR (15 downto 0);
           PortIntoCPU : in STD_LOGIC_VECTOR (15 downto 0);
           ALUresult : in STD_LOGIC_VECTOR (15 downto 0);
           KK_const : in STD_LOGIC_VECTOR (7 downto 0);
           Dy : in STD_LOGIC_VECTOR (15 downto 0);
           MuxSet : in STD_LOGIC_VECTOR (2 downto 0);
           Dataxin : out STD_LOGIC_VECTOR (15 downto 0));
end DxInMux;

architecture Behavioral of DxInMux is

begin
process(DataMemOut, PortIntoCPU, ALUresult, KK_const, Dy, MuxSet)
begin
    case MuxSet is
        when "000" => 
            Dataxin <= DataMemOut;
        when "001" => 
            Dataxin <= PortIntoCPU;
        when "010" => 
            Dataxin <= ALUresult;
        when "011" => 
            Dataxin <= "00000000" & KK_const;
        when "100" =>
            Dataxin <= Dy;
        when others =>
            Dataxin <= (others => '0');
    end case;
end process;
end Behavioral;
