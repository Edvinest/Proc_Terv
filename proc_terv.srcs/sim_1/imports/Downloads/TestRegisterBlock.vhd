--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:01:23 10/05/2020
-- Design Name:   
-- Module Name:   D:/Work/Sapientia/2018-2019/I felev/Archit/PicoBLclone/TestRegisterBlock.vhd
-- Project Name:  SapiLabProc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RegBlock
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TestRegisterBlock IS
END TestRegisterBlock;
 
ARCHITECTURE behavior OF TestRegisterBlock IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RegBlock
    PORT(
           Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           SX_addr : in STD_LOGIC_VECTOR (3 downto 0);
           SY_addr : in STD_LOGIC_VECTOR (3 downto 0);
           Dataxin : in STD_LOGIC_VECTOR (15 downto 0);
           RW : in STD_LOGIC;
           DataoutX : out STD_LOGIC_VECTOR (15 downto 0);
           DataoutY : out STD_LOGIC_VECTOR (15 downto 0)
        );
    END COMPONENT;
    
    COMPONENT DxInMux is
    Port ( DataMemOut : in STD_LOGIC_VECTOR (15 downto 0);
           PortIntoCPU : in STD_LOGIC_VECTOR (15 downto 0);
           ALUresult : in STD_LOGIC_VECTOR (15 downto 0);
           KK_const : in STD_LOGIC_VECTOR (15 downto 0);
           Dy : in STD_LOGIC_VECTOR (15 downto 0);
           MuxSet : in STD_LOGIC_VECTOR (2 downto 0);
           Dataxin : out STD_LOGIC_VECTOR (15 downto 0));
    end COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal rw : std_logic := '0';
   signal SX_addr : std_logic_vector(3 downto 0) := (others => '0');
   signal SY_addr : std_logic_vector(3 downto 0) := (others => '0');
   signal Dataxin : std_logic_vector(15 downto 0) := (others => '0');
   signal DataMemOut, PortIntoCPU, ALUresult, KK_const, Dy : std_logic_vector(15 downto 0) := (others => '0');
   signal MuxSet : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal DataoutX : std_logic_vector(15 downto 0);
   signal DataoutY : std_logic_vector(15 downto 0);
   signal Dataxin2 : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RegBlock PORT MAP (
          Clk => clk,
          Reset => reset,
          RW => rw,
          Dataxin => Dataxin,
          SX_addr => SX_addr,
          SY_addr => SY_addr,
          DataoutX => DataoutX,
          DataoutY => DataoutY
        );
        
        
   uut2: DxInMux PORT MAP(
            DataMemOut => DataMemOut,
            PortIntoCPU => PortIntoCPU,
            ALUresult => ALUresult,
            KK_const => KK_const,
            Dy => Dy,
            MuxSet => MuxSet,
            Dataxin => Dataxin2
   );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

     -- wait for clk_period*10;

      -- insert stimulus here 
		SX_addr<="0011";
		Dataxin <= x"DD00";
		rw <= '1';
		wait for clk_period;
		rw <= '0';
		wait for clk_period;

		SX_addr<="1100";
		SX_addr<="1010";
		MuxSet <= "010";
		ALUresult <= x"CCCC";
		Dataxin <= Dataxin2;
		rw <= '1';
		wait for clk_period;
		rw <= '0';
		wait for clk_period;
		
		MuxSet <= "011";
		KK_const <= x"DDDD";
		Dataxin <= Dataxin2;
		rw <= '1';
		wait for clk_period;
		rw <= '0';
		wait for clk_period;	
		
		SY_addr<="0011";
		SY_addr<="1100";
		rw <= '0';
		wait for clk_period;	
		
      wait;
   end process;

END;
