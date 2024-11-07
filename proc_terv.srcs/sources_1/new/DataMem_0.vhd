----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2024 04:55:38 PM
-- Design Name: 
-- Module Name: DataMem_0 - Behavioral
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
--use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DataMem_0 is
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           DataoutX : in STD_LOGIC_VECTOR (15 downto 0);
           DmemAddr_dir : in STD_LOGIC_VECTOR (5 downto 0);
           DmemAddr_indir : in STD_LOGIC_VECTOR (5 downto 0);
           SelAddr : in STD_LOGIC;
           MR : in STD_LOGIC;
           MW : in STD_LOGIC;
           DataMemOut : out STD_LOGIC_VECTOR (15 downto 0));
end DataMem_0;

architecture Behavioral of DataMem_0 is

signal DMemAddr: integer range 0 to 63 := 0;
type Tomb is array (0 to 63) of std_logic_vector(63 downto 0);

begin

DMemAddr <= conv_integer(DMemAddr_Dir)
when SelAddr = '0' else conv_integer(DataOutX);

process(clk, Reset, MR, MW)
    variable Tarolo: Tomb := (others => (others => '0'));
    begin
    if falling_edge(clk) then
        if reset = '1' then
            DataMemOut <= (others => '0');
            Tarolo := (others=>(others => '0'));
        else
            if MW = '1' and MR = '0' then
                Tarolo(DMemAddr) := DataoutX;
            elsif MW = '0' and MR = '1' then
                DataMemOut <= Tarolo(DMemAddr);
            end if;
       end if;
    end if;
    end process;

end Behavioral;
