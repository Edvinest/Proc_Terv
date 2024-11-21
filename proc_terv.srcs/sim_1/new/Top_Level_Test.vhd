----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2024 04:37:56 PM
-- Design Name: 
-- Module Name: Top_Level_Test - Behavioral
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

entity Top_Level_Test is
--  Port ( );
end Top_Level_Test;

architecture Behavioral of Top_Level_Test is

component Top_Level is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (3 downto 0));
end component;

    signal btn : std_logic_vector (3 downto 0) := (others => '0');
    signal led : std_logic_vector (3 downto 0)  :=  (others =>'0');
    
    
    signal clk          : std_logic := '0';
    constant clk_period : time := 10 ns;
begin

uut: Top_Level PORT MAP (
       clk => clk,
       btn => btn,
       led => led
);

clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

 stim_proc: process
   begin        
      -- hold reset state for 100 ns.
      wait for 100 ns;
      
      btn <= "0000";
      wait for clk_period;
      
      
      
    end process;


end Behavioral;
