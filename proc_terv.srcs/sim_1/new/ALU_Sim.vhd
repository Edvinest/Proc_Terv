----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2024 09:13:56 AM
-- Design Name: 
-- Module Name: ALU_Sim - Behavioral
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

entity ALU_Sim is
--  Port ( );
end ALU_Sim;

architecture Behavioral of ALU_Sim is

component ALU_0
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
end component;

-- Inputs
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal OP1 : std_logic_vector(15 downto 0) := (others => '0');
signal OP2 : std_logic_vector(15 downto 0) := (others => '0');
signal Instr_code : std_logic_vector(5 downto 0) := (others => '0');
signal Al_Instr_Ext : std_logic_vector(3 downto 0) := (others => '0');
signal KK_Const : std_logic_vector(7 downto 0) := (others => '0');
signal Execute : std_logic := '0';

-- Outputs
signal Carry : std_logic := '0';
signal Zero : std_logic := '0';
signal ALU_Result : std_logic_vector (15 downto 0);
constant clk_period : time := 10 ns;

begin

   uut1: ALU_0 PORT MAP(
   clk => clk,
   reset => reset,
   OP1 => OP1,
   OP2 => OP2,
   Instr_code => Instr_code,
   Al_Instr_Ext => Al_Instr_Ext,
   KK_const => KK_const,
   Execute => Execute
);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

    stim_proc: process
    begin
        wait for 100ns;
        
        reset <= '1';
        wait for clk_period * 2;
        reset <= '0';
        wait for clk_period * 2;
        
        -- Add sX, sY
        OP1 <= x"0002";
        OP2 <= x"0001";
        Instr_code <= "000010";
        Execute <= '1';
        wait for clk_period;
        Execute <= '0';
        wait for clk_period;
        
        -- Add sX, KK
        OP1 <= x"0003";
        KK_Const <= x"0003";
        Instr_code <= "000011";
        Execute <= '1';
        wait for clk_period;
        Execute <= '0';
        wait for clk_period;
        
        -- Or sX, KK
        OP1 <= x"0002";
        KK_const <= x"0000";
        Instr_code <= "000101";
        Execute <= '1';
        wait for clk_period;
        Execute <= '0';
        wait for clk_period;
        
    end process;

end Behavioral;
