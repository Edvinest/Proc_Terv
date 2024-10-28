----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2024 05:56:20 PM
-- Design Name: 
-- Module Name: DataMem_Sim - Behavioral
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

entity DataMem_Sim is
--  Port ( );
end DataMem_Sim;

architecture Behavioral of DataMem_Sim is

component DataMem_0 is
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           DataoutX : in STD_LOGIC_VECTOR (15 downto 0);
           DmemAddr_dir : in STD_LOGIC_VECTOR (5 downto 0);
           DmemAddr_indir : in STD_LOGIC_VECTOR (5 downto 0);
           SelAddr : in STD_LOGIC;
           MR : in STD_LOGIC;
           MW : in STD_LOGIC;
           DataMemOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal DataoutX : std_logic_vector (15 downto 0) := (others => '0');
signal DmemAddr_dir : std_logic_vector (5 downto 0) := (others => '0');
signal DmemAddr_indir : std_logic_vector (5 downto 0) := (others => '0');
signal SelAddr : std_logic := '0';
signal MR : std_logic := '0';
signal MW : std_logic := '0';
signal DataMemOut : std_logic_vector (15 downto 0) := (others => '0');

constant clk_period : time := 10 ns;

begin

clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

uut: DataMem_0 PORT MAP(
           clk => clk,
           Reset => reset,
           DataoutX => DataoutX,
           DmemAddr_dir => DmemAddr_dir,
           DmemAddr_indir => DmemAddr_indir,
           SelAddr => SelAddr,
           MR => MR,
           MW => MW,
           DataMemOut => DataMemOut
);

end Behavioral;
