----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/09/2024 05:44:36 PM
-- Design Name: 
-- Module Name: RegBlock - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegBlock is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           SX_addr : in STD_LOGIC_VECTOR (3 downto 0);
           SY_addr : in STD_LOGIC_VECTOR (3 downto 0);
           Dataxin : in STD_LOGIC_VECTOR (15 downto 0);
           RW : in STD_LOGIC;
           DataoutX : out STD_LOGIC_VECTOR (15 downto 0);
           DataoutY : out STD_LOGIC_VECTOR (15 downto 0));
end RegBlock;

architecture Behavioral of RegBlock is

type Regs is array (0 to 15) of std_logic_vector(15 downto 0);

begin

process(Clk, Reset, RW)
variable Tarolo: Regs := (others =>(others => '0'));
    
 begin
        if falling_edge(Clk) then
            if Reset = '1' then
                Tarolo := (others => (others => '0'));
                DataoutX <= (others => '0');
            else
                if RW = '1' then
                    Tarolo(conv_integer(SX_addr)) := Dataxin;
                else
                    DataoutX <= Tarolo(conv_integer(SX_addr));
                    DataoutY <= Tarolo(conv_integer(SY_addr));
                end if;
        end if;
   end if;
                
end process;

end Behavioral;
